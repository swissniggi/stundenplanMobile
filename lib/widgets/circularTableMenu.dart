import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';

class CircularTableMenu extends StatelessWidget {
  final List<CircularMenuItem> menuItems;
  final Widget background;

  CircularTableMenu(this.menuItems, this.background);

  @override
  Widget build(BuildContext context) {
    return CircularMenu(
      alignment: Alignment.bottomCenter,
      backgroundWidget: background,
      toggleButtonColor: Theme.of(context).primaryColor,
      items: [...menuItems],
    );
  }
}
