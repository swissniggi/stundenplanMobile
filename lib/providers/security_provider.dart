import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../services/xmlRequest_service.dart';

class SecurityProvider with ChangeNotifier {
  LocalAuthentication _localAuth = LocalAuthentication();
  bool _canFingerprintAuth = false;
  bool _bioAuthIsEnabled = false;
  String _deviceId;

  void checkBiometrics() {
    _localAuth.canCheckBiometrics.then((value) {
      if (value) {
        _localAuth.getAvailableBiometrics().then((biometrics) {
          if (biometrics.contains(BiometricType.fingerprint)) {
            _canFingerprintAuth = true;
          }
        });
      }
    });
  }

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

  bool get canFingerprintAuth {
    return this._canFingerprintAuth;
  }

  bool get bioAuthIsEnabled {
    return this._bioAuthIsEnabled;
  }

  String get deviceId {
    return _deviceId;
  }
}
