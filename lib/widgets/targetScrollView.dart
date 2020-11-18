import 'package:flutter/material.dart';

import '../models/cells.dart';
import '../models/pointers.dart';
import 'tableContainer.dart';

/// Return a customized [SingleChildScrollView].
class TargetScrollView extends StatefulWidget {
  /// A [Map] containing the data of all possible targets.
  final Map<String, dynamic> wellTexts;

  TargetScrollView(this.wellTexts);

  @override
  _TargetScrollViewState createState() => _TargetScrollViewState();
}

class _TargetScrollViewState extends State<TargetScrollView> {
  List<Container> _foundTargetCells;
  int _textCount = 0;

  /// Create buttons for all possible targets.
  /// return a [List] of [Containers] (child = [RaisedButton]).
  List<Container> _createTargetButtons() {
    List<Container> displayTexts = new List<Container>();
    List<String> buttonTexts = new List<String>();

    List<String> weekDays = [
      'Montag',
      'Dienstag',
      'Mittwoch',
      'Donnerstag',
      'Freitag'
    ];

    List<dynamic> data = widget.wellTexts["0"];
    List<List<Pointer>> pointer = Pointers.pointers;

    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < pointer[i].length; j++) {
        pointer[i][j].content.forEach((key, value) {
          if (value) {
            List<String> yearAndSemAndLoc = key.split('.');
            String year = yearAndSemAndLoc[0];
            String sem = yearAndSemAndLoc[1];
            String location = yearAndSemAndLoc[2];
            String dayIndex = data[i]['Wochentag'];
            String timeSlot = data[i]['Beginn'];
            String day = weekDays[int.parse(data[i]['Wochentag']) - 1];
            String possibleId = dayIndex +
                '.' +
                timeSlot +
                '.' +
                location +
                '.' +
                sem +
                '.' +
                year;

            if (possibleId != Cells.selectedCell.id) {
              String text = '$location, $sem $year, am $day um $timeSlot:00';
              if (buttonTexts.indexOf(text) == -1) {
                buttonTexts.add(text);
              }
            }
          }
        });
      }
    }

    for (var b = 0; b < buttonTexts.length; b++) {
      displayTexts.add(Container(
        width: double.infinity,
        child: ButtonTheme(
          child: RaisedButton(
            child: Text(
              buttonTexts[b],
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            onPressed: () {
              _moveCell(buttonTexts[b]);
            },
          ),
        ),
      ));
    }

    _textCount = displayTexts.length;
    return displayTexts;
  }

  void _moveCell(String text) {
    TableContainer selected = Cells.selectedCell;
    TableContainer targetCell = _getTargetCell(text);

    /* setState(() {
      String targetId = targetCell.id;
      String selectedId = selected.id;
      String selectedText = selected.childText;
      Color textColor = selected.textStyleColor;
      Color decColor = selected.decorationColor;

      targetCell =
          new TableContainer(selectedText, textColor, decColor, selectedId);
    }); */
  }

  /// Determine the target cell.
  /// [text] contains the text of the selected cell.
  /// return a [TableContainer].
  TableContainer _getTargetCell(String text) {
    String dayPart, slotPart;
    List<String> weekDays = [
      'Montag',
      'Dienstag',
      'Mittwoch',
      'Donnerstag',
      'Freitag'
    ];

    List<String> timeSlots = [
      '08:00',
      '10:00',
      '12:00',
      '14:00',
      '16:00',
      '18:00'
    ];

    for (var i = 0; i < weekDays.length; i++) {
      if (text.contains(weekDays[i])) {
        dayPart = (i + 1).toString();
        break;
      }
    }

    for (var j = 0; j < timeSlots.length; j++) {
      if (text.contains(timeSlots[j])) {
        if (timeSlots[j] == '08:00') {
          slotPart = '8';
        } else {
          slotPart = timeSlots[j].substring(0, 2);
        }
        break;
      }
    }

    String targetId = dayPart + '.' + slotPart;
    TableContainer targetCell;

    for (var c = 0; c < Cells.allCells.length; c++) {
      TableContainer currentCell = Cells.allCells[c];
      List<String> currentCellIdParts = currentCell.id.split('.');

      if (currentCell.id.contains(targetId) &&
          text.contains(currentCellIdParts[1]) &&
          text.contains(currentCellIdParts[2]) &&
          text.contains(currentCellIdParts[3])) {
        targetCell = currentCell;
        break;
      }
    }
    return targetCell;
  }

  @override
  Widget build(BuildContext context) {
    _foundTargetCells = _createTargetButtons();
    return SingleChildScrollView(
      child: Card(
        child: Container(
          child: Column(
            children: _textCount > 0
                ? [
                    ..._foundTargetCells,
                  ]
                : [
                    Center(
                      child: Container(
                        height: 60,
                        child: Text(
                          'Keine freien Slots gefunden',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
