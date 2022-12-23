import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/core/error.dart';
import 'package:whatsapp_ui/core/loader.dart';
import 'package:whatsapp_ui/features/select_contacts/controller/select_contact_controller.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName='/select-contact-screen';
  const SelectContactScreen({Key? key}) : super(key: key);

  
 void selectContact(WidgetRef ref,Contact selectedContact,BuildContext context){
    ref.watch(selectContactControllerProvider).selectContact(selectedContact, context);
 }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
            title:const Text('Select contact'),
            actions: [
              IconButton(
                onPressed: (){},
                icon:const Icon(Icons.search )
                ),
              IconButton(
                onPressed: (){},
                icon:const Icon(Icons.more_vert)
                ),
            ],
        ),
      body: ref.watch(getContactProvider).when(
        data: (contactList)=>ListView.builder(
          itemCount:contactList.length,
          itemBuilder: (context, index) {
            final contact=contactList[index];
            return InkWell(
              onTap: ()=>selectContact(ref,contact,context),
              child: Padding(
                padding: const EdgeInsets.only(bottom:8.0),
                child: ListTile(
                  title: Text(
                    contact.displayName,
                    style:const TextStyle(fontSize: 18)
                    ),
                  leading:
                  contact.photo==null
                  ?
                  null
                  :
                  CircleAvatar(
                    backgroundImage:MemoryImage(contact.photo!),
                    radius: 30,
                    ),
                ),
              ),
            );
          }
          ),
        error: (error,stackTrace)=>ErrorScreen(error: error.toString()),
        loading: ()=>const Loader()
        ),
    );
  }
}