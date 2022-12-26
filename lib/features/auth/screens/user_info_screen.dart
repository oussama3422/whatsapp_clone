import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

import '../../../colors.dart';
import '../../../core/utils/utils.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  static const routeName='/user-info-screen';
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  TextEditingController nameController=TextEditingController();
  File? image;
  @override
  void dispose() { 
    nameController.dispose();
    super.dispose();
  }
  pickImage()async{
      image=await pickImageFromGallery(context);
      setState(() {});
  }

  void storeUserData(){
    String name=nameController.text.trim();
    if(name.isNotEmpty){
      ref.read(authControllerProvider).saveUserDataToFirebase(context, name, image);
    }
  }
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      body:SafeArea(
        child:Center(
          child: Column(
            children: [
              Stack(
                children: [
                  image==null?
                  const CircleAvatar(
                    backgroundImage:AssetImage('assets/avatar.png'),
                    radius: 64,
                  )
                  :
                  CircleAvatar(
                    backgroundImage:FileImage(image!),
                    radius: 64,
                  ),
                  Positioned(
                    bottom: -10,
                    left:90,
                    child: IconButton(
                      onPressed: ()=>pickImage(),
                      icon:const Icon(Icons.add_a_photo,color:Colors.blueGrey,size:30)
                      ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                      Container(
                          width: 300,
                          padding:const EdgeInsets.all(8),
                          child:TextField(
                            controller: nameController,
                            decoration:const InputDecoration(
                              hintText: 'Enter your name',
                            ),
                          ),
                      ),
                     IconButton(
                      onPressed: storeUserData,
                      icon: const Icon(Icons.done)
                      ),
                ],
                ),
            ],
          ),
          ) 
        )
    );
  }
}