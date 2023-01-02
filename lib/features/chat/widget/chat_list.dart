import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/core/loader.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/features/chat/widget/sender_message_card.dart';
import 'package:whatsapp_ui/modules/message.dart';

import 'my_message_card.dart';

class ChatList extends ConsumerStatefulWidget {
 final String receiverUserId; 

   const ChatList({Key? key,required this.receiverUserId}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}
class _ChatListState extends ConsumerState<ChatList> {

  final ScrollController messageContoller=ScrollController();
  @override
  void dispose() {
    messageContoller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream:ref.read(chatControllerProvider).chatStream(widget.receiverUserId),
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Loader();
        }
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        messageContoller.jumpTo(messageContoller.position.maxScrollExtent);
      });
      return ListView.builder(
        controller: messageContoller,
        itemCount:snapshot.data!.length,
        itemBuilder: (context, index) {
          final messageData=snapshot.data![index];
          var timeSent=DateFormat.Hm().format(messageData.timeSent);
          if (messageData.snderId == FirebaseAuth.instance.currentUser!.uid) {
            return MyMessageCard(
              message: messageData.text,
              date: timeSent,
              type: messageData.type,
            );
          }
          return SenderMessageCard(
            message: messageData.text,
            date:timeSent,
            type:messageData.type ,
          );
        },
      );
  });
  }
}
