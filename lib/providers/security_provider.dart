import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

import '../services/xmlRequest_service.dart';

class SecurityProvider with ChangeNotifier {
  bool _bioAuthIsEnabled = false;
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

  bool get bioAuthIsEnabled {
    return this._bioAuthIsEnabled;
  }

  String get deviceId {
    return _deviceId;
  }
}
