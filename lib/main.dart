
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/view/email_verification_view.dart';
import 'package:mynotes/view/login_view.dart';
import 'package:mynotes/view/notes/create_update_note_view.dart';
import 'package:mynotes/view/notes/notes_view.dart';
import 'package:mynotes/view/registration_view.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo', 
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context)=> const LoginView(),
        registerRoute :(context) => const RegisterView(),
        notesRoute :(context) => const NotesView(),
        verifyEmailRoute: (context)=> const VerifyEmail(),
        createOrUpdateNoteRoute:(context) => const CreateUpdateNoteView(),
      },
    ),);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

   @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initializeApp(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null){
                if(user.isEmailVerified){
                  return const NotesView();
                }else{
                  return const VerifyEmail();
                }

              }else{
                return const LoginView();
              }
              
              
            default: 
              return const CircularProgressIndicator();
          }
          
        },

      );
  }
}
