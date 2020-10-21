import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../services/xmlRequest_service.dart';
import '../widgets/welcomeCarouselItem.dart';
import '../widgets/welcomeWebView.dart';

class WebViewProvider with ChangeNotifier {
  List<String> _addedWebsites = new List();
  List<WelcomeCarouselItem> _addedSites = new List();

  Future getWebsites(BuildContext ctx) async {
    String username = Provider.of<UserProvider>(ctx, listen: false).username;

    var body = new Map<String, dynamic>();
    body["function"] = 'getWebsites';
    body["username"] = username;

    Map<String, dynamic> response = await XmlRequestService.createPost(body);

    if (response['success'] == true) {
      List<dynamic> sites = response['websites'];

      for (int i = 0; i < sites.length; i++) {
        newWebsite = sites[i];
      }
    }
  }

  set initialListItem(WelcomeCarouselItem newListItem) {
    this._addedSites.insert(0, newListItem);
  }

  set newListitem(WelcomeCarouselItem newListItem) {
    this._addedSites.insert(0, newListItem);
    notifyListeners();
  }

  set newWebsite(String newWebsite) {
    this._addedWebsites.add(newWebsite);
  }

  List<WelcomeCarouselItem> get addedSites {
    final List<WelcomeCarouselItem> addedSites = this._addedSites;
    return addedSites;
  }

  List<String> get addedWebsites {
    final List<String> addedWebsites = this._addedWebsites;
    return addedWebsites;
  }
}
