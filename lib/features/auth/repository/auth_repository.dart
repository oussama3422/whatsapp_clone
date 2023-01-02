import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/core/repository/common_firebase_storage_repositroy.dart';
import 'package:whatsapp_ui/core/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_info_screen.dart';
import 'package:whatsapp_ui/modules/user_model.dart';
import 'package:whatsapp_ui/screens/mobile_layout_screen.dart';

final authrepositryProvider = Provider((ref) {
  return AuthRepository(auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance); 
});


class AuthRepository{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth,required this.firestore});

  // get User Data from firebase
  Future<UserModel?> getUserData()async{
   final userdata= await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if(userdata.data()!=null){
        user=UserModel.fromMap(userdata.data()!);
    }
    return user;
  }
  

  void singInWithPhone(BuildContext context,String phoneNumber)async{
    try{
        await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential)async{
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e){
            throw Exception(e.message);
          },
          codeSent: (String verificationId,int? resendTokem) async{
              Navigator.pushNamed(context, OTPScreen.routeName,arguments: verificationId);
          },
          codeAutoRetrievalTimeout: (verificationId) {},
          );
    }catch(error){
      showSnackBar(context: context, content: error.toString());
    }
  }

  void verifyOTP({required BuildContext context,required String verificationId,required String userOTP})async{
      try{
        PhoneAuthCredential credential=PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: userOTP
          );
        await auth.signInWithCredential(credential);
        Navigator.pushReplacementNamed(context, UserInfoScreen.routeName);
      } on FirebaseAuthException catch(error){
          showSnackBar(context: context, content: error.message!);
      }
  }
void saveUserDataToFirebase({
  required String name,
  required File? profilePic,
  required ProviderRef ref,
  required BuildContext context
  })async{
    try{
        String uid=auth.currentUser!.uid;
        String photoUrl='assets/avatar.png';

        if(profilePic!=null){
          photoUrl=await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase('profilePic/$uid', profilePic);
        }
        var user=UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId:[] ,
          );
          await firestore.collection('users').doc(uid).set(user.toMap());
          Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                     builder: (context)=>const MobileLayoutScreen()
                  ), 
                  (route) => false
                );
    }catch(error){
      showSnackBar(context: context, content: error.toString());
    }
}
  Stream<UserModel> userData(String userId){
   return firestore.collection('users').doc(userId).snapshots().map(
    (event) {
      return UserModel.fromMap(event.data()!);
    }
    );
 }

 void setUserState(bool isOnline)async{
  await firestore.collection('users').doc(auth.currentUser!.uid).update({'isOnline':isOnline});
 }

}