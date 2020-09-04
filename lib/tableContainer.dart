import 'package:flutter/material.dart';

class TableContainer {
  Container setTableContainer(
      String childText, Color textStyleColor, Color decorationColor) {
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
