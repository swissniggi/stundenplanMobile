import 'package:flutter/material.dart';

class SnackbarText extends StatelessWidget {
  final String text;
  final Color textColor;

  SnackbarText(this.text, this.textColor);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: textColor),
    );
  }
}
