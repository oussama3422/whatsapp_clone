import 'package:flutter/material.dart';
import 'package:whatsapp_ui/core/error.dart';
import 'package:whatsapp_ui/features/auth/screens/login_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_ui/features/auth/screens/user_info_screen.dart';

Route<dynamic> genereteRoute(RouteSettings setting){
  switch (setting.name) {
    case LoginScreen.nameRoute:
        return MaterialPageRoute(builder: (context)=>const LoginScreen());
    case OTPScreen.routeName:
         final verificationId=setting.arguments as String; 
         return MaterialPageRoute(
              builder: (context)=>OTPScreen(verificationId: verificationId,)
          );
    case UserInfoScreen.routeName:
         return MaterialPageRoute(
              builder: (context)=>const UserInfoScreen()
          );
    default:
      return MaterialPageRoute(builder: (context)=>const Scaffold(
        body:ErrorScreen(error: 'This Page doesn\'t exist')
      ));
  }
}