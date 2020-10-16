import 'package:flutter/material.dart';

import '../widgets/customFormField.dart';
import '../widgets/paddingButton.dart';
import '../widgets/showDialog.dart';
import '../services/xmlRequest_service.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final usermailController = TextEditingController();
  final passwordController = TextEditingController();

  void _registerUser() async {
    var body = new Map<String, dynamic>();
    body["function"] = 'registerUser';
    body["username"] = usernameController.text;
    body["usermail"] = usermailController.text;
    body["password"] = passwordController.text;

    Map<String, dynamic> response = await XmlRequestService.createPost(body);
    ShowDialog dialog = new ShowDialog();

    if (response['success'] == true) {
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
      dialog.showCustomDialog(
        'Fehler',
        () => Navigator.of(context).pop(),
        context,
        [
          Text(
            response['message'],
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stundenplan FHNW'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
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
        ),
      ),
    );
  }
}