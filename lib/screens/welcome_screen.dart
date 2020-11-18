import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:provider/provider.dart';

import '../providers/webview_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/welcomeDrawer.dart';
import '../widgets/welcomeCarouselItem.dart';
import '../widgets/welcomeWebView.dart';

/// Return a [Scaffold] displaying the welcome screen.
class WelcomeScreen extends StatefulWidget {
  /// The route name of the screen.
  static const routeName = '/welcome';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  /// Add a new [WelcomeCarouselItem] containing a [WelcomeWebView] the the screen.
  void _addWebView() async {
    String externalSource = await prompt(
      context,
      initialValue: 'www.',
      title: Text(
          'Geben Sie die Adresse der Webseite an, die Sie anzeigen möchten: '),
    );
    if (externalSource != null) {
      setState(() {
        WelcomeCarouselItem newWebView = WelcomeCarouselItem(
          WelcomeWebView(ValueKey(externalSource), externalSource),
        );
        Provider.of<WebViewProvider>(context, listen: false).newUrl =
            externalSource;
        Provider.of<WebViewProvider>(context, listen: false).newListitem =
            newWebView;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String username =
        Provider.of<UserProvider>(context, listen: false).username;
    File profilePicture =
        Provider.of<UserProvider>(context, listen: false).user.profilePicture;
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

    if (Provider.of<WebViewProvider>(context, listen: false)
        .addedSites
        .isEmpty) {
      Provider.of<WebViewProvider>(context, listen: false).initialListItem =
          WelcomeCarouselItem(
        IconButton(
          iconSize: 50,
          icon: Icon(Icons.add_box),
          color: Colors.white,
          onPressed: _addWebView,
        ),
      );

      List<String> presetSites =
          Provider.of<WebViewProvider>(context, listen: false).addedUrls;

      if (presetSites.isNotEmpty) {
        for (int i = 0; i < presetSites.length; i++) {
          WelcomeCarouselItem newWebView = WelcomeCarouselItem(
            WelcomeWebView(ValueKey(presetSites[i]), presetSites[i]),
          );
          Provider.of<WebViewProvider>(context, listen: false).initialListItem =
              newWebView;
        }
      }
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
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: profilePicture.path == ''
                          ? AssetImage('assets/img/blank-profile-picture.png')
                          : FileImage(profilePicture),
                    ),
                    Text(
                      '$salutation \n$username',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Theme.of(context).primaryColor,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
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
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                child: PageView.builder(
                  itemCount:
                      Provider.of<WebViewProvider>(context, listen: false)
                          .addedSites
                          .length,
                  controller: PageController(viewportFraction: 0.9),
                  itemBuilder: (BuildContext context, int index) {
                    return Provider.of<WebViewProvider>(context, listen: false)
                        .addedSites[index];
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
