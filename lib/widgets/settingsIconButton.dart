import 'package:flutter/material.dart';

/// Return a customized [FlatButton].
class SettingsIconButton extends StatelessWidget {
  /// The text of the label of the [FlatButton].
  final String labelText;

  /// The icon of the [FlatButton].
  final IconData icon;

  /// The function to be called when the [FlatButton] is pressed.
  final Function onPressed;

  /// A boolean to determine the color of the icon.
  final bool eliminator;

  SettingsIconButton(
      this.labelText, this.icon, this.onPressed, this.eliminator);

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: eliminator ? Colors.green : Colors.grey,
      ),
      label: Text(
        labelText,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
