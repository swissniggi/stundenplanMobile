import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final bool isDisabled;

  CustomText(this.text, {this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        text,
        style: TextStyle(
            color: isDisabled
                ? Theme.of(context).unselectedWidgetColor
                : Theme.of(context).textTheme.headline6.color),
      ),
      onTap: isDisabled ? () {} : null,
    );
  }
}
