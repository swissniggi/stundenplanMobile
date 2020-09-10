import 'package:flutter/material.dart';

class TableContainer extends StatelessWidget {
  final String childText;
  final Color textStyleColor;
  final Color decorationColor;

  TableContainer(this.childText, this.textStyleColor, this.decorationColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          childText,
          textAlign: TextAlign.center,
          style: TextStyle(color: textStyleColor),
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: decorationColor,
      ),
    );
  }
}
