import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// return a [InAppWebView] with the given [externalSource] as url.
class WelcomeWebView extends StatefulWidget {
  /// The key of this widget.
  final Key key;

  /// The url for the web view.
  final String externalSource;

  WelcomeWebView(this.key, this.externalSource) : super(key: key);

  @override
  _WelcomeWebViewState createState() => _WelcomeWebViewState();
}

class _WelcomeWebViewState extends State<WelcomeWebView> {
  @override
  Widget build(BuildContext context) {
    final String url = widget.externalSource;
    return InAppWebView(
      key: ValueKey(url),
      initialUrl: 'https://$url',
    );
  }
}
