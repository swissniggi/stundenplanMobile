import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../providers/webview_provider.dart';
import '../services/xmlRequest_service.dart';
import '../widgets/showDialog.dart';

class SecurityProvider with ChangeNotifier {
  bool _bioAuthIsEnabled;
  String _deviceId;
  String _loginTime;
  String _securityToken;

  // this function has a return type of Future so it can be awaited
  Future getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      _deviceId = info.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await deviceInfoPlugin.iosInfo;
      _deviceId = info.identifierForVendor;
    }
  }

  // this function has a return type of Future so it can be awaited
  Future checkBioAuthisEnabled(BuildContext ctx) async {
    var body = new Map<String, dynamic>();
    body["function"] = 'checkBioAuth';
    body["deviceId"] = _deviceId;

    Map<String, dynamic> response =
        await XmlRequestService.createPost(body, ctx, withToken: false);

    if (response['success'] == true) {
      _bioAuthIsEnabled = response['hasBioAuth'] == "1";
    }
  }

  Future logoutUser(BuildContext ctx) async {
    FirebaseAuth.instance.signOut();

    List<String> websites =
        Provider.of<WebViewProvider>(ctx, listen: false).addedWebsites;
    var body = new Map<String, dynamic>();
    body["function"] = 'logoutUser';

    if (websites.isNotEmpty) {
      body["username"] = Provider.of<UserProvider>(ctx, listen: false).username;
      body["websites"] = jsonEncode(websites);
    }

    XmlRequestService.createPost(body, ctx);
    Navigator.of(ctx).pushReplacementNamed('/');
  }

  void logoutOnTimeOut(BuildContext ctx) {
    ShowDialog dialog = new ShowDialog();
    dialog.showCustomDialog(
      'Timed Out',
      () {
        Provider.of<SecurityProvider>(ctx, listen: false).logoutUser(ctx);
      },
      ctx,
      [Text('Ihre Session ist abgelaufen. Sie werden automatisch ausgeloggt.')],
    );
  }

  Future createSecurityToken() async {
    String loginTime = DateTime.now().toIso8601String();
    List<int> loginTimeBytes = utf8.encode(loginTime);
    _loginTime = loginTime;
    _securityToken = sha256.convert(loginTimeBytes).toString();
  }

  void showErrorDialog(BuildContext ctx, String errorMessage) {
    ShowDialog dialog = new ShowDialog();
    dialog.showCustomDialog(
      'Fehler',
      () {
        Navigator.of(ctx).pop();
      },
      ctx,
      [Text(errorMessage)],
    );
  }

  String get securityToken {
    return _securityToken.substring(0);
  }

  String get loginTime {
    return _loginTime;
  }

  bool get bioAuthIsEnabled {
    return this._bioAuthIsEnabled;
  }

  set bioAuthIsEnabled(bool isEnabled) {
    _bioAuthIsEnabled = isEnabled;
  }

  String get deviceId {
    return _deviceId;
  }
}
