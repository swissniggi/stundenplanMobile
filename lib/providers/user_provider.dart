import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User user = new User();

  set username(String username) {
    this.user.username = username;
    notifyListeners();
  }

  String get username {
    final String currentUsername = this.user.username;
    return currentUsername;
  }

  User get currentUser {
    final User currentUser = this.user;
    return currentUser;
  }
}
