
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/core/custom_button.dart';
import 'package:whatsapp_ui/features/auth/screens/login_screen.dart';

import '../../../colors.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  navigateToLoginScreen(BuildContext context){
    Navigator.pushNamed(context, LoginScreen.nameRoute);
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height:50),
            const Text('Welcome to Whatssap',style:TextStyle(fontSize:33,fontWeight: FontWeight.w700 )),
            SizedBox(height:size.height/10),
            Image.asset('assets/bg.png',height:340,width:340),
            SizedBox(height: size.height / 9),
            const Padding(
              padding:  EdgeInsets.all(10),
              child:  Text(
                'Read our privacy Plicy. Tap "Agree and continue" to accept the Terms of Service.',
                style:TextStyle(
                  color:greyColor,
                  ),
                  textAlign: TextAlign.center,
                  ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: size.width * 0.75,
              child: CustomButton(
                text: 'AGREE AND CONTINUE',
                onPressed: ()=>navigateToLoginScreen(context),
                ),
            )
          ],
        ) ,
        ),
    );
  }
}