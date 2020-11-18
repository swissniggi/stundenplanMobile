import 'package:flutter/material.dart';

class ShowDialog {
  /// Call [showDialog()] with the given parameters.
  /// [titleText] the text ot the title of the dialog.
  /// [onPressedFunction] the function to be called when the [FlatButton] is pressed.
  /// [context] the given [BuildContext].
  /// [bodyChildren] the children of the [ListBody].
  void showCustomDialog(String titleText, Function onPressedFunc,
      BuildContext context, List<Widget> bodyChildren) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleText),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ...bodyChildren,
              ],
            ),
          ),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: onPressedFunc,
            ),
          ],
        );
      },
    );
  }
}
