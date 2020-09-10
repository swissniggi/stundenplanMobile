import 'package:flutter/material.dart';

import 'customText.dart';

class PaddingDropDownButton extends StatelessWidget {
  final int index;
  final Function onChangedFunc;

  PaddingDropDownButton(this.index, this.onChangedFunc);

  static List<String> selectedValues = [
    ' -- Wählen Sie ein Fach aus -- ',
    ' -- Wählen Sie ein Fach aus -- ',
    ' -- Wählen Sie ein Fach aus -- '
  ];

  static List<String> dropDownValues = [
    ' -- Wählen Sie ein Fach aus -- ',
    'Bildnerisches Gestalten',
    'Deutsch',
    'Französisch',
    'Englisch',
    'Ethik, Religion, Gemeinschaft',
    'Italienisch',
    'Mathematik',
    'Musik',
    'Natur und Technik',
    'Räume, Zeiten, Gesellschaften',
    'Textiles und technisches Gestalten',
    'Wirtschaft, Arbeit, Haushalt'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: new DropdownButton<String>(
        value: selectedValues[index],
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 28,
        elevation: 16,
        isExpanded: true,
        style: TextStyle(fontSize: 22),
        items: dropDownValues.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: CustomText(value, isDisabled: isDisabled(index, value)),
          );
        }).toList(),
        onChanged: onChangedFunc,
      ),
    );
  }

  bool isDisabled(int index, String value) {
    return selectedValues[index] != value && selectedValues.contains(value);
  }
}
