import 'package:flutter/material.dart';

/// Return a [Padding] containing a [Radio]button.
class PaddingRadio extends StatelessWidget {
  /// The value of the [Radio]button.
  final int value;

  /// The identifier of the group the [Radio]button belongs to.
  final int groupValue;

  /// The function to be called when the state of the [Radio]button changes.
  final Function onChangedFunc;

  PaddingRadio(this.value, this.groupValue, this.onChangedFunc);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.35, 5, 0, 0),
      child:
          Radio(value: value, groupValue: groupValue, onChanged: onChangedFunc),
    );
  }
}
