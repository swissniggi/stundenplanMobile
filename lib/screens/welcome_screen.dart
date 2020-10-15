import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../providers/user_provider.dart';
import '../widgets/welcomeDrawer.dart';
import '../widgets/welcomeGridTile.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<WelcomeGridTile> _gridTiles = new List<WelcomeGridTile>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  void _addWebView() async {
    String externalSource = await prompt(context,
        title: Text(
            'Geben Sie die Adresse der Webseite an, die Sie anzeigen möchten: '));
    setState(() {
      WelcomeGridTile newWebView = WelcomeGridTile(
        WebView(
          initialUrl: 'https://$externalSource',
        ),
      );
      _gridTiles.insert(0, newWebView);
    });
  }

  @override
  Widget build(BuildContext context) {
    String username =
        Provider.of<UserProvider>(context, listen: false).currentUser.username;
    TimeOfDay currentTime = TimeOfDay.now();
    String salutation;

    if (currentTime.hour < 12) {
      salutation = 'Guten Morgen';
    } else if (currentTime.hour == 12) {
      salutation = 'En Guete';
    } else if (currentTime.hour < 17) {
      salutation = 'Guten Nachmittag';
    } else if (currentTime.hour < 20) {
      salutation = 'Guten Abend';
    } else {
      salutation = 'Gute Nacht';
    }

    initializeDateFormatting();

    if (_gridTiles.isEmpty) {
      _gridTiles.add(
        WelcomeGridTile(
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.add_box),
            color: Colors.grey,
            onPressed: _addWebView,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Stundenplan FHNW'),
      ),
      drawer: WelcomeDrawer(),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Center(
                child: Text(
                  '$salutation \n$username',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              color: Theme.of(context).accentColor,
              margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  DateFormat('EEEEE, dd.MM.yyyy', 'de_DE').format(
                    DateTime.now(),
                  ),
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                children: [
                  ..._gridTiles,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
