import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/security_provider.dart';
import '../services/xmlRequest_service.dart';
import 'customFormField.dart';
import 'paddingButton.dart';
import 'showDialog.dart';

/// Returns a [Column] displaying the register elements.
class RegisterElements extends StatefulWidget {
  @override
  _RegisterElementsState createState() => _RegisterElementsState();
}

class _RegisterElementsState extends State<RegisterElements> {
  final usernameController = TextEditingController();
  final usermailController = TextEditingController();
  final passwordController = TextEditingController();

  /// Send the given register data to the server
  /// and redirect to the main screen if successful.
  /// otherwise call [showErrorDialog()].
  void _registerUser() async {
    var body = new Map<String, dynamic>();
    body["function"] = 'registerUser';
    body["username"] = usernameController.text;
    body["usermail"] = usermailController.text;
    body["password"] = passwordController.text;

    Map<String, dynamic> response =
        await XmlRequestService.createPost(body, context, withToken: false);

    if (response['success'] == true) {
      ShowDialog dialog = new ShowDialog();
      dialog.showCustomDialog(
        'Registrierung erfolgreich',
        () => Navigator.of(context).pushReplacementNamed('/'),
        context,
        [
          Text('Sie wurden erfolgreich registriert.'
              'Bitten checken Sie Ihre Mails.'),
        ],
      );
    } else {
      Provider.of<SecurityProvider>(context, listen: false)
          .showErrorDialog(context, response['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomFormField(
          'Benutzername',
          usernameController,
        ),
        CustomFormField(
          'Email',
          usermailController,
          textInputType: TextInputType.emailAddress,
        ),
        CustomFormField(
          'Passwort',
          passwordController,
          obscureText: true,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PaddingButton('Registrieren', _registerUser),
          ],
        ),
      ],
    );
  }
}
