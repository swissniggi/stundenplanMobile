import 'package:flutter/material.dart';

/// Create a customized [TextFormField].
class CustomFormField extends StatelessWidget {
  /// The text of the label of the [TextFormField].
  final String lableText;

  /// The controller into which text input should be saved.
  final TextEditingController controller;

  /// The [TextInputType] of the [TextFormField].
  final TextInputType textInputType;

  /// A boolean to determine whether the text should be obscured.
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
