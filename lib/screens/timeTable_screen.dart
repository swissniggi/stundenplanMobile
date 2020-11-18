import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/dropDowns_screen.dart';
import '../providers/tabledata_provider.dart';
import '../models/pointers.dart';
import '../widgets/nawiDrawer.dart';
import '../widgets/tableContainer.dart';
import '../widgets/tableInkwell.dart';

/// Return a [Scaffold] displaying the timetable screen.
class TimeTableScreen extends StatefulWidget {
  /// The route name of the screen.
  static const routeName = '/timeTables';

  @override
  _TimeTableScreenState createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  /// Configure the tables to be displayed.
  /// returns a [GridView].
  GridView configureTables() {
    Map<String, Map> allData = updateTable();
    //Map<String, Map> exams = processFooterData();
    int semCount = getSemCount(allData, false);
    List<String> sems = ['HS', 'FS'];
    List<String> locations = ['Muttenz', 'Windisch'];
    int year = new DateTime.now().year;
    int semIndex = 1;

    if (semCount % 2 != 0) {
      semCount++;
    }

    List<Container> tables = new List<Container>();

    for (var i = 0; i < semCount; i++) {
      for (var j = 0; j < 2; j++) {
        GridView table =
            createTable(allData, locations[j % 2], sems[i % 2], year, semIndex);
        tables.add(Container(child: table));

        semIndex++;
      }

      if (i % 2 == 0) {
        year++;
      }
    }

    GridView allTables = new GridView.count(
        primary: false,
        shrinkWrap: true,
        padding: const EdgeInsets.all(15),
        childAspectRatio: (6 / 7),
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        crossAxisCount: 1,
        children: tables);

    return allTables;
  }

  /// Create a new table.
  /// [data] the data to fill the table with.
  /// [location] the location for which the data is displayed.
  /// [sem] the sem for which the data is displayed.
  /// [year] the year for which the data is displayed.
  /// [semIndex] the index of the semester for which the data is displayed.
  /// returns a [GridView].
  GridView createTable(
    Map<String, Map> data,
    String location,
    String sem,
    int year,
    int semIndex,
  ) {
    List<Color> colors = [
      Color(0xFFBFFFFFF),
      Color(0xFFB2E9AFE),
      Color(0xFFBAC58FA),
      Color(0xFFBAAFFAA),
      Color(0xFFBF7DC6F),
      Color(0xFFBF8C471),
      Color(0xFFBF1C40F)
    ];

    Map<String, dynamic> tableData = new Map();

    data.forEach((key, value) {
      if (data[key]['year'] == year &&
          data[key]['location'] == location &&
          data[key]['sem'] == sem) {
        var day = data[key]['day'];
        var time = data[key]['timeBegin'];
        tableData[day + '.' + time] = value;
      }
    });

    GridView table = new GridView.count(
      primary: false,
      padding: const EdgeInsets.all(5),
      shrinkWrap: false,
      crossAxisCount: 6,
      children: [
        TableContainer(sem.toString() + ' ' + year.toString() + '\n' + location,
            Colors.orange, Colors.grey),
        TableContainer('Mo', Colors.black, Color(0xFFBE6E6FA)),
        TableContainer('Di', Colors.black, Color(0xFFBE6E6FA)),
        TableContainer('Mi', Colors.black, Color(0xFFBE6E6FA)),
        TableContainer('Do', Colors.black, Color(0xFFBE6E6FA)),
        TableContainer('Fr', Colors.black, Color(0xFFBE6E6FA)),
        TableContainer('08:00 - 10:00', Colors.black, Color(0xFFBE6E6FA)),
        ...TableInkwell(
          context,
          tableData,
          colors,
          Pointers.pointers[0],
        ).buildList(),
        TableContainer('10:00 - 12:00', Colors.black, Color(0xFFBE6E6FA)),
        ...TableInkwell(
          context,
          tableData,
          colors,
          Pointers.pointers[1],
        ).buildList(),
        TableContainer('12:00 - 14:00', Colors.black, Color(0xFFBE6E6FA)),
        ...TableInkwell(
          context,
          tableData,
          colors,
          Pointers.pointers[2],
        ).buildList(),
        TableContainer('14:00 - 16:00', Colors.black, Color(0xFFBE6E6FA)),
        ...TableInkwell(
          context,
          tableData,
          colors,
          Pointers.pointers[3],
        ).buildList(),
        TableContainer('16:00 - 18:00', Colors.black, Color(0xFFBE6E6FA)),
        ...TableInkwell(
          context,
          tableData,
          colors,
          Pointers.pointers[4],
        ).buildList(),
        TableContainer('18:00 - 20:00', Colors.black, Color(0xFFBE6E6FA)),
        ...TableInkwell(
          context,
          tableData,
          colors,
          Pointers.pointers[5],
        ).buildList(),
      ],
    );

    return table;
  }

