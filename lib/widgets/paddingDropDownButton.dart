import 'package:flutter/material.dart';

import 'customText.dart';

/// Return a [Padding] containing a customized [DropdownButton].
class PaddingDropDownButton extends StatelessWidget {
  /// The index of the selected value.
  final int index;

  /// The function to be called when the selection changes.
  final Function onChangedFunc;

  PaddingDropDownButton(this.index, this.onChangedFunc);

  /// A [List] of the default selected values.
  static List<String> selectedValues = [
    ' -- Wählen Sie ein Fach aus -- ',
    ' -- Wählen Sie ein Fach aus -- ',
    ' -- Wählen Sie ein Fach aus -- '
  ];

  /// A [List] of all selectable values.
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
      child: DropdownButton<String>(
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

  /// Determine wheter a [DropDownMenuItem] is selectable or not
  /// [index] the index of the given value
  /// [value] the given value
  /// returns `false` if the [DropDownMenuItem] is selectable otherwise `true`
  bool isDisabled(int index, String value) {
    return selectedValues[index] != value && selectedValues.contains(value);
  }
}
