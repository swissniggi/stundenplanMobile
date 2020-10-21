import 'package:flutter/material.dart';

class WelcomeCarouselItem extends StatefulWidget {
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
