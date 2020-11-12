import 'package:cloud_firestore/cloud_firestore.dart';
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

  void setFirebaseUser() {
    FirebaseFirestore.instance.collection('users').doc(user.id).set({
      'id': user.id,
      'username': user.username,
      'profilePhoto': user.profilePhoto
    });
  }

  Future getFirebaseUser(String userId) async {
    User firebaseUser;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) {
      Map<String, dynamic> userData = snapshot.data();
      firebaseUser.id = userData['id'];
      firebaseUser.username = userData['username'];
      firebaseUser.profilePhoto = userData['profilePhoto'];
    });

    _user = firebaseUser;

    notifyListeners();
  }
}
