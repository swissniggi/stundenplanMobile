import 'package:flutter/material.dart';

class CustomFormField {
  TextFormField setLoginField(
      String lableText, TextEditingController controller) {
    return new TextFormField(
        style: new TextStyle(fontSize: 20.0, height: 2.0, color: Colors.black),
        decoration: InputDecoration(
          labelText: lableText,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        ),
        autocorrect: false,
        controller: controller);
  }
}
