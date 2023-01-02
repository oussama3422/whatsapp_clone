

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/auth/repository/auth_repository.dart';

import '../../../modules/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRespositroy=ref.watch(authrepositryProvider);
  return AuthController(authRepository: authRespositroy,ref:ref);
});
final userDataAuthProvider = FutureProvider((ref) async {
  final authController=ref.watch(authControllerProvider);
  return authController.getUserData();
});
class AuthController{
    AuthRepository authRepository;
    final ProviderRef ref;
    AuthController({required this.authRepository,required this.ref});

  // get function getUserData from repository
  Future<UserModel?> getUserData()async{
    UserModel? user=await authRepository.getUserData();
    return user; 
  }
  // get signInWithPhone Function from auth repository 
  void signInWithPhone(BuildContext context,String phoneNumber)async{
      authRepository.singInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context,String verificationId,String userOTP){
    authRepository.verifyOTP(context: context, verificationId: verificationId, userOTP: userOTP);
  }

  void saveUserDataToFirebase(BuildContext context,String name,File? profilePic){
    authRepository.saveUserDataToFirebase(name: name, profilePic: profilePic, ref: ref, context: context);
  }

  Stream<UserModel>userDataById(String userId){
    return authRepository.userData(userId);
  }

 void setUserState(bool isOnline){
    authRepository.setUserState(isOnline);
  }
}