import 'package:flutter/material.dart';

class SimpleText extends StatelessWidget {
  final String text;

  SimpleText(this.text);

  @override
  Widget build(BuildContext context) {
    return new Text(
      text,
      style: new TextStyle(fontSize: 20.0),
    );
  }
}
