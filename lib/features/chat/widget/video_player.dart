import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerItem({super.key, required this.videoUrl});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
   late VideoPlayerController controller;

   bool isPlay=false;
  @override
  void initState() {
    controller=VideoPlayerController.network(widget.videoUrl)..initialize().then((value) {
      controller.setVolume(1);
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 19 / 9,
      child:Stack(
          children: [
            VideoPlayer(controller),
            IconButton(
              onPressed: (){
                if(isPlay){
                  controller.play();
                }else{
                  controller.pause();
                }
              },
              icon:Icon(isPlay?Icons.play_circle_outline_rounded:Icons.pause_circle_outline_rounded)
              )
          ],
      ),
    );
  }
}