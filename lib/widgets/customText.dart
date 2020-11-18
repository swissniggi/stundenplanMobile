import 'package:flutter/material.dart';

/// Create a [GestureDetector] containing a customized [Text].
class CustomText extends StatelessWidget {
  /// The text to be displayed.
  final String text;

  /// A boolean to determine the color of the text.
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
