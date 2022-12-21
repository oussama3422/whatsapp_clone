import 'dart:html';

import 'package:flutter/material.dart';
import 'package:whatsapp_ui/colors.dart';

class LoginScreen extends StatefulWidget {
  //create routeName 
  static const nameRoute='login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController controllerNumber=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title:const Text('Enter your phone number'),
        centerTitle: true,
        backgroundColor: backgroundColor,
        ),
        body:Column(
          children: [
            const Text('Whatssap will need to verify your phone number'),
            TextButton(onPressed: (){}, child:const Text('Pick Country')),
            const SizedBox(width: 5),
            Row(
              children: [
                const Text('+212'),
                const SizedBox(width: 10),
                SizedBox(
                  width:size.width*0.7,
                  child:TextField(
                    controller:controllerNumber ,
                    decoration:const InputDecoration(
                      hintText: 'phone nunber'
                    )
                  )
                  )
              ],
            )
          ],
          )
    );
  }
}