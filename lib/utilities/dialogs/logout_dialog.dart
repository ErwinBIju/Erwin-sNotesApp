import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialogue(BuildContext context){
  return showGenericDialog(
    context: context  ,
    title: 'log out', 
    content: 'Are you sure you want to log out?', 
    optionsBuilder: ()=>{
      'cancel': false,
      'Log Out': true,
    }).then((value) => value ?? false);
}