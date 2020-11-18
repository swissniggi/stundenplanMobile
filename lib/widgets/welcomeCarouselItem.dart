import 'package:flutter/material.dart';

import 'welcomeWebView.dart';

/// Return a [Padding] containing a [WelcomeWebView] or a [IconButton].
class WelcomeCarouselItem extends StatefulWidget {
  /// The given child eiher of type [WelcomeWebView] or [IconButton].
  final Widget child;

  WelcomeCarouselItem(this.child);

  @override
  _State createState() => _State();
}

class _State extends State<WelcomeCarouselItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        color: Colors.grey,
        child: widget.child,
      ),
    );
  }
}
