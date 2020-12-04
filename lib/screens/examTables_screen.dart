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
    TableData fullData = Provider.of<TableDataProvider>(context).tableData;
    Map<String, Map> exams = _processFooterData(fullData);

    int semCount = _getSemCount(fullData, false);
    List<String> sems = ['HS', 'FS'];
    List<String> locations = ['Muttenz', 'Windisch'];
    int year = new DateTime.now().year; // FIXME: fix that for catalogs
    int semIndex = 1;

    if (semCount % 2 != 0) {
      semCount++;
    }

    List<Container> tables = new List<Container>();

    for (var i = 0; i < semCount; i++) {
      for (var j = 0; j < 2; j++) {
        Container table = _createTable(
            exams, locations[j % 2], sems[i % 2], year, semIndex, semCount);
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
  /// [data] the data to fill the table with.
  /// [location] the location for which the data is displayed.
  /// [sem] the sem for which the data is displayed.
  /// [year] the year for which the data is displayed.
  /// [semIndex] the index of the semester for which the data is displayed.
  /// returns a [GridView].
  Container _createTable(Map<String, Map> data, String location, String sem,
      int year, int semIndex, int semCount) {
    String selectedLocation =
        Provider.of<TableDataProvider>(context, listen: false).selectedLocation;
    Map<String, dynamic> tableData = new Map();
    int freeExamSpaces = 6;

    data.forEach((key, value) {
      if (location == selectedLocation) {
        if (data[key]["Vorschlag"] == semIndex) {
          if (freeExamSpaces > 0) {
            var exam = data[key]['Prüfung'];
            tableData[exam] = value;
            freeExamSpaces--;
          } else if (freeExamSpaces == 0) {
            data[key]["Vorschlag"] += 2;
          }
        }
      }
    });

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
                  data,
                  entry.key,
                  location,
                  semIndex,
                  semCount,
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

  /// Process the data of the exams.
  /// [fullData] contains all data for exams and modules.
  /// returns a [Map].
  Map<String, Map> _processFooterData(TableData fullData) {
    var pruefung = '';
    var vorschlag = 0;
    Map<String, Map> pruefungen = {};
    var veranstaltungen = {};
    for (var zeile in fullData.exams["0"]) {
      Map<String, int> duplicates =
          Provider.of<TableDataProvider>(context, listen: false)
              .formerDuplicates;

      // set Vorschlag to changed value if available
      if (duplicates.containsKey(zeile.veranstaltung)) {
        vorschlag = duplicates[zeile.veranstaltung];
      }

      var exam = {};
      if (pruefung == zeile.pruefung) {
        veranstaltungen[zeile.veranstaltung] = zeile;
        if (zeile.vorschlag > vorschlag) {
          vorschlag = zeile.vorschlag;
        }
      } else if (pruefung == '') {
        vorschlag = zeile.vorschlag;
        pruefung = zeile.pruefung;
        veranstaltungen = {};
        veranstaltungen[zeile.veranstaltung] = zeile;
      } else {
        exam["Prüfung"] = pruefung;
        exam["Veranstaltungen"] = veranstaltungen;
        exam["Vorschlag"] = vorschlag;
        pruefungen[pruefung] = exam;
        pruefung = zeile.pruefung;
        vorschlag = zeile.vorschlag;
        veranstaltungen = {};
        veranstaltungen[zeile.veranstaltung] = zeile;
      }
    }
    // Letzte Prüfung ebenfalls übergeben
    if (pruefung != '') {
      var lastExam = {};
      lastExam["Prüfung"] = pruefung;
      lastExam["Veranstaltungen"] = veranstaltungen;
      lastExam["Vorschlag"] = vorschlag;
      pruefungen[pruefung] = lastExam;
    }

    return pruefungen;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TableDataProvider>(context, listen: false)
        .examScreenWasVisited = true;

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
