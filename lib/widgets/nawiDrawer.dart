import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/welcome_screen.dart';
import '../providers/user_provider.dart';
import '../providers/security_provider.dart';

/// Return a [Drawer] for the [WelcomeScreen].
class NawiDrawer extends StatelessWidget {
  /// The route of the last visited screen.
  final String route;

  /// The name of the target to go to.
  final String targetName;

  NawiDrawer(this.route, this.targetName);

  /// Redirect to external webpage.
  Future<void> _goToFHNW() async {
    const url = "https://www.fhnw.ch";
    await launch(url);
  }

  /// Redirect to last visited screen.
  void _getBack(BuildContext ctx) {
    Navigator.of(ctx).pushReplacementNamed(route);
  }

  /// Redirect to [WelcomeScreen]
  void _getToMain(BuildContext ctx) {
    Navigator.of(ctx).pushReplacementNamed(WelcomeScreen.routeName);
  }

  /// Create a new row item of type [Padding].
  /// [ctx] the given [BuildContext].
  /// [text] the text for the child of the [FlatButton].
  /// [icon] the icon of the row item.
  /// [pressed] the function to be called when the [FlatButton] is pressed.
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
    String username = Provider.of<UserProvider>(context).username;
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
              Icons.open_in_browser,
              () {
                _goToFHNW();
              },
            ),
            if (!route.contains(WelcomeScreen.routeName))
              _setRowItem(
                context,
                'Zum Hauptmenü',
                Icons.home,
                () {
                  _getToMain(context);
                },
              ),
            _setRowItem(
              context,
              targetName,
              route.contains(WelcomeScreen.routeName)
                  ? Icons.home
                  : Icons.keyboard_return,
              () {
                _getBack(context);
              },
            ),
            _setRowItem(
              context,
              'Ausloggen',
              Icons.exit_to_app,
              () {
                Provider.of<SecurityProvider>(context, listen: false)
                    .logoutUser(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
