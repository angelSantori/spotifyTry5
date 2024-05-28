import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spoty_try5/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:spoty_try5/screens/zcreens.dart';
import 'package:spoty_try5/widgets/zwidgets.dart';
import 'package:spoty_try5/auth/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
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
              const Text("Login",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
              const SizedBox(height: 50),
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
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Signup',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
              ),
              const SizedBox(height: 10),
              //const CustomButton(label: "Signin with Google"),
              const SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Already have an account? "),
                InkWell(
                  onTap: () => goToSignup(context),
                  child:
                      const Text("Signup", style: TextStyle(color: Colors.red)),
                )
              ]),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }

  goToSignup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );

  _login() async {
    //Inicio de proceso
    setState(() {
      _isLoading = true;
    });

    // Verifica si todos los campos están llenos
    if (_email.text.isEmpty || _password.text.isEmpty) {
      // Muestra un AlertDialog con el mensaje de error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Por favor, completa todos los campos.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el AlertDialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      setState(() {
        _isLoading = false;
      });
      return; // Detiene el proceso de registro
    }

    //Verifica si es un correo valido
    final String email = _email.text;
    if (!EmailValidator.isValid(email)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Ingresa un correo valido'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el AlertDialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    //Intento acceder
    final user =
        await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);

    if (user != null) {
      log("User Logged In");
      goToHome(context);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Usuario o contraseña incorrectos'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el AlertDialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    setState(() {
      _isLoading = false;
    });
  }
}
