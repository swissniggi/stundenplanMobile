import 'package:flutter/material.dart';

import 'widgets/customFormField.dart';
import 'main.dart';
import 'widgets/paddingButton.dart';
import 'widgets/showDialog.dart';
import 'xmlRequest.dart';

class Register extends StatefulWidget {
  Register({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final usernameController = TextEditingController();
  final usermailController = TextEditingController();
  final passwordController = TextEditingController();

  void _registerUser() async {
    var body = new Map<String, dynamic>();
    body["function"] = 'registerUser';
    body["username"] = usernameController.text;
    body["usermail"] = usermailController.text;
    body["password"] = passwordController.text;

    Map<String, dynamic> response = await XmlRequest.createPost(body);
    ShowDialog dialog = new ShowDialog();

    if (response['success'] == true) {
      dialog.showCustomDialog(
          'Registrierung erfolgreich',
          () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(title: 'Stundenplan FHNW'),
              )),
          context,
          [
            Text('Sie wurden erfolgreich registriert.'
                'Bitten checken Sie Ihre Mails.')
          ]);
    } else {
      dialog.showCustomDialog('Fehler', () => Navigator.of(context).pop(),
          context, [Text(response['message'])]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
