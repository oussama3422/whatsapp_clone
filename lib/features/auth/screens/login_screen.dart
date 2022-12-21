import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/colors.dart';

import '../../../core/custom_button.dart';

class LoginScreen extends StatefulWidget {
  //create routeName 
  static const nameRoute='/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Country? country;
  TextEditingController controllerNumber=TextEditingController();


  pickCountry(){
    showCountryPicker(
      context: context,
      onSelect: (Country _country){
      setState((){
        country=_country;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title:const Text('Enter your phone number'),
        centerTitle: true,
        backgroundColor: backgroundColor,
        ),
        body:Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              const Text('Whatssap will need to verify your phone number'),
              TextButton(
                onPressed: pickCountry,
                child:const Text('Pick Country')
                ),
              const SizedBox(width: 5),
              Row(
                children: [
                  if(country!=null)
                    Text('+${country!.countryCode}'),
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
              ),
              SizedBox(height:size.height * 0.6),
              SizedBox(
                width:90,
                child:CustomButton(text: 'NEXT', onPressed: (){})
                )
            ],
            ),
        )
    );
  }
}