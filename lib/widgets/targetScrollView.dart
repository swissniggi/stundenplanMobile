import 'package:NAWI/cellIdController.dart';
import 'package:flutter/material.dart';

class TargetScrollView extends StatefulWidget {
  final Map<String, dynamic> wellTexts;

  TargetScrollView(this.wellTexts);

  @override
  _TargetScrollViewState createState() => _TargetScrollViewState();
}

class _TargetScrollViewState extends State<TargetScrollView> {
  _setTexts() {
    List<RaisedButton> displayTexts = new List<RaisedButton>();
    List<String> buttonTexts = new List<String>();

    List<String> weekDays = [
      'Montag',
      'Dienstag',
      'Mittwoch',
      'Donnerstag',
      'Freitag'
    ];

    List<dynamic> data = widget.wellTexts["0"];
    List<List<Pointer>> pointer = CellIdController.pointers;

    for (var i = 0; i < data.length; i++) {
      for (var j = 0; j < pointer[i].length; j++) {
        pointer[i][j].content.forEach((key, value) {
          List<String> yearAndSemAndLoc = key.split('.');
          String year = yearAndSemAndLoc[0];
          String sem = yearAndSemAndLoc[1];
          String location = yearAndSemAndLoc[2];
          bool hasContent = value;

          if (hasContent == false &&
              sem == data[i]['Semester'] &&
              location == data[i]['Ort']) {
            String day = weekDays[int.parse(data[i]['Wochentag']) - 1];
            String text =
                '${data[i]['Ort']}, ${data[i]['Semester']} $year, am $day um ${data[i]['Beginn']}:00';
            if (buttonTexts.indexOf(text) == -1) {
              buttonTexts.add(text);
            }
          }
        });
      }
    }

    for (var b = 0; b < buttonTexts.length; b++) {
      displayTexts.add(RaisedButton(
        child: Text(buttonTexts[b]),
        onPressed: () {},
      ));
    }

    return displayTexts;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [..._setTexts()],
          ),
        ),
      ),
    );
  }
}
