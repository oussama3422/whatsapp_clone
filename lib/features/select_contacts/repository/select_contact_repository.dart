import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/core/utils/utils.dart';
import 'package:whatsapp_ui/modules/user_model.dart';

final selectContactRepositoryProvider=Provider((ref){
  return SelectContactRepository(firestore: FirebaseFirestore.instance);
  });


class SelectContactRepository{
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  Future<List<Contact>> getContact() async{
     List<Contact> contacts=[];
    try{
        if(await FlutterContacts.requestPermission()){
         contacts=await FlutterContacts.getContacts(withProperties: true);
        }
    }catch(error){
        debugPrint(error.toString());
    }
    return contacts;
  }

  void selecteContact({required Contact selectedContact,required BuildContext context})async{
    try{
        var userCollection=await firestore.collection('users').get();
        bool isFound=false;
        for(var document in userCollection.docs){
          var userData=UserModel.fromMap(document.data());
          print(selectedContact.phones[0].number);
        }
    }catch(error){
      showSnackBar(context: context, content: error.toString());
    }
  }
}