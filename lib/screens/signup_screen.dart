import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spoty_try5/auth/services.dart';
import 'package:spoty_try5/widgets/zwidgets.dart';
import 'package:spoty_try5/screens/zcreens.dart';
import 'package:spoty_try5/auth/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PasswordVisibilityToggle>(
      create: (_) => PasswordVisibilityToggle(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const Spacer(),
              const Text("Signup",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 50,
              ),
              CustomTextField2(
                hint: "Enter Name",
                label: "Name",
                controller: _name,
              ),
              const SizedBox(height: 20),
              CustomTextField2(
                hint: "Enter Email",
                label: "Email",
                controller: _email,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s'))
                ],
              ),
              const SizedBox(height: 20),
              Consumer<PasswordVisibilityToggle>(
                builder: (context, passwordVisibility, child) {
                  return TextField(
                    controller: _password,
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      labelText: "Contraseña",
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisibility.obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: passwordVisibility.togglePasswordVisibility,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 192, 16, 16)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 192, 16, 16), width: 2),
                      ),
                    ),
                    obscureText: passwordVisibility.obscureText,
                  );
                },
              ),
              const SizedBox(height: 30),
              CustomButton(
                label: "Signup",
                onPressed: _signup,
              ),
              const SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Already have an account? "),
                InkWell(
                  onTap: () => goToLogin(context),
                  child:
                      const Text("Login", style: TextStyle(color: Colors.red)),
                )
              ]),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

  _signup() async {
    final user =
        await _auth.createUserWithEmailAndPassword(_email.text, _password.text);
    if (user != null) {
      log("User Created Succesfully");
      goToHome(context);
    }
  }
}
