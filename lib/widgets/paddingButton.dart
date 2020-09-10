import 'package:flutter/material.dart';

class PaddingButton extends StatelessWidget {
  final String buttonText;
  final Function onPressedFunc;

  PaddingButton(this.buttonText, this.onPressedFunc);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ButtonTheme(
        minWidth: 140,
        child: new RaisedButton(
          onPressed: onPressedFunc,
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
