import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void showSnackBar({required BuildContext context,required String content}){
 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}