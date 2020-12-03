import 'package:NAWI/widgets/welcomeWebView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/security_provider.dart';
import '../providers/user_provider.dart';
import '../services/xmlRequest_service.dart';
import '../widgets/welcomeCarouselItem.dart';

/// A provider for the webvies of the [WelcomeScreen].
class WebViewProvider with ChangeNotifier {
  /// A [List] of the websites the user has added.
  List<String> _addedUrls = ['www.fhnw.ch'];

  /// A [List] of [WelcomeCarouselItem]s each containing a [WelcomeWebView].
  List<WelcomeCarouselItem> _addedSites = new List();

  /// Get the websites the user has set from the server.
  /// [ctx] the given [BuildContext].
  /// calls [showErrorDialog()] if an error occurs.
  Future getWebsites(BuildContext ctx) async {
    String username = Provider.of<UserProvider>(ctx, listen: false).username;

    var body = new Map<String, dynamic>();
    body["function"] = 'getWebsites';
    body["username"] = username;

    Map<String, dynamic> response =
        await XmlRequestService.createPost(body, ctx);

    if (response['success'] == true) {
      List<dynamic> sites = response['websites'];

      for (int i = 0; i < sites.length; i++) {
        newUrl = sites[i];
      }
    } else if (response['sessionTimedOut'] == true) {
      Provider.of<SecurityProvider>(ctx, listen: false).logoutOnTimeOut(ctx);
    } else {
      Provider.of<SecurityProvider>(ctx, listen: false)
          .showErrorDialog(ctx, response['message']);
    }
  }

  /// Setter for [_addesSites] before the [WelcomeScreen] gets loaded.
  set initialListItem(WelcomeCarouselItem newListItem) {
    this._addedSites.insert(0, newListItem);
  }

  /// Setter for [_addesSites] once the [WelcomeScreen] has been loaded.
  set newListitem(WelcomeCarouselItem newListItem) {
    this._addedSites.insert(0, newListItem);
    notifyListeners();
  }

  /// Setter for new URLs to be added to [_addedUrls].
  set newUrl(String newUrl) {
    this._addedUrls.add(newUrl);
  }

  /// Getter for [_addedSites].
  List<WelcomeCarouselItem> get addedSites {
    final List<WelcomeCarouselItem> addedSites = this._addedSites;
    return addedSites;
  }

  /// Getter for [_addedUrls].
  List<String> get addedUrls {
    final List<String> addedUrls = this._addedUrls;
    return addedUrls;
  }

  /// Reset all properties of this class.
  void reset() {
    _addedSites = [];
    _addedUrls = [];
  }
}
