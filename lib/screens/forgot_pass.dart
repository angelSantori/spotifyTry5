import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spoty_try5/auth/auth_service.dart';
import 'package:spoty_try5/auth/services.dart';
import 'package:spoty_try5/widgets/button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = AuthService();
  final _email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter email to send you a password reset email",
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField2(
              controller: _email,
              hint: "Enter email",
              label: "Email",
              inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s'))
                ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              label: "Send email",
              onPressed: () async {
                await _auth.sendPasswordResetLink(_email.text);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                  "An email for password reset has been sent to your email.",
                )));
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
