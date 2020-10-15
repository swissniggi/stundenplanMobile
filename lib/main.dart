import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/tabledata_provider.dart';
import 'providers/user_provider.dart';
import 'screens/timeTable_screen.dart';
import 'screens/dropDowns_screen.dart';
import 'screens/register_screen.dart';
import 'widgets/customFormField.dart';
import 'widgets/paddingButton.dart';
import 'widgets/showDialog.dart';
import 'xmlRequest.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<TableDataProvider>(
          create: (_) => TableDataProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Stundenplan FHNW',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => MyHomePage(),
          Register.routeName: (ctx) => Register(),
          DropDowns.routeName: (ctx) => DropDowns(),
          TimeTable.routeName: (ctx) => TimeTable(),
        },
      ),
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
      Provider.of<UserProvider>(context, listen: false).username =
          response['username'];
      Navigator.of(context).pushReplacementNamed(DropDowns.routeName);
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
