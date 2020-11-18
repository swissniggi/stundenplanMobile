import 'package:flutter/material.dart';

/// Return a customized [Text] to be displayed in a [Snackbar].
class SnackbarText extends StatelessWidget {
  /// The text of the created widget.
  final String text;

  /// The [Color] of the created widget.
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
