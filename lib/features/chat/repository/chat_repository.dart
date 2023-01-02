import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/core/enums/message_enum.dart';
import 'package:whatsapp_ui/core/repository/common_firebase_storage_repositroy.dart';
import 'package:whatsapp_ui/core/utils/utils.dart';
import 'package:whatsapp_ui/modules/chat_contact.dart';
import 'package:whatsapp_ui/modules/message.dart';

import '../../../modules/user_model.dart';
final chatrepositoryProvider = Provider((ref) {
  return ChatRepository(firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance) ;
});


class ChatRepository{
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({required this.firestore,required this.auth});


// create users geter 
   get _users => firestore.collection('users');
/// get messages as stream of Querysnapshot
  Stream<List<Message>> getChatStream(String receiverUserId){
    return firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(receiverUserId).collection('messages').orderBy('timeSent').snapshots().map((event){
      List<Message> messages=[];
      for(var docuemnt in event.docs){
        messages.add(Message.fromMap(docuemnt.data()));
      }
      return messages;
    });
  }
/// get chat contact as a Stream
   Stream<List<ChatContact>> getChatContacts(){
      return _users.doc(auth.currentUser!.uid).collection('chats').snapshots().asyncMap(
        (event)async{
       List<ChatContact> contacts=[];

       for(var document in event.docs){
        var chatContact=ChatContact.fromMap(document.data());
        var userData=await _users.doc(chatContact.contactId).get();
        var user=UserModel.fromMap(userData.data()!);
        contacts.add(ChatContact(
          name: user.name,
          profilePic: user.profilePic,
          contactId: chatContact.contactId,
          timeSent: chatContact.timeSent,
          lastMessage: chatContact.lastMessage,
          ));
       }
       return contacts;
      });
   }
/// save data to contact sub collection in firebase
 void _saveMessageToMessageSubCollections({
   required  String recieverUserId,
   required  String text,
   required DateTime timeSent,
   required String messageId,
   required String username,
   required  recieverUsername,
   required MessageEnum messageType,
   })async{
      final message=Message(
        snderId: auth.currentUser!.uid,
        reciverid: recieverUserId,
         text: text,
         type: messageType,
         timeSent: timeSent,
         messageId: messageId,
         isSeen: false
         );

    // users -> sender user id -> receiver id -> messages ->message id -> set messgae
    await _users
    .doc(auth.currentUser!.uid)
    .collection('chats')
    .doc(recieverUserId)
    .collection('messages')
    .doc(messageId)
    .set(message.toMap());
    // users ->  receiver id -> sender  id  -> messages ->message id -> set messgae
    await  _users
    .doc(recieverUserId)
    .collection('chats')
    .doc(auth.currentUser!.uid)
    .collection('messages')
    .doc(messageId)
    .set(message.toMap());
   }

 /// save data to contact sub collection
 void _saveDataToContactSubCollection(
  UserModel senderUserData,
  UserModel recieverUserData,
  String text,
  DateTime timeSent,
  String recieverUserId
 )async{
    // users -> receiver user id -> chats -> curreent user id -> set data
    var receiveChatContact=ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.phoneNumber,
        contactId: senderUserData.uid,
        timeSent: timeSent,
        lastMessage: text
        );
    await _users.doc(recieverUserId).collection('chats').doc(auth.currentUser!.uid).set(receiveChatContact.toMap());
    // users -> curreent user id  -> chats -> receiver user id -> set data
      var senderChatContact=ChatContact(
        name: recieverUserData.name,
        profilePic: recieverUserData.phoneNumber,
        contactId: recieverUserData.uid,
        timeSent: timeSent,
        lastMessage: text
        );
    await _users.doc(auth.currentUser!.uid).collection('chats').doc(recieverUserId).set(receiveChatContact.toMap());
      

 }
  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverUserId,
    required UserModel senderUser,
    })async{
      //users -> sender id -> messages -> message id -> store message
      try{
        var timeSent=DateTime.now();
        UserModel receiverData;
        var userDataMap=await _users.doc(receiverUserId).get();
        
        receiverData=UserModel.fromMap(userDataMap.data()!);
        //users -> receiver user id => chats -> curreent user id -> set data
        // save data
        var messageId=const Uuid().v1(); 
        _saveDataToContactSubCollection(
          senderUser,
          receiverData,
          text,
          timeSent,
          receiverUserId,
        );
        _saveMessageToMessageSubCollections(
          recieverUserId: receiverUserId,
          text:text,
          timeSent: timeSent,
          messageType: MessageEnum.text,
          username:senderUser.name,
          recieverUsername:receiverData.name ,
          messageId: messageId,
        );
      }catch(error){
        showSnackBar(context: context, content: error.toString());
      }
  }

  // send File Message
   void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverUserId,
    required UserModel senderUserData,
    required MessageEnum messageEnum,
    required ProviderRef ref,
    })async{
      try{
        var timeSent=DateTime.now();
        var messageId=const Uuid().v1();
        String imageUrl=await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase('chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId', file);
        UserModel reciverUserData;
        var userDataMap=await _users.doc(receiverUserId).get();
        reciverUserData=UserModel.fromMap(userDataMap.data()!);
        String contactMessage;
        switch (messageEnum) {
          case MessageEnum.image:
            contactMessage='📷 Photo';
            break;
          case MessageEnum.video:
            contactMessage='📸 Video';
            break;
          case MessageEnum.audio:
            contactMessage='🎵 Audio';
            break;
          case MessageEnum.gif:
            contactMessage='GIF';
            break;
          default:
            contactMessage='GIF';
        }
          // save Data to contact sub collections
        _saveDataToContactSubCollection(
          senderUserData,
          reciverUserData,
          contactMessage,
          timeSent,
          receiverUserId
          );
           // save message to message subcollections
          _saveMessageToMessageSubCollections(
            recieverUserId: receiverUserId,
             text: imageUrl,
             timeSent: timeSent,
             messageId: messageId,
             username: senderUserData.name,
             recieverUsername: reciverUserData.name,
             messageType: messageEnum
             );
             print('it  all is ok check somthing else :::::');
      }catch(error){
            showSnackBar(context: context, content: error.toString());
      }
    }
}