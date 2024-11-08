import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('verify email')),
      body: Column(
        children: [
          const Text("We've sent you an email.Please open the link to verify its you."),
          const Text("If you have not received an email yet, please click on the below button to get another email"),
          TextButton(onPressed: ()async{
            await AuthService.firebase().sendEmailVerification();
          }, child: const Text('send email verification'),),
          const Text('After verifying, try logging in.'),
          TextButton(onPressed: ()async{
            await AuthService.firebase().logOut();
            Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
          }, child: const Text('Login'),)
        ],
      ),
    );
  }
}

