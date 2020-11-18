import 'package:flutter/material.dart';

/// Return a simple customized [Text].
class SimpleText extends StatelessWidget {
  /// The text of the created widget.
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
