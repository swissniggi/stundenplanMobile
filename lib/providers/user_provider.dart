import 'dart:io';

import 'package:NAWI/services/xmlRequest_service.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = new User();

  set username(String username) {
    this._user.username = username;
    notifyListeners();
  }

  set profilePicture(File picture) {
    this._user.profilePicture = picture;
    notifyListeners();
  }

  Future getProfilePictureFromDB(BuildContext ctx) async {
    var body = new Map<String, dynamic>();
    body["function"] = 'getProfilePicture';
    body["username"] = username;

    Map<String, dynamic> response =
        await XmlRequestService.createPost(body, ctx, withToken: false);

    if (response['success'] == true) {
      profilePicture = File(response['profilePicture']);
    }
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
