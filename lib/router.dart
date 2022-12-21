import 'package:flutter/material.dart';
import 'package:whatsapp_ui/core/error.dart';
import 'package:whatsapp_ui/features/auth/screens/login_screen.dart';

Route<dynamic> genereteRoute(RouteSettings setting){
  switch (setting.name) {
    case LoginScreen.nameRoute:
        return MaterialPageRoute(builder: (context)=>const LoginScreen());
    default:
      return MaterialPageRoute(builder: (context)=>const Scaffold(
        body:ErrorScreen(error: 'This Page doesn\'t exist')
      ));
  }
}