

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRespositroy=ref.watch(authrepositryProvider);
  return AuthController(authRepository: authRespositroy);
});

class AuthController{
    AuthRepository authRepository;
    AuthController({required this.authRepository});


  void signInWithPhone(BuildContext context,String phoneNumber)async{
      authRepository.singInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context,String verificationId,String userOTP){
    authRepository.verifyOTP(context: context, verificationId: verificationId, userOTP: userOTP);
  }
}