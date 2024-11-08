
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../utilities/dialogs/error_dialog.dart';



class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text('Register view'),),
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
                  await AuthService.firebase().createUser(email: email, password: password);
                  await AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(verifyEmailRoute);
    
                }on WeakPasswordAuthException{
                    await showErrorDialog(context, 'weak password');
                  }on EmailAlreadyInUseAuthException{
                    await showErrorDialog(context, 'email already in use');
                  }on InvalidEmailAuthException{
                    await showErrorDialog(context, 'invalid email');
                  }on GenericAuthException{
                    await showErrorDialog(context, 'something went wrog');
                  }
                
              },child: const Text('sign up'),),
              TextButton(onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
              }, child: const Text('login'))
            ],
          ),
    );
  }
}


