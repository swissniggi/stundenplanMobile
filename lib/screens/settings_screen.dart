import 'dart:io';

import 'package:NAWI/widgets/snackbarText.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import 'welcome_screen.dart';
import '../providers/security_provider.dart';
import '../providers/user_provider.dart';
import '../services/xmlRequest_service.dart';
import '../widgets/nawiDrawer.dart';
import '../widgets/settingsIconButton.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  LocalAuthentication _localAuth = LocalAuthentication();
  File _profilePic;

  // ignore: missing_return
  Future<bool> _setProfilePhoto(ImageSource source) async {
    ImagePicker picker = new ImagePicker();
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile == null) {
      return false;
    }

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(pickedFile.path);
    final file = File(pickedFile.path);

    final savedImage = await file.copy('${appDir.path}/$fileName');

    var body = new Map<String, dynamic>();
    body["function"] = 'saveProfilePicture';
    body["username"] =
        Provider.of<UserProvider>(context, listen: false).username;
    body["profilePicture"] = savedImage.path;

    Map<String, dynamic> response =
        await XmlRequestService.createPost(body, context);

    if (response['success'] == true) {
      setState(() {
        Provider.of<UserProvider>(context, listen: false).profilePicture =
            savedImage;
        _profilePic = savedImage;
      });

      return true;
    } else if (response['sessionTimedOut'] == true) {
      Provider.of<SecurityProvider>(context, listen: false)
          .logoutOnTimeOut(context);
    } else if (response.containsKey('message')) {
      Provider.of<SecurityProvider>(context, listen: false)
          .showErrorDialog(context, response['message']);
    }
  }

  Future _setBioAuth(BuildContext context) async {
    bool didAuthenticate = await _localAuth.authenticateWithBiometrics(
        localizedReason: 'Mit Fingerprint anmelden');

    if (didAuthenticate) {
      var body = new Map<String, dynamic>();
      body["function"] = 'saveDeviceId';
      body["username"] =
          Provider.of<UserProvider>(context, listen: false).username;
      body["deviceId"] =
          Provider.of<SecurityProvider>(context, listen: false).deviceId;

      Map<String, dynamic> response =
          await XmlRequestService.createPost(body, context);

      if (response['sessionTimedOut'] == true) {
        Provider.of<SecurityProvider>(context, listen: false)
            .logoutOnTimeOut(context);
      } else if (response.containsKey('message')) {
        Provider.of<SecurityProvider>(context, listen: false)
            .showErrorDialog(context, response['message']);
      }

      return response['success'];
    }

    return false;
  }

  Future _deleteFingerprint(BuildContext context) async {
    var body = new Map<String, dynamic>();
    body["function"] = 'deleteDeviceId';
    body["username"] =
        Provider.of<UserProvider>(context, listen: false).username;

    Map<String, dynamic> response =
        await XmlRequestService.createPost(body, context);

    if (response['sessionTimedOut'] == true) {
      Provider.of<SecurityProvider>(context, listen: false)
          .logoutOnTimeOut(context);
    } else if (response.containsKey('message')) {
      Provider.of<SecurityProvider>(context, listen: false)
          .showErrorDialog(context, response['message']);
    }
  }

  Future _onSetBioAuthPressed(bool bioAuthIsEnabled) async {
    if (!bioAuthIsEnabled) {
      bool authenticated = await _setBioAuth(context);

      if (authenticated) {
        setState(() {
          Provider.of<SecurityProvider>(context, listen: false)
              .bioAuthIsEnabled = true;
        });
      }
    } else {
      _deleteFingerprint(context);
      setState(() {
        Provider.of<SecurityProvider>(context, listen: false).bioAuthIsEnabled =
            false;
      });
    }

    final snackBar = SnackBar(
      content: SnackbarText('Status geändert', Colors.green),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _onSetPhotoPressed() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: 115,
          child: Column(
            children: [
              FlatButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();
                  bool success = await _setProfilePhoto(ImageSource.camera);

                  final snackBar = SnackBar(
                    content: success
                        ? SnackbarText('Foto gespeichert', Colors.green)
                        : SnackbarText('Ups, da lief etwas schief', Colors.red),
                  );
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                },
                icon: Icon(Icons.camera),
                label: Text(
                  'Foto schiessen',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Divider(color: Colors.grey),
              FlatButton.icon(
                onPressed: () async {
                  Navigator.of(context).pop();
                  bool success = await _setProfilePhoto(ImageSource.gallery);

                  final snackBar = SnackBar(
                    content: success
                        ? SnackbarText('Foto gespeichert', Colors.green)
                        : SnackbarText('Ups, da lief etwas schief', Colors.red),
                  );
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                },
                icon: Icon(Icons.folder),
                label: Text(
                  'Aus Galerie',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool bioAuthIsEnabled =
        Provider.of<SecurityProvider>(context, listen: false).bioAuthIsEnabled;

    _profilePic =
        Provider.of<UserProvider>(context, listen: false).user.profilePicture;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Stundenplan FHNW'),
      ),
      drawer: NawiDrawer(WelcomeScreen.routeName, 'Zum Hauptmenü'),
      body: Container(
        child: Column(
          children: [
            SettingsIconButton(
              'Login via Fingerprint',
              Icons.fingerprint,
              () {
                _onSetBioAuthPressed(bioAuthIsEnabled);
              },
              bioAuthIsEnabled,
            ),
            Divider(color: Colors.grey),
            SettingsIconButton(
              _profilePic.path == ''
                  ? 'Profilfoto hochladen'
                  : 'Profilfoto ändern',
              Icons.photo,
              () {
                _onSetPhotoPressed();
              },
              _profilePic.path != '',
            ),
            Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
