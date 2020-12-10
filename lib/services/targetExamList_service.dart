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
  /// [isCatalog] `true` if the data is taken from a saved schedule
  /// else `false`.
  /// [ctx] the build context.
  void showTargetExamList(
    String examName,
    int semIndex,
    int semCount,
    bool isCatalog,
    BuildContext ctx,
  ) {
    TableDataProvider tableDataProvider =
        Provider.of<TableDataProvider>(ctx, listen: false);
    List<String> sems = ['FS', 'HS'];
    TableData fullData = tableDataProvider.tableData;
    ExamsProcessed processedExams = tableDataProvider.processedExams;
    Map<String, Map<int, int>> examsPerSemester =
        tableDataProvider.examsPerSemester;
    int minYear = isCatalog ? _findMinYear(fullData) : new DateTime.now().year;
    Map<String, List<int>> possibleTargetSemesters = new Map();

    examsPerSemester.forEach((location, value) {
      value.forEach((semester, value) {
        if (value < 6 &&
            (semester > processedExams.exams[examName].vorschlag ||
                (semester == processedExams.exams[examName].vorschlag &&
                    location != processedExams.exams[examName].ort))) {
          if (possibleTargetSemesters.containsKey(location)) {
            possibleTargetSemesters[location].add(semester);
          } else {
            possibleTargetSemesters.addAll({
              location: [semester]
            });
          }
        }
      });
    });

    Map<String, Map<String, int>> targetTexts = new Map();
    possibleTargetSemesters.forEach((location, sem) {
      sem.forEach((sem) {
        String targetSem = sems[sem % 2];
        int targetYear = minYear + (sem / 2).floor();

        String targetString =
            targetSem + ' ' + targetYear.toString() + ' ' + location;
        targetTexts[targetString] = {location: sem};
      });
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

  /// Get the lowest year from the table data
  /// [allData] the data for all modules of the user.
  /// returns an [int]
  int _findMinYear(TableData allData) {
    int minYear = new DateTime.now().year;

    for (var zeile in allData.modules["0"]) {
      if (zeile.jahr < minYear) {
        minYear = zeile.jahr;
      }
    }

    return minYear;
  }

  /// Move exam to selected semester.
  /// [examName] the name of the exam to be moved.
  /// [semester] the semester where the exam is to be moved to.
  /// [ctx] the building context.
  /// closes the [modalBottomSheet]
  void moveExam(String examName, Map<String, int> examData, BuildContext ctx) {
    ExamsProcessed exams =
        Provider.of<TableDataProvider>(ctx, listen: false).processedExams;

    exams.exams.forEach((pruefung, exam) {
      if (pruefung == examName) {
        exam.movedTo = examData.values.first;
        exam.ort = examData.keys.first;
      }
    });

    Provider.of<TableDataProvider>(ctx, listen: false).processedExams = exams;

    Navigator.of(ctx).pop();
  }
}
