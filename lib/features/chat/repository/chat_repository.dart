import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_ui/core/enums/message_enum.dart';
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


/// get messages as stream of Querysnapshot
  Stream<List<Message>> getChatStream(String receiverUserId){
    return firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(receiverUserId).collection('messages').snapshots().map((event){
      List<Message> messages=[];
      for(var docuemnt in event.docs){
        messages.add(Message.fromMap(docuemnt.data()));
      }
      return messages;
    });
  }
/// get chat contact as a Stream
   Stream<List<ChatContact>> getChatContacts(){
      return firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').snapshots().asyncMap(
        (event)async{
       List<ChatContact> contacts=[];

       for(var document in event.docs){
        var chatContact=ChatContact.fromMap(document.data());
        var userData=await firestore.collection('users').doc(chatContact.contactId).get();
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
    await firestore.collection('users')
    .doc(auth.currentUser!.uid)
    .collection('chats')
    .doc(recieverUserId)
    .collection('messages')
    .doc(messageId)
    .set(message.toMap());
    // users ->  receiver id -> sender  id  -> messages ->message id -> set messgae
    await  firestore.collection('users')
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
    await firestore.collection('users').doc(recieverUserId).collection('chats').doc(auth.currentUser!.uid).set(receiveChatContact.toMap());
    // users -> curreent user id  -> chats -> receiver user id -> set data
      var senderChatContact=ChatContact(
        name: recieverUserData.name,
        profilePic: recieverUserData.phoneNumber,
        contactId: recieverUserData.uid,
        timeSent: timeSent,
        lastMessage: text
        );
    await firestore.collection('users').doc(auth.currentUser!.uid).collection('chats').doc(recieverUserId).set(receiveChatContact.toMap());
      

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
        var userDataMap=await firestore.collection('users').doc(receiverUserId).get();
        
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
}