import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:spoty_try5/auth/services.dart';
import 'package:spoty_try5/screens/zcreens.dart';
import 'package:spoty_try5/auth/auth_service.dart';
import 'package:spoty_try5/auth/user_model.dart';

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
  bool _isLoading = false;

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
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
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
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 192, 16, 16)),
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
                onPressed: _isLoading ? null : _signup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Signup',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
    //Inicio de proceso
    setState(() {
      _isLoading = true;
    });

    final String email = _email.text;
    final String password = _password.text;

    // Verifica si todos los campos están llenos
    if (_name.text.isEmpty || _email.text.isEmpty || _password.text.isEmpty) {
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

    //Restricciones para la contraseña
    if (!PasswordValidator.isValid(password)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'La contraseña debe tener al menos 8 caracteres y contener al menos una mayúscula, un número y un carácter especial.'),
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
      return; // No continuar con el proceso de registro
    }

    //Crear registro Firebase Authentication
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
          _email.text, _password.text);

      if (userCredential != null) {
        final user = userCredential.user;
        await createUserDocument(user!);
        log("User Created Successfully");
        goToHome(context);
      }
    } catch (e) {
      _showErrorDialog('Error en la creación del usuario: $e');
    }

    //Fin de proceso
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
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
}
