import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import '../utilities/dialogs/error_dialog.dart';


class LoginView extends StatefulWidget {
  const LoginView({Key? key}): super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {  
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
    @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('login view'),),
      body: Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'enter email'),
              ),
              TextField(
                controller: _password, 
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(hintText: 'write password'),
              ),
              TextButton(onPressed: () async{
                
                final email = _email.text;
                final password = _password.text;
                try{
                   await AuthService.firebase().logIn(email: email, password: password);
                   final user = AuthService.firebase().currentUser;
                   if (user?.isEmailVerified ?? false){
                     await Navigator.of(context).pushNamedAndRemoveUntil(notesRoute, (route) => false);
                   }else{
                    await Navigator.of(context).pushNamedAndRemoveUntil(verifyEmailRoute, (route) => false);
                   }
                   }on UserNotFoundAuthException {
                     await showErrorDialog(context, 'user not found');
                   }on WrongPasswordAuthException {
                     await showErrorDialog(context, 'wrong password');
                   }on GenericAuthException{
                     await showErrorDialog(context, 'something went wrong');
                   }
              },child: const Text('login'),),
              TextButton(onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(registerRoute, (route) => false);
              }, child: const Text("Haven't registered yet? Register here!"))
            ],
          )
    );
  }
}

