import 'package:flutter/material.dart';

class TableContainer extends StatefulWidget {
  final String id;
  final String childText;
  final Color textStyleColor;
  final Color decorationColor;

  TableContainer(this.childText, this.textStyleColor, this.decorationColor,
      [this.id]);

  @override
  _TableContainerState createState() => _TableContainerState();
}

class _TableContainerState extends State<TableContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          widget.childText,
          textAlign: TextAlign.center,
          style: TextStyle(color: widget.textStyleColor),
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: widget.decorationColor,
      ),
    );
  }
}
