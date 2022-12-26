

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_ui/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_ui/modules/chat_contact.dart';

import '../../../modules/message.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository=ref.watch(chatrepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController{
  final ChatRepository chatRepository;
  final ProviderRef ref ;

  ChatController({required this.chatRepository,required this.ref});

    // send Text through input field
    void sendTextMessage(BuildContext context,String text,String receiverUserId){
      ref.read(userDataAuthProvider).whenData((senderUser) => 
              chatRepository.sendTextMessage(context: context, text: text, receiverUserId: receiverUserId, senderUser: senderUser!)
         );
    }
   /// get chat Contact from chat repository
    Stream<List<ChatContact>> chatContacts(){
      return chatRepository.getChatContacts();
    }

  Stream<List<Message>> chatStream(String receiverUserId){
        return chatRepository.getChatStream(receiverUserId);
      }


}