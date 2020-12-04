import 'package:flutter/material.dart';

import 'customFormField.dart';
import 'paddingButton.dart';

/// Returns a [Column] displaying the login elements.
class LoginElements extends StatefulWidget {
  final Function loginUser;

  LoginElements(this.loginUser);

  @override
  _LoginElementsState createState() => _LoginElementsState();
}

class _LoginElementsState extends State<LoginElements> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomFormField(
          'Benutzername',
          usernameController,
        ),
        CustomFormField(
          'Passwort',
          passwordController,
          obscureText: true,
        ),
        PaddingButton('Login', () {
          widget.loginUser(
              username: usernameController.text,
              password: passwordController.text);
        }),
      ],
    );
  }
}
