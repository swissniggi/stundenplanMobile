import 'package:NAWI/models/tableData.dart';
import 'package:NAWI/providers/tabledata_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cells.dart';
import '../models/pointers.dart';
import 'tableContainer.dart';

/// Return a customized [SingleChildScrollView].
class TargetScrollView extends StatefulWidget {
  /// A [Map] containing the data of all possible targets.
  final Map<String, dynamic> possibleTargets;

  TargetScrollView(this.possibleTargets);

  @override
  _TargetScrollViewState createState() => _TargetScrollViewState();
}

class _TargetScrollViewState extends State<TargetScrollView> {
  List<Widget> _foundTargetCells;
  int _textCount = 0;

  /// Create buttons for all possible targets.
  /// return a [List] of [Widgets] containing [Container]s (child = [RaisedButton]) and [Divider]s.
  List<Widget> _createTargetButtons() {
    List<Widget> displayTexts = new List<Widget>();
    List<String> buttonTexts = new List<String>();

    List<String> weekDays = [
      'Montag',
      'Dienstag',
      'Mittwoch',
      'Donnerstag',
      'Freitag'
    ];

    List<dynamic> possibleModulesData = widget.possibleTargets["0"];
    List<List<Pointer>> pointer = Pointers.pointers;
    List<Map<String, int>> targetModuleNames = new List();

    for (var i = 0; i < possibleModulesData.length; i++) {
      for (var j = 0; j < pointer[i].length; j++) {
        pointer[i][j].content.forEach((key, value) {
          if (!value) {
            List<String> yearAndSemAndLoc = key.split('.');
            String year = yearAndSemAndLoc[0];
            String sem = yearAndSemAndLoc[1];
            String location = yearAndSemAndLoc[2];
            String dayIndex = possibleModulesData[i]['Wochentag'];
            String timeSlot = possibleModulesData[i]['Beginn'];
            String day =
                weekDays[int.parse(possibleModulesData[i]['Wochentag']) - 1];
            String possibleId = dayIndex +
                '.' +
                timeSlot +
                '.' +
                location +
                '.' +
                sem +
                '.' +
                year;

            Cells.allCells.forEach((cell) {
              List<String> cellIdParts = cell.id.split('.');
              String cutId = cellIdParts[0] +
                  '.' +
                  cellIdParts[1] +
                  '.' +
                  cellIdParts[2] +
                  '.' +
                  cellIdParts[3] +
                  '.' +
                  cellIdParts[4];

              if (cutId == possibleId && cell.childText == '') {
                String text = '$location, $sem $year, am $day um $timeSlot:00';
                if (buttonTexts.indexOf(text) == -1) {
                  buttonTexts.add(text);

                  targetModuleNames.add({
                    possibleModulesData[i]['Modul']: int.parse(cellIdParts[5])
                  });
                }
              }
            });
          }
        });
      }
    }

    for (var b = 0; b < buttonTexts.length; b++) {
      displayTexts.add(Container(
        width: double.infinity,
        child: ButtonTheme(
          child: FlatButton(
            child: Text(
              buttonTexts[b],
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            onPressed: () {
              _moveCell(buttonTexts[b], targetModuleNames[b]);
            },
          ),
        ),
      ));

      if (b < buttonTexts.length - 1) {
        displayTexts.add(Divider(color: Colors.grey));
      }
    }

    _textCount = displayTexts.length;
    return displayTexts;
  }

  /// Move cell to wanted position in the table.
  /// [buttonText] the text displayed on the pressed button
  /// [moduleNameAndProp] the name of the targeted module
  void _moveCell(String buttonText, Map<String, int> moduleNameAndProp) {
    TableDataProvider tableDataProvider =
        Provider.of<TableDataProvider>(context, listen: false);
    TableContainer selected = Cells.selectedCell; // here it comes from
    TableContainer targetCell = _getTargetCell(buttonText); // here it goes to

    String targetId = targetCell.id;
    List<String> targetIdParts = targetId.split(".");

    TableData data = tableDataProvider.tableData;

    for (var modulZeile in data.modules["0"]) {
      if (modulZeile.veranstaltung == selected.childText) {
        int newProp = moduleNameAndProp.values.first;

        modulZeile.veranstaltung = moduleNameAndProp.keys.first;
        modulZeile.wochentag = int.parse(targetIdParts[0]);
        modulZeile.beginn = int.parse(targetIdParts[1]);
        modulZeile.ende = int.parse(targetIdParts[1]) + 2;
        modulZeile.ort = targetIdParts[2];
        modulZeile.semester = targetIdParts[3];
        modulZeile.jahr = int.parse(targetIdParts[4]);
        modulZeile.vorschlag = newProp;

        ExamsProcessed exams = tableDataProvider.processedExams;
        exams.exams.forEach((name, exam) {
          if (exam.veranstaltungen.contains(moduleNameAndProp)) {
            if (exam.vorschlag < newProp) {
              exam.vorschlag = newProp;

              if (exam.movedTo > 0 && exam.movedTo < newProp) {
                exam.movedTo = newProp;
              }
            }
          }
        });
        tableDataProvider.processedExams = exams;
      }
    }

    tableDataProvider.manipulatedTableData = data;

    Navigator.of(context).pop();
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
          text.contains(currentCellIdParts[3]) &&
          text.contains(currentCellIdParts[4])) {
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
