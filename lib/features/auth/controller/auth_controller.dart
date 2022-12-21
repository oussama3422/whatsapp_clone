

import 'package:flutter/cupertino.dart';
import 'package:whatsapp_ui/features/auth/repository/auth_repository.dart';

class AuthController{
    AuthRepository authRepository;
    AuthController({required this.authRepository});


  void signInWithPhone(BuildContext context,String phoneNumber)async{
      authRepository.singInWithPhone(context, phoneNumber);
  }
}