import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'screens/examTables_screen.dart';
import 'screens/moduleTables_screen.dart';
import 'screens/dropDowns_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/settings_screen.dart';
import 'providers/webview_provider.dart';
import 'providers/tabledata_provider.dart';
import 'providers/user_provider.dart';
import 'providers/security_provider.dart';
import 'services/xmlRequest_service.dart';
import 'widgets/loginElements.dart';
import 'widgets/registerElements.dart';

/// Main function.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

/// Main class.
class MyApp extends StatelessWidget {
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
          WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          DropDownsScreen.routeName: (ctx) => DropDownsScreen(),
          ModuleTablesScreen.routeName: (ctx) => ModuleTablesScreen(),
          ExamTablesScreen.routeName: (ctx) => ExamTablesScreen(),
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
  int _index = 0;
  bool _isLoading = false;
  bool _isLogin = true;

  /// Display fingerprint login prompt and.
  /// call [_loginUser()] when successfull.
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

  /// Send the given login data to server
  /// and redirect to welcome page if successfull.
  /// otherwise call [showErrorDialog()].
  /// [withFingerprint] a boolean to determine whether the user
  /// tries to login using a finger print; default `false`.
  void _loginUser(
      {String username, String password, bool withFingerprint = false}) async {
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
      body["username"] = username;
      body["password"] = password;
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

  @override
  Widget build(BuildContext context) {
    if (!_isLoading && _isLogin) {
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
                  ToggleSwitch(
                    minWidth: 150.0,
                    minHeight: 60.0,
                    fontSize: 16.0,
                    initialLabelIndex: _index,
                    activeBgColor: Theme.of(context).primaryColor,
                    activeFgColor: Colors.black,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.grey[900],
                    labels: ['Login', 'Registrieren'],
                    onToggle: (index) {
                      setState(() {
                        _index = index;
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                  _isLogin ? LoginElements(_loginUser) : RegisterElements(),
                ],
              ),
            ),
    );
  }
}
