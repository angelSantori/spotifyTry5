import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importa este paquete para usar TextInputFormatter

class CustomTextField2 extends StatelessWidget {
  final String hint;
  final String label;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;

  CustomTextField2({
    required this.hint,
    required this.label,
    required this.controller,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
      ),
      inputFormatters: inputFormatters,
    );
  }
}
