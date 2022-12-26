import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/chat/controller/chat_controller.dart';

import '../../../colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomChatField({Key? key,required this.receiverUserId}) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton=false;
  final TextEditingController messageController=TextEditingController();


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
  @override
  Widget build(BuildContext context) {
    return Row(
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
                      IconButton(icon:const Icon(Icons.emoji_emotions, color: Colors.grey,),onPressed: (){},),
                      IconButton(icon:const Icon(Icons.gif, color: Colors.grey,),onPressed: (){},),
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width:100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:  [
                      IconButton(icon:const Icon(Icons.camera_alt, color: Colors.grey,),onPressed: (){},),
                      IconButton(icon:const Icon(Icons.attach_file, color: Colors.grey,),onPressed: (){},),
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
        )
      ],
    );
  }
}