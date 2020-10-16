import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class SecurityProvider with ChangeNotifier {
  LocalAuthentication _localAuth = LocalAuthentication();
  BiometricType _fingerprint;
  bool _canFingerprintAuth = false;
  String _deviceId;

  void checkBiometrics() {
    _localAuth.canCheckBiometrics.then((value) {
      if (value) {
        _localAuth.getAvailableBiometrics().then((biometrics) {
          if (biometrics.contains(BiometricType.fingerprint)) {
            _fingerprint = biometrics.firstWhere(
                (element) => element.index == BiometricType.fingerprint.index);
            _canFingerprintAuth = true;
          }
        });
      }
    });
  }

  void getDeviceId() {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceInfoPlugin.androidInfo.then((info) => _deviceId = info.androidId);
    } else if (Platform.isIOS) {
      deviceInfoPlugin.iosInfo
          .then((info) => _deviceId = info.identifierForVendor);
    }
  }

  BiometricType get fingerprint {
    return this._fingerprint;
  }

  bool get canFingerprintAuth {
    return this._canFingerprintAuth;
  }

  String get deviceId {
    return _deviceId;
  }
}
