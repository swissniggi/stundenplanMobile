import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WelcomeWebView extends StatefulWidget {
  final Key key;
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
