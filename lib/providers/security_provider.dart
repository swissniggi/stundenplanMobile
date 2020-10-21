import 'dart:convert';
import 'dart:io';

import 'package:NAWI/providers/user_provider.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/webview_provider.dart';
import '../services/xmlRequest_service.dart';

class SecurityProvider with ChangeNotifier {
  bool _bioAuthIsEnabled;
  String _deviceId;

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
  Future checkBioAuthisEnabled() async {
    var body = new Map<String, dynamic>();
    body["function"] = 'checkBioAuth';
    body["deviceId"] = _deviceId;

    Map<String, dynamic> response = await XmlRequestService.createPost(body);

    if (response['success'] == true) {
      _bioAuthIsEnabled = response['hasBioAuth'] == "1";
    }
  }

  void logoutUser(ctx) async {
    List<String> websites =
        Provider.of<WebViewProvider>(ctx, listen: false).addedWebsites;
    var body = new Map<String, dynamic>();
    body["function"] = 'logoutUser';

    if (websites.isNotEmpty) {
      body["username"] = Provider.of<UserProvider>(ctx, listen: false).username;
      body["websites"] = jsonEncode(websites);
    }

    XmlRequestService.createPost(body);
    Navigator.of(ctx).pushReplacementNamed('/');
  }

  bool get bioAuthIsEnabled {
    return this._bioAuthIsEnabled;
  }

  String get deviceId {
    return _deviceId;
  }
}
