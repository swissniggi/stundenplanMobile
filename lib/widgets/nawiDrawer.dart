import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../xmlRequest.dart';
import '../dropDowns.dart';
import '../main.dart';

class NawiDrawer extends StatelessWidget {
  Future<void> _goToFHNW() async {
    const url = "https://www.fhnw.ch";
    await launch(url);
  }

  void _getBack(ctx) {
    Navigator.pushReplacement(
      ctx,
      MaterialPageRoute(
          builder: (context) => DropDowns(title: 'Stundenplan FHNW')),
    );
  }

  void _logoutUser(ctx) {
    var body = new Map<String, dynamic>();
    body["function"] = 'logoutUser';
    XmlRequest.createPost(body);
    Navigator.pushReplacement(
      ctx,
      MaterialPageRoute(
        builder: (context) => MyHomePage(title: 'Stundenplan FHNW'),
      ),
    );
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
    return Drawer(
      child: Container(
        color: Color(0xfffbe400),
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
            SizedBox(
              height: 20,
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
              Icons.keyboard_return,
              () {
                _getBack(context);
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
