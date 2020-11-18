import 'dart:io';

import 'package:flutter/material.dart';

import '../services/xmlRequest_service.dart';
import '../models/user.dart';

/// A provider for the user data.
class UserProvider with ChangeNotifier {
  /// The [User] containing all user data.
  User _user = new User();

  /// Setter for [_user.username].
  set username(String username) {
    this._user.username = username;
    notifyListeners();
  }

  /// Setter for [_user.profilePicture].
  set profilePicture(File picture) {
    this._user.profilePicture = picture;
    notifyListeners();
  }

  /// Get the profile picture from the server.
  /// [ctx] the given [BuildContext].
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

  /// Getter for [_user.username].
  String get username {
    final String currentUsername = this._user.username;
    return currentUsername;
  }

  /// Getter for [_user].
  User get user {
    final User currentUser = this._user;
    return currentUser;
  }

  /// Reset all properties of this class.
  void reset() {
    _user = new User();
  }
}
