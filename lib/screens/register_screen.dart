import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/security_provider.dart';
import '../services/xmlRequest_service.dart';
import '../widgets/customFormField.dart';
import '../widgets/paddingButton.dart';
import '../widgets/showDialog.dart';

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
    String errorMessage = '';

    try {
      var body = new Map<String, dynamic>();
      body["function"] = 'registerUser';
      body["username"] = usernameController.text;
      body["usermail"] = usermailController.text;
      body["password"] = passwordController.text;

      // register user in fhnw-db
      Map<String, dynamic> response =
          await XmlRequestService.createPost(body, context, withToken: false);
      ShowDialog dialog = new ShowDialog();

      if (response['success'] == true) {
        // register user in firebase
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: usermailController.text, password: response['pwHash']);

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
        throw Exception(response['message']);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        errorMessage =
            'Ein Benutzer mit der eingegebenen Emailadresse existiert bereits.';
      } else {
        errorMessage = e.toString();
      }
    } catch (e) {
      errorMessage = e.toString();
    }

    if (errorMessage != '') {
      Provider.of<SecurityProvider>(context, listen: false)
          .showErrorDialog(context, errorMessage);
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
