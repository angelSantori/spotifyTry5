import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Add expreg
class CustomTextField2 extends StatelessWidget {
  final String hint;
  final String label;
  final bool isPassword;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;

  CustomTextField2({
    required this.hint,
    required this.label,
    this.isPassword = false,
    required this.controller,
    this.inputFormatters,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      inputFormatters: inputFormatters,
    );
  }
}

//Ver contraseña
class PasswordVisibilityToggle extends ChangeNotifier {
  bool _obscureText = true;

  bool get obscureText => _obscureText;

  void togglePasswordVisibility() {
    _obscureText = !_obscureText;
    notifyListeners();
  }
}

//Validar contraseña
class PasswordValidator {
  // Expresión regular para validar la contraseña
  static final RegExp regex = RegExp(
    r'^(?=.*[A-Z])(?=.*[!@#\$^&*~()_+\[\]{}|;:\",.<>?/])(?=.*[0-9])(?=.*[a-z]).{8,}$',
  );

  static bool isValid(String password) {
    return regex.hasMatch(password);
  }
}

//Validar Correo
class EmailValidator {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&\*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\.com$',
  );

  static bool isValid(String email) {
    return _emailRegExp.hasMatch(email);
  }
}