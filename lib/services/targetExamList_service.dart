import 'package:NAWI/models/tableData.dart';
import 'package:NAWI/providers/tabledata_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TargetExamListService {
  void showTargetExamList(
    Map<String, Map> data,
    String examName,
    String location,
    int semIndex,
    int semCount,
    BuildContext ctx,
  ) {
    List<String> sems = ['FS', 'HS'];
    int year = new DateTime.now().year; // TODO: fix this for catalogs!
    Map<int, int> examsPerSem = new Map();
    List<int> possibleTargetSemesters = new List();

    for (int i = 1; i <= semCount; i++) {
      if (i > semIndex) {
        examsPerSem[i] = 0;
      }
    }

    data.forEach((key, value) {
      int prop = data[key]["Vorschlag"];
      if (prop > semIndex) {
        examsPerSem[prop]++;
      }
    });

    examsPerSem.forEach((key, value) {
      if (value < 6) {
        possibleTargetSemesters.add(key);
      }
    });

    Map<String, int> targetTexts = new Map();
    possibleTargetSemesters.forEach((element) {
      String targetSem = sems[element % 2];
      int targetYear = year + (element / 2).floor();

      String targetString =
          targetSem + ' ' + targetYear.toString() + ' ' + location;
      targetTexts[targetString] = element;
    });

    int index = -1;

    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: SingleChildScrollView(
            child: Card(
              child: Container(
                child: Column(
                  children: targetTexts.isNotEmpty
                      ? [
                          ...targetTexts.entries.map((targetValues) {
                            index++;
                            return Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: ButtonTheme(
                                    child: FlatButton(
                                      child: Text(
                                        targetValues.key,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () {
                                        moveExam(
                                            examName, targetValues.value, ctx);
                                      },
                                    ),
                                  ),
                                ),
                                if (index < targetTexts.length - 1)
                                  Divider(color: Colors.grey)
                              ],
                            );
                          })
                        ]
                      : [
                          Center(
                            child: Container(
                              height: 60,
                              child: Text(
                                'Keine Verschiebungsmöglichkeit gefunden',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                ),
              ),
            ),
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  moveExam(String examName, int semester, BuildContext ctx) {
    TableData fullData =
        Provider.of<TableDataProvider>(ctx, listen: false).tableData;

    for (var zeile in fullData.exams["0"]) {
      if (zeile.pruefung == examName) {
        zeile.vorschlag = semester;
      }
    }

    Provider.of<TableDataProvider>(ctx, listen: false).manipulatedTableData =
        fullData;

    Navigator.of(ctx).pop();
  }
}
