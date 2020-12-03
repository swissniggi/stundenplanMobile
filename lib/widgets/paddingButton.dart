import 'package:flutter/material.dart';

/// Return a [Padding] containing a customized [RaisedButton].
class PaddingButton extends StatelessWidget {
  /// The text of the [RaisedButton].
  final String buttonText;

  /// The function to be called when the [RaisedButton] is pressed.
  final Function onPressedFunc;

  PaddingButton(this.buttonText, this.onPressedFunc);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ButtonTheme(
        minWidth: 210,
        height: 50,
        child: RaisedButton(
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
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
