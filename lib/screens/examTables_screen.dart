import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'moduleTables_screen.dart';
import 'dropDowns_screen.dart';
import '../providers/tabledata_provider.dart';
import '../services/targetExamList_service.dart';
import '../models/tableData.dart';
import '../widgets/nawiDrawer.dart';
import '../widgets/circularTableMenu.dart';
import '../widgets/tableContainer.dart';

class ExamTablesScreen extends StatefulWidget {
  /// The route name of the screen.
  static const routeName = '/examTables';

  @override
  _ExamTablesScreenState createState() => _ExamTablesScreenState();
}

class _ExamTablesScreenState extends State<ExamTablesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /// Configure the tables to be displayed.
  /// returns a [ListView].
  ListView _configureTables() {
    TableDataProvider tableDataProvider =
        Provider.of<TableDataProvider>(context, listen: false);
    TableData fullData = tableDataProvider.tableData;
    bool isCatalog = tableDataProvider.isCatalog;
    ExamsProcessed exams =
        Provider.of<TableDataProvider>(context).processedExams;

    int semCount = _getSemCount(fullData, false);
    List<String> sems = ['HS', 'FS'];
    List<String> locations = ['Muttenz', 'Windisch'];
    int year = isCatalog ? _findMinYear(fullData) : new DateTime.now().year;
    int semIndex = 1;

    if (semCount % 2 != 0) {
      semCount++;
    }

    List<Container> tables = new List<Container>();

    for (var i = 0; i < semCount; i++) {
      for (var j = 0; j < 2; j++) {
        Container table = _createTable(exams, locations[j % 2], sems[i % 2],
            year, semIndex, semCount, isCatalog);
        tables.add(table);
      }

      if (i % 2 == 0) {
        year++;
      }
      semIndex++;
    }

    ListView allTables = ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: tables,
    );

    return allTables;
  }

  /// Create a new table.
  /// [examData] the data to fill the table with.
  /// [location] the location for which the data is displayed.
  /// [sem] the sem for which the data is displayed.
  /// [year] the year for which the data is displayed.
  /// [semIndex] the index of the semester for which the data is displayed.
  /// returns a [GridView].
  Container _createTable(ExamsProcessed examData, String location, String sem,
      int year, int semIndex, int semCount, bool isCatalog) {
    Map<String, dynamic> tableData = new Map();
    int freeExamSpaces = 6;
    Map<String, Map<int, int>> examsInSemester =
        Provider.of<TableDataProvider>(context, listen: false).examsPerSemester;

    examData.exams.forEach((key, value) {
      int prop = examData.exams[key].movedTo > 0
          ? examData.exams[key].movedTo
          : examData.exams[key].vorschlag;

      if (location == examData.exams[key].ort && prop == semIndex) {
        if (freeExamSpaces > 0) {
          var exam = examData.exams[key].pruefung;
          tableData[exam] = value;
          freeExamSpaces--;
        } else if (freeExamSpaces == 0) {
          examData.exams[key].vorschlag += 2;
        }
      }
    });

    Map<int, int> examsInThisSemester = {semIndex: 6 - freeExamSpaces};

    if (examsInSemester.containsKey(location)) {
      examsInSemester[location].addAll(examsInThisSemester);
    } else {
      examsInSemester.addAll({location: examsInThisSemester});
    }

    Provider.of<TableDataProvider>(context, listen: false).setExamsPerSemester =
        examsInSemester;

    GridView table = new GridView.count(
      primary: false,
      padding: const EdgeInsets.all(5),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 3 / 1,
      children: [
        for (var entry in tableData.entries)
          Container(
            child: InkWell(
              onLongPress: () {
                TargetExamListService examService = new TargetExamListService();
                examService.showTargetExamList(
                  entry.key,
                  semIndex,
                  semCount,
                  isCatalog,
                  context,
                );
              },
              child: TableContainer(
                entry.key,
                Colors.black,
                Colors.blue[100],
              ),
            ),
          ),
      ],
    );

    Container tableContainer = new Container(
      padding: EdgeInsets.only(top: 6),
      child: Column(
        children: [
          Text(
            sem + ' ' + year.toString() + ' ' + location,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          table
        ],
      ),
    );

    return tableContainer;
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

  /// Determine how many semesters must be displayed.
  /// [data] the data for all modules of the chosen topics.
  /// [isCatalog] a boolean to determine whether the data comes from a saved catalog.
  /// returns an [int].
  int _getSemCount(TableData data, bool isCatalog) {
    var presentYear = new DateTime.now().year;
    int lastYear = 0;
    int maxSem = 0;

    for (var zeile in data.modules["0"]) {
      if (zeile.jahr > lastYear) {
        lastYear = zeile.jahr;
      }

      if (zeile.vorschlag > maxSem) {
        maxSem = zeile.vorschlag;
      }
    }

    int semCount = (lastYear - presentYear) * 2;

    semCount++;

    return semCount >= maxSem ? semCount : maxSem;
  }

  @override
  Widget build(BuildContext context) {
    List<CircularMenuItem> menuItems = [
      CircularMenuItem(
        icon: Icons.arrow_back,
        color: Colors.cyan,
        iconColor: Colors.white,
        onTap: () {
          Navigator.of(context).pushNamed(ModuleTablesScreen.routeName);
        },
      ),
      CircularMenuItem(
        icon: Icons.poll,
        color: Colors.blue,
        iconColor: Colors.white,
        onTap: () {},
      ),
      CircularMenuItem(
        icon: Icons.save,
        color: Colors.green,
        iconColor: Colors.white,
        onTap: () {
          Provider.of<TableDataProvider>(context, listen: false)
              .saveTableData(_scaffoldKey, context);
        },
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Prüfungsplan FHNW'),
      ),
      drawer: NawiDrawer(DropDownsScreen.routeName, 'Zur Fachauswahl'),
      body: CircularTableMenu(
        menuItems,
        Container(
          child: _configureTables(),
        ),
      ),
    );
  }
}
