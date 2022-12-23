import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_ui/features/select_contacts/repository/select_contact_repository.dart';


final getContactProvider=FutureProvider((ref){
  final selectContactRepo= ref.watch(selectContactRepositoryProvider);
  return selectContactRepo.getContact();
});


final selectContactProvider=Provider((ref){
  final selectContactRepo=ref.watch(selectContactRepositoryProvider);
  return SelectContactController(
    selectContactRepository:selectContactRepo ,
    ref: ref
    );
});

class SelectContactController{
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;
  SelectContactController({required this.selectContactRepository,required this.ref});


  void selectContact(Contact selectedContact,BuildContext context){
    selectContactRepository.selecteContact(selectedContact: selectedContact, context: context);
  }
}
