import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = new User();

  set username(String username) {
    this._user.username = username;
    notifyListeners();
  }

  String get username {
    final String currentUsername = this._user.username;
    return currentUsername;
  }

  User get user {
    final User currentUser = this._user;
    return currentUser;
  }
}
