import 'package:flutter/material.dart';

class WelcomeGridTile extends StatefulWidget {
  final Widget child;

  WelcomeGridTile(this.child);

  @override
  _State createState() => _State();
}

class _State extends State<WelcomeGridTile> {
  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: widget.child,
    );
  }
}
