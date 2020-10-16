import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/xmlRequest_service.dart';
import '../providers/user_provider.dart';
import '../screens/dropDowns_screen.dart';
import '../screens/settings_screen.dart';

class WelcomeDrawer extends StatelessWidget {
  Future<void> _goToFHNW() async {
    const url = "https://www.fhnw.ch";
    await launch(url);
  }

  void _getToTopicSelection(ctx) {
    Navigator.of(ctx).pushReplacementNamed(DropDownsScreen.routeName);
  }

  void _getToSettings(ctx) {
    Navigator.of(ctx).pushReplacementNamed(SettingsScreen.routeName);
  }

  void _logoutUser(ctx) {
    var body = new Map<String, dynamic>();
    body["function"] = 'logoutUser';
    XmlRequestService.createPost(body);
    Navigator.of(ctx).pushReplacementNamed('/');
  }

  Widget _setRowItem(
      BuildContext ctx, String text, IconData icon, Function pressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Icon(icon),
          FlatButton(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            onPressed: pressed,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String username = Provider.of<UserProvider>(context).currentUser.username;
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Image.asset("assets/img/fhnw.jpg"),
                  ),
                ),
                Container(
                  width: 200,
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'NAWI-Menü',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(4),
              margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Color(0xff050262),
                ),
              ),
              child: Text(
                'Angemeldet als $username',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).indicatorColor,
                ),
              ),
            ),
            _setRowItem(
              context,
              'FHNW-Homepage',
              Icons.home,
              () {
                _goToFHNW();
              },
            ),
            _setRowItem(
              context,
              'Zur Fachauswahl',
              Icons.select_all,
              () {
                _getToTopicSelection(context);
              },
            ),
            _setRowItem(
              context,
              'Settings',
              Icons.settings,
              () {
                _getToSettings(context);
              },
            ),
            _setRowItem(
              context,
              'Ausloggen',
              Icons.exit_to_app,
              () {
                _logoutUser(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}