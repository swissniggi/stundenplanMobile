import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String lableText;
  final TextEditingController controller;
  final TextInputType textInputType;
  final bool obscureText;

  CustomFormField(
    this.lableText,
    this.controller, {
    this.textInputType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: TextStyle(fontSize: 20.0, height: 2.0, color: Colors.black),
        decoration: InputDecoration(
          labelText: lableText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        ),
        keyboardType: textInputType,
        obscureText: obscureText,
        autocorrect: false,
        controller: controller);
  }
}
