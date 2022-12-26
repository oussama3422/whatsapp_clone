import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_ui/core/loader.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_ui/info.dart';
import 'package:whatsapp_ui/modules/message.dart';
import 'package:whatsapp_ui/widgets/my_message_card.dart';
import 'package:whatsapp_ui/widgets/sender_message_card.dart';

class ChatList extends ConsumerWidget {
  final String receiverUserId; 
  const ChatList({Key? key,required this.receiverUserId}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return StreamBuilder<List<Message>>(
      stream:ref.read(chatControllerProvider).chatStream(receiverUserId),
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Loader();
        }
      return ListView.builder(
        itemCount:snapshot.data!.length,
        itemBuilder: (context, index) {
          final messageData=snapshot.data![index];
          var timeSent=DateFormat.Hm().format(messageData.timeSent);
          if (messages[index]['isMe'] == true) {
            return MyMessageCard(
              message: messageData.text,
              date: timeSent,
            );
          }
          return SenderMessageCard(
            message: messageData.text,
            date:timeSent,
          );
        },
      );
  });
  }
}