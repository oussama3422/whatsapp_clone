import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/core/enums/message_enum.dart';
import 'package:whatsapp_ui/features/chat/widget/video_player.dart';

class DisplayTextImageGif extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayTextImageGif({super.key,required this.message,required this.type});

  @override
  Widget build(BuildContext context) {
    return 
    type==MessageEnum.text
         ?
         Text(message,style: const TextStyle(fontSize: 16),)
         :
         type==MessageEnum.video
         ?
          VideoPlayerItem(videoUrl: message)
         :
         CachedNetworkImage(
          imageUrl: message,
         );
  }
}