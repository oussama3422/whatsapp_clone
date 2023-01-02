import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/core/utils/utils.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';

import '../../../colors.dart';
import '../../../core/enums/message_enum.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomChatField({Key? key,required this.receiverUserId}) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton=false;
  final TextEditingController messageController=TextEditingController();
  bool isShowEmojiXontroller=false;
  FocusNode focusNode=FocusNode();

  void hideEmojiContainer(){
    setState(() {
      isShowEmojiXontroller=false;
    });
  }
  //shwo emoji Container
  void showEmojiContainer(){
    setState(() {
      isShowEmojiXontroller=true;
    });
  }
  //showKeyboard
  void showKeyboard()=>focusNode.requestFocus();
  //hide keyboard
  void hideKyeboard()=>focusNode.unfocus();
  //toggoleEmojiKeybaodKeyContainer;
  void toggleEmojiKeyboadConainer(){
    if(isShowEmojiXontroller){
      showKeyboard();
      hideEmojiContainer();
    }else{
      hideKyeboard();
      showEmojiContainer();
    }
  }
  @override
  void dispose() { 
    messageController.dispose();
    super.dispose();
  }

  void sendTextmessage()async
  {
    if(isShowSendButton){
      ref.read(chatControllerProvider).sendTextMessage(
          context,
          messageController.text.trim(),
          widget.receiverUserId
        );
     setState(() {
        messageController.text='';
      });
    }
  }

  //send message Method
  void sendFileMessage(File file,MessageEnum messageEnum){
     ref.read(chatControllerProvider).sendFileMessage(context, file, widget.receiverUserId, messageEnum);
  }
  // selectImage Method
  void selectImage()async{
    File? image=await pickImageFromGallery(context);
    if(image!=null){
        sendFileMessage(image, MessageEnum.image);
    }
  }
  // select Video Method
  void selectVideo()async{
    File? video=await pickVideoFromGallery(context);
    if(video!=null){
        sendFileMessage(video, MessageEnum.video);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
              controller:messageController ,
              onChanged: (val){
                if(val.isNotEmpty){
                  setState(() {
                  isShowSendButton=true;               
                  });
                }else{
                  setState(() {
                    isShowSendButton=false;
                  });
                }
              },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon:  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon:const Icon(
                                Icons.emoji_emotions,
                                color: Colors.grey,
                                ),
                              onPressed: toggleEmojiKeyboadConainer,
                              ),
                          IconButton(
                            icon:const Icon(
                                Icons.gif,
                                color: Colors.grey,
                                ),  
                              onPressed: (){},
                            ),
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width:100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:  [
                          IconButton(
                            icon:const Icon(Icons.camera_alt, color: Colors.grey,),
                            onPressed: selectImage,
                            ),
                          IconButton(
                            icon:const Icon(Icons.attach_file, color: Colors.grey,),
                            onPressed: selectVideo,
                            ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
             Padding(
              padding:const  EdgeInsets.only(bottom:8.0,right:2,left:2),
              child:  CircleAvatar(
                radius: 25,
                backgroundColor:const  Color(0xFF128C7E),
                child:InkWell(
                  child: Icon(isShowSendButton? Icons.send:Icons.mic_none_sharp),
                  onTap:sendTextmessage,
                  )
                ),
            ),
            
          ],
        ),
        isShowEmojiXontroller? SizedBox(
              height:310,
              child: EmojiPicker(
                onEmojiSelected: ((category, emoji) {
                  messageController.text=messageController.text+emoji.emoji;
                } ),
              ),
              ):const SizedBox(),
      ],
    );
  }


}