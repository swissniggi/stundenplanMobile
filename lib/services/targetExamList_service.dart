import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tabledata_provider.dart';
import '../models/tableData.dart';

class TargetExamListService {
  /// Get all possible targets and
  /// call [showModalBottomSheet()] to display them.
  /// [data] contains the processed exam data.
  /// [examName] the name of the selected exam.
  /// [location] the location where the exam takes place.
  /// [semIndex] the index of the semester where the exam takes place.
  /// [semCount] the number of available semesters.
  /// [ctx] the build context.
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
        return SingleChildScrollView(
          child: Card(
            child: Container(
              child: Column(
                children: targetTexts.isNotEmpty
                    ? [
                        ...targetTexts.entries.map(
                          (targetValues) {
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
                                          examName,
                                          targetValues.value,
                                          ctx,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                if (index < targetTexts.length - 1)
                                  Divider(color: Colors.grey)
                              ],
                            );
                          },
                        )
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
        );
      },
    );
  }

  /// Move exam to selected semester.
  /// [examName] the name of the exam to be moved.
  /// [semester] the semester where the exam is to be moved to.
  /// [ctx] the building context.
  /// closes the [modalBottomSheet]
  void moveExam(String examName, int semester, BuildContext ctx) {
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
