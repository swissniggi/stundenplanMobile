import 'dart:io';

import 'package:NAWI/models/user.dart';
import 'package:NAWI/providers/user_provider.dart';
import 'package:NAWI/screens/welcome_screen.dart';
import 'package:NAWI/widgets/nawiDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _showProfilePhotoChanger() {
    User user = Provider.of<UserProvider>(context, listen: false).user;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SingleChildScrollView(
          child: Column(
            children: [
              FlatButton(
                onPressed: () {
                  _setProfileFoto(user);
                },
                child: Text(user.profilePhoto == null
                    ? 'Profilfoto hochladen'
                    : 'Profilfoto ändern'),
              )
            ],
          ),
        );
      },
    );
  }

  void _setProfileFoto(User user) async {
    ImagePicker picker = new ImagePicker();
    PickedFile profilePhoto = await picker.getImage(source: ImageSource.camera);

    if (profilePhoto == null) {
      return;
    }

    File finalPhoto = File(profilePhoto.path);
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .update({'profilePhoto': finalPhoto});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NAWI-Chat'),
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: _showProfilePhotoChanger,
        ),
      ),
      drawer: NawiDrawer(WelcomeScreen.routeName, 'Zum Hauptmenü'),
      body: Expanded(
        child: SingleChildScrollView(),
      ),
    );
  }
}
