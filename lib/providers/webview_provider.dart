import 'package:flutter/material.dart';

import '../widgets/welcomeCarouselItem.dart';

class WebviewProvider with ChangeNotifier {
  List<WelcomeCarouselItem> _addedSites = new List();

  set newListitem(WelcomeCarouselItem newListItem) {
    this._addedSites.insert(0, newListItem);
    notifyListeners();
  }

  List<WelcomeCarouselItem> get addedSites {
    final List<WelcomeCarouselItem> addedSites = this._addedSites;
    return addedSites;
  }
}
