import 'package:flutter/material.dart';

class SettingsIconButton extends StatelessWidget {
  final String labelText;
  final IconData icon;
  final Function onPressed;
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