  /// Determine how many semesters must be displayed.
  /// [data] the data for all modules of the chosen topics.
  /// [isCatalog] a boolean to determine whether the data comes from a saved catalog.
  /// returns an [int].
  int getSemCount(Map<String, Map> data, bool isCatalog) {
    var presentYear = new DateTime.now().year;
    int lastYear = 0;
    int maxSem = 0;

    data.forEach((key, value) {
      if (data[key]["year"] > lastYear) {
        lastYear = data[key]["year"];
      }

      if (data[key]["prop"] > maxSem) {
        maxSem = data[key]["prop"];
      }
    });

    if (!isCatalog) {
      maxSem *= 2;
    }

    int semCount = (lastYear - presentYear) * 2;

    semCount++;

    return semCount >= maxSem ? semCount : maxSem;
  }

  /// Process the data of the exams.
  /// returns a [Map].
  Map<String, Map> processFooterData() {
    Map<String, dynamic> fullData =
        Provider.of<TableDataProvider>(context, listen: false).tableData;
    var pruefung = '';
    var vorschlag = 0;
    Map<String, Map> pruefungen = {};
    var veranstaltungen = {};
    for (var zeile in fullData['1']) {
      var exam = {};
      if (pruefung == zeile['Pruefung']) {
        veranstaltungen[zeile] = zeile['Veranstaltung'];
        if (int.parse(zeile['Vorschlag']) > vorschlag) {
          vorschlag = int.parse(zeile['Vorschlag']);
        }
      } else if (pruefung == '') {
        vorschlag = zeile['Vorschlag'];
        pruefung = zeile['Pruefung'];
        veranstaltungen = {};
        veranstaltungen[zeile] = zeile['Veranstaltung'];
      } else {
        exam["Prüfung"] = pruefung;
        exam["Veranstaltungen"] = veranstaltungen;
        exam["Vorschlag"] = vorschlag;
        pruefungen[pruefung] = exam;
        pruefung = zeile['Pruefung'];
        vorschlag = int.parse(zeile['Vorschlag']);
        veranstaltungen = {};
        veranstaltungen[zeile] = zeile['Veranstaltung'];
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

  /// Process the data received from the server
  /// to get it into a useful form.
  /// returns a [Map].
  Map<String, Map> updateTable() {
    Map<String, dynamic> fullData =
        Provider.of<TableDataProvider>(context, listen: false).tableData;

    Map<String, Map> allData = {};
    for (var zeile in fullData['0']) {
      var fach = zeile['Fach'];
      var year = int.parse(zeile['Jahr']);
      var sem = zeile['Semester'];
      var prop = int.parse(zeile['Vorschlag']);
      var name = zeile['Veranstaltung'];
      var day = zeile['Wochentag'];
      var timeBegin = zeile['Beginn'];
      var color = int.parse(zeile['Typ']);
      var location = zeile['Ort'];
      Map<String, dynamic> data = {
        "fach": fach,
        "year": year,
        "name": name,
        "sem": sem,
        "day": day,
        "timeBegin": timeBegin,
        "color": color,
        "typ": int.parse(zeile['Typ']),
        "prop": prop,
        "location": location
      };
      allData[data["name"]] = data;
    }
    return resolveOverlappingModules(allData);
  }

  /// Find overlapping modules and move one to resolve the problem.
  /// [data] the processed module data.
  /// returns a [Map].
  Map<String, Map> resolveOverlappingModules(Map<String, Map> data) {
    bool hasDoubles = false;
    bool noMoreDoubles = false;

    while (!noMoreDoubles) {
      hasDoubles = false;
      for (var key in data.keys) {
        for (var key2 in data.keys) {
          if (data[key] != data[key2] &&
              data[key]["location"] == data[key2]["location"] &&
              data[key]["year"] == data[key2]["year"] &&
              data[key]["sem"] == data[key2]["sem"] &&
              data[key]["day"] == data[key2]["day"] &&
              data[key]["timeBegin"] == data[key2]["timeBegin"]) {
            hasDoubles = true;
            if (data[key2]["name"] != 'privater Termin') {
              data[key2]["year"] += 1;
              data[key2]["prop"] += 1;
            } else {
              data[key]["year"] += 1;
              data[key]["prop"] += 1;
            }
            break;
          }
        }
      }

      if (hasDoubles == false) {
        noMoreDoubles = true;
      }
    }
    return data;
  }

  void _saveTimeTables() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stundenplan FHNW'),
      ),
      drawer: NawiDrawer(DropDownsScreen.routeName, 'Zur Fachauswahl'),
      body: Container(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: false,
          children: [
            configureTables(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: _saveTimeTables,
      ),
    );
  }
}
