import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tabledata_provider.dart';
import '../providers/user_provider.dart';
import '../providers/webview_provider.dart';
import '../services/xmlRequest_service.dart';
import '../widgets/showDialog.dart';

/// A provider for security.
class SecurityProvider with ChangeNotifier {
  /// A boolean to determine whether authentication by fingerprint is enabled.
  bool _bioAuthIsEnabled;

  /// The id of the device in use.
  String _deviceId;

  /// The time when the user has loged in.
  String _loginTime;

  /// A random security token.
  String _securityToken;

  /// Get the id of the device in use.
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

  /// Get data from the server to determine whether authentication by fingerprint was enabled.
  /// [ctx] the given [BuildContext]
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

  /// Logout the current user.
  /// [ctx] the given [BuildContext].
  /// redirects to the main screen.
  Future logoutUser(BuildContext ctx) async {
    List<String> websites =
        Provider.of<WebViewProvider>(ctx, listen: false).addedUrls;
    var body = new Map<String, dynamic>();
    body["function"] = 'logoutUser';

    if (websites.isNotEmpty) {
      body["username"] = Provider.of<UserProvider>(ctx, listen: false).username;
      body["websites"] = jsonEncode(websites);
    }

    await XmlRequestService.createPost(body, ctx);

    Provider.of<TableDataProvider>(ctx, listen: false).reset();
    Provider.of<WebViewProvider>(ctx, listen: false).reset();
    Provider.of<UserProvider>(ctx, listen: false).reset();
    reset();

    Navigator.of(ctx).pushReplacementNamed('/');
  }

  /// Logout the current user when the security token is no longer valid.
  /// [ctx] the given [BuildContext].
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

  /// Create a security token
  Future createSecurityToken() async {
    String loginTime = DateTime.now().toIso8601String();
    List<int> loginTimeBytes = utf8.encode(loginTime);
    _loginTime = loginTime;
    _securityToken = sha256.convert(loginTimeBytes).toString();
  }

  /// Show a dialog displaying the given error message.
  /// [ctx] the given [BuildContext].
  /// [errorMessage] the given error message.
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

  /// Getter for [_securityToken].
  String get securityToken {
    return _securityToken.substring(0);
  }

  /// Getter for [_loginTime].
  String get loginTime {
    return _loginTime;
  }

  /// Getter for [_bioAuthEnabled].
  bool get bioAuthIsEnabled {
    return this._bioAuthIsEnabled;
  }

  /// Getter for [_deviceId].
  String get deviceId {
    return _deviceId;
  }

  /// Setter for [_bioAuthEnabled].
  set bioAuthIsEnabled(bool isEnabled) {
    _bioAuthIsEnabled = isEnabled;
  }

  /// Reset all properties of this class.
  void reset() {
    _bioAuthIsEnabled = false;
    _deviceId = null;
    _loginTime = null;
    _securityToken = null;
  }
}
