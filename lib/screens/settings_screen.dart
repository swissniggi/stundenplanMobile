import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../providers/security_provider.dart';
import '../providers/user_provider.dart';
import 'welcome_screen.dart';
import '../services/xmlRequest_service.dart';
import '../widgets/nawiDrawer.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  LocalAuthentication _localAuth = LocalAuthentication();
  bool _bioAuthIsEnabled = false;

  Future _setBioAuth(BuildContext context, bool value) async {
    bool didAuthenticate = await _localAuth.authenticateWithBiometrics(
        localizedReason: 'Mit Fingerprint anmelden');

    if (didAuthenticate) {
      var body = new Map<String, dynamic>();
      body["function"] = 'saveDeviceId';
      body["username"] =
          Provider.of<UserProvider>(context, listen: false).username;
      body["deviceId"] =
          Provider.of<SecurityProvider>(context, listen: false).deviceId;

      Map<String, dynamic> response = await XmlRequestService.createPost(body);
      return response['success'];
    }

    // return nothing
    return false;
  }

  void _deleteFingerprint(BuildContext context, bool value) {
    var body = new Map<String, dynamic>();
    body["function"] = 'deleteDeviceId';
    body["username"] = Provider.of<UserProvider>(context).username;

    XmlRequestService.createPost(body);
  }

  @override
  Widget build(BuildContext context) {
    bool canFingerprintAuth =
        Provider.of<SecurityProvider>(context, listen: false)
            .canFingerprintAuth;
    return Scaffold(
      appBar: AppBar(
        title: Text('Stundenplan FHNW'),
      ),
      drawer: NawiDrawer(WelcomeScreen.routeName, 'Zum Hauptmenü'),
      body: Container(
        child: canFingerprintAuth
            ? Row(
                children: [
                  Switch(
                    value: _bioAuthIsEnabled,
                    onChanged: (value) async {
                      if (value) {
                        bool authenticated = await _setBioAuth(context, value);

                        if (authenticated) {
                          setState(() {
                            _bioAuthIsEnabled = value;
                          });
                        }
                      } else {
                        _deleteFingerprint(context, value);
                        setState(() {
                          _bioAuthIsEnabled = value;
                        });
                      }
                    },
                  ),
                  Text('Anmeldung via Fingerprint'),
                ],
              )
            : Container(),
      ),
    );
  }
}