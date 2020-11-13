import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import 'screens/timeTable_screen.dart';
import 'screens/dropDowns_screen.dart';
import 'screens/register_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/settings_screen.dart';
import 'providers/webview_provider.dart';
import 'providers/tabledata_provider.dart';
import 'providers/user_provider.dart';
import 'providers/security_provider.dart';
import 'services/xmlRequest_service.dart';
import 'widgets/customFormField.dart';
import 'widgets/paddingButton.dart';

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
        ChangeNotifierProvider<SecurityProvider>(
          create: (_) => SecurityProvider(),
        ),
        ChangeNotifierProvider<WebViewProvider>(
          create: (_) => WebViewProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Stundenplan FHNW',
        theme: ThemeData(
          primaryColor: Color(0xfffbe400),
          indicatorColor: Color(0xff050262),
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => MyHomePage(),
          RegisterScreen.routeName: (ctx) => RegisterScreen(),
          WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          DropDownsScreen.routeName: (ctx) => DropDownsScreen(),
          TimeTableScreen.routeName: (ctx) => TimeTableScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  void _getBioAuthData(BuildContext context) async {
    await Provider.of<SecurityProvider>(context, listen: false).getDeviceId();
    await Provider.of<SecurityProvider>(context, listen: false)
        .checkBioAuthisEnabled(context);

    if (Provider.of<SecurityProvider>(context, listen: false)
        .bioAuthIsEnabled) {
      LocalAuthentication localAuth = LocalAuthentication();
      bool didAuthenticate = await localAuth.authenticateWithBiometrics(
          localizedReason: 'Mit Fingerprint anmelden');

      if (didAuthenticate) {
        _loginUser(withFingerprint: true);
      }
    }
  }

  void _loginUser({bool withFingerprint = false}) async {
    setState(() {
      _isLoading = true;
    });

    var body = new Map<String, dynamic>();
    SecurityProvider securityProvider =
        Provider.of<SecurityProvider>(context, listen: false);
    await securityProvider.createSecurityToken();

    body["function"] = 'loginUser';
    body["loginTime"] = securityProvider.loginTime;

    if (!withFingerprint) {
      body["username"] = usernameController.text;
      body["password"] = passwordController.text;
    } else {
      body["deviceId"] = securityProvider.deviceId;
    }

    Map<String, dynamic> response =
        await XmlRequestService.createPost(body, context);

    if (response['success'] == true) {
      Provider.of<UserProvider>(context, listen: false).username =
          response['username'];

      await Provider.of<WebViewProvider>(context, listen: false)
          .getWebsites(context);
      await Provider.of<UserProvider>(context, listen: false)
          .getProfilePictureFromDB(context);

      Navigator.of(context).pushReplacementNamed(WelcomeScreen.routeName);
    } else {
      Provider.of<SecurityProvider>(context, listen: false)
          .showErrorDialog(context, response['message']);

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _registerUser() {
    Navigator.of(context).pushReplacementNamed(RegisterScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading) {
      _getBioAuthData(context);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Stundenplan FHNW'),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset("assets/img/fhnw.jpg"),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
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
