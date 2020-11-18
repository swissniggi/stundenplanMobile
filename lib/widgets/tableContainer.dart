import 'package:flutter/material.dart';

/// Return a customized [Container].
class TableContainer extends StatefulWidget {
  /// The given id.
  final String id;

  /// The text of the child of the [TableContainer].
  final String childText;

  /// The [Color] of the [childText].
  final Color textStyleColor;

  /// The background-color of the [TableContainer].
  final Color decorationColor;

  TableContainer(this.childText, this.textStyleColor, this.decorationColor,
      [this.id]);

  @override
  _TableContainerState createState() => _TableContainerState();
}

/// Return a customized [Container].
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
