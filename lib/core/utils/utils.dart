import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar({required BuildContext context,required String content}){
 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

Future<File?> pickImageFromGallery(BuildContext context)async{
  File? image;
  try{
      final pickedImage=await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage!=null){
        image=File(pickedImage.path);
      }
  }catch(error){
    showSnackBar(context: context, content: error.toString());
  }
  return image;
}

// pick video from Gallery
Future<File?> pickVideoFromGallery(BuildContext context)async{
  File? video;
  try{
      final pickedVideo=await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (pickedVideo!=null){
        video=File(pickedVideo.path);
      }
  }catch(error){
    showSnackBar(context: context, content: error.toString());
  }
  return video;
}

// pick Image 
pickGIF(BuildContext context){
  try{



  }catch(error){
    showSnackBar(context: context, content: error.toString());
  }
}