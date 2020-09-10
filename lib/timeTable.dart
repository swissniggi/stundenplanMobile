import 'package:flutter/material.dart';

import 'widgets/tableContainer.dart';
import 'tableInkwell.dart';

class TimeTable extends StatefulWidget {
  TimeTable({Key key, this.title, this.data, this.isCatalog}) : super(key: key);

  final String title;
  final Map<String, dynamic> data;
  final bool isCatalog;

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  GridView configureTables() {
    Map<String, Map> allData = updateTable();
    //Map<String, Map> exams = processFooterData();
    int semCount = getSemCount(allData, false);
    List sems = ['HS', 'FS'];
    List locations = ['Muttenz', 'Windisch'];
    var year = new DateTime.now().year;
    var semIndex = 1;

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

  GridView createTable(data, location, sem, year, semIndex) {
    List<Color> colors = [
      Color(0xFFBFFFFFF),
      Color(0xFFB2E9AFE),
      Color(0xFFBAC58FA),
      Color(0xFFBAAFFAA),
      Color(0xFFBF7DC6F),
      Color(0xFFBF8C471),
      Color(0xFFBF1C40F)
    ];

    Map tableData = new Map();

    data.forEach((key, value) {
      if (data[key]['year'] == year &&
          data[key]['location'] == location &&
          data[key]['sem'] == sem) {
        var day = data[key]['day'];
        var time = data[key]['timeBegin'];
        tableData[day + '.' + time] = value;
      }
    });

    TableInkwell well = new TableInkwell();

    GridView table = new GridView.count(
      primary: false,
      padding: const EdgeInsets.all(5),
      shrinkWrap: false,
      crossAxisCount: 6,
      children: <Widget>[
        TableContainer(sem.toString() + ' ' + year.toString() + '\n' + location,
            Colors.orange, Colors.grey),
        TableContainer('Mo', Colors.black, Color(0xFFBE6E6FA)),
        TableContainer('Di', Colors.black, Color(0xFFBE6E6FA)),
        TableContainer('Mi', Colors.black, Color(0xFFBE6E6FA)),
        TableContainer('Do', Colors.black, Color(0xFFBE6E6FA)),
        TableContainer('Fr', Colors.black, Color(0xFFBE6E6FA)),
        TableContainer('08:00 - 10:00', Colors.black, Color(0xFFBE6E6FA)),
        ...well.setTableInkwells(
            sem, year, tableData, colors, ['1.8', '2.8', '3.8', '4.8', '5.8']),
        TableContainer('10:00 - 12:00', Colors.black, Color(0xFFBE6E6FA)),
        ...well.setTableInkwells(sem, year, tableData, colors,
            ['1.10', '2.10', '3.10', '4.10', '5.10']),
        TableContainer('12:00 - 14:00', Colors.black, Color(0xFFBE6E6FA)),
        ...well.setTableInkwells(sem, year, tableData, colors,
            ['1.12', '2.12', '3.12', '4.12', '5.12']),
        TableContainer('14:00 - 16:00', Colors.black, Color(0xFFBE6E6FA)),
        ...well.setTableInkwells(sem, year, tableData, colors,
            ['1.14', '2.14', '3.14', '4.14', '5.14']),
        TableContainer('16:00 - 18:00', Colors.black, Color(0xFFBE6E6FA)),
        ...well.setTableInkwells(sem, year, tableData, colors,
            ['1.16', '2.16', '3.16', '4.16', '5.16']),
        TableContainer('18:00 - 20:00', Colors.black, Color(0xFFBE6E6FA)),
        ...well.setTableInkwells(sem, year, tableData, colors,
            ['1.18', '2.18', '3.18', '4.18', '5.18']),
      ],
    );

    return table;
  }

  int getSemCount(data, isCatalog) {
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

  Map<String, Map> processFooterData() {
    var pruefung = '';
    var vorschlag = 0;
    Map<String, Map> pruefungen = {};
    var veranstaltungen = {};
    for (var zeile in widget.data['1']) {
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

  Map<String, Map> updateTable() {
    Map<String, Map> allData = {};
    for (var zeile in widget.data['0']) {
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

  Map<String, Map> resolveOverlappingModules(data) {
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
        title: Text(widget.title),
      ),
      body: Container(
        child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: false,
            children: <Widget>[
              configureTables(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: new RaisedButton(
                  color: Colors.blue,
                  onPressed: _saveTimeTables,
                  child: Text('Stundenpläne speichern',
                      style: TextStyle(color: Colors.white, fontSize: 22)),
                ),
              ),
            ]),
      ),
    );
  }
}
