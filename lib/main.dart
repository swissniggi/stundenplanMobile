import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/customFormField.dart';
import 'widgets/paddingButton.dart';
import 'widgets/showDialog.dart';
import 'xmlRequest.dart';
import 'dropDowns.dart';
import 'register.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stundenplan FHNW',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => MyHomePage(),
        Register.routeName: (ctx) => Register(),
        DropDowns.routeName: (ctx) => DropDowns(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DropDowns(
            username: response['username'],
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
    Navigator.of(context).pushReplacementNamed(Register.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffbe400),
        title: Text('Stundenplan FHNW'),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset("assets/img/fhnw.jpg"),
        ),
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
              'Passwort',
              passwordController,
              obscureText: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PaddingButton('Login', _loginUser),
                PaddingButton('Registrieren', _registerUser)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
