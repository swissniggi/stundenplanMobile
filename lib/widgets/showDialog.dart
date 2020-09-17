import 'package:flutter/material.dart';

class ShowDialog {
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
