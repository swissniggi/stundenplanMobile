import 'package:flutter/material.dart';

class PaddingRadio {
  Padding setPaddingRadio(
      int value, int groupValue, BuildContext context, Function onChangedFunc) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.35, 5, 0, 0),
      child: new Radio(
          value: value, groupValue: groupValue, onChanged: onChangedFunc),
    );
  }
}
