import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/core/utils/utils.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_info_screen.dart';

final authrepositryProvider = Provider((ref) {
  return AuthRepository(auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance); ;
});


class AuthRepository{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth,required this.firestore});


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
}