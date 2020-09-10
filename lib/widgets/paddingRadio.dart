import 'package:flutter/material.dart';

class PaddingRadio extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function onChangedFunc;

  PaddingRadio(this.value, this.groupValue, this.onChangedFunc);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.35, 5, 0, 0),
      child: new Radio(
          value: value, groupValue: groupValue, onChanged: onChangedFunc),
    );
  }
}
