
import 'package:flutter/material.dart';

class TextFieldsEmailLogin extends StatelessWidget {
  const TextFieldsEmailLogin({
    super.key,
    required this.label,
    required this.controller,
    required this.keyboardType,
    required this.obsureText,
  });
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obsureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obsureText,
      decoration: InputDecoration(
          
          filled: true,
          label: Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          )),
    );
  }
}
