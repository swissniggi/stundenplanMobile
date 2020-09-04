import 'package:flutter/material.dart';

class PaddingButton {
  Padding setPaddingButton(String buttonText, Function onPressedFunc) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ButtonTheme(
        minWidth: 140,
        child: new RaisedButton(
          onPressed: onPressedFunc,
          child: Text(
            buttonText,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
