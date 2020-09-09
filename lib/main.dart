import 'package:flutter/material.dart';

import 'customFormField.dart';
import 'paddingButton.dart';
import 'xmlRequest.dart';
import 'dropDowns.dart';
import 'register.dart';
import 'showDialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stundenplan FHNW',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'Stundenplan FHNW'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void _loginUser() async {
    var body = new Map<String, dynamic>();
    body["function"] = 'loginUser';
    body["username"] = usernameController.text;
    body["password"] = passwordController.text;

    Map<String, dynamic> response = await XmlRequest.createPost(body);
    ShowDialog dialog = new ShowDialog();

    if (response['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DropDowns(
            title: 'Stundenplan FHNW',
            username: usernameController.text,
          ),
        ),
      );
    } else {
      dialog.showCustomDialog(
        'Fehler',
        () {
          Navigator.of(context).pop();
        },
        context,
        [Text(response['message'])],
      );
    }
  }

  void _registerUser() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Register(title: 'Stundenplan FHNW')));
  }

  @override
  Widget build(BuildContext context) {
    CustomFormField field = new CustomFormField();
    PaddingButton button = new PaddingButton();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffbe400),
        title: Text(widget.title),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset("lib/img/fhnw.jpg"),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            field.setLoginField('Benutzername', usernameController),
            field.setLoginField('Passwort', passwordController),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                button.setPaddingButton('Login', _loginUser),
                button.setPaddingButton('Registrieren', _registerUser)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
