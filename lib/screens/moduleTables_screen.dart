import 'package:NAWI/widgets/showDialog.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'examTables_screen.dart';
import 'dropDowns_screen.dart';
import '../providers/tabledata_provider.dart';
import '../models/pointers.dart';
import '../models/tableData.dart';
import '../widgets/nawiDrawer.dart';
import '../widgets/tableContainer.dart';
import '../widgets/moduleTableInkwell.dart';
import '../widgets/circularTableMenu.dart';

/// Return a [Scaffold] displaying the timetable screen.
class ModuleTablesScreen extends StatefulWidget {
  /// The route name of the screen.
  static const routeName = '/moduleTables';

  @override
  _ModuleTablesScreenState createState() => _ModuleTablesScreenState();
}

class _ModuleTablesScreenState extends State<ModuleTablesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<String, Map> _processedData;
  bool _anyDoublesAtAll = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_anyDoublesAtAll) {
        _updateRootData(_processedData);
      }
    });
    super.initState();
  }

  /// Configure the tables to be displayed.
  /// returns a [GridView].
  GridView _configureTables() {
    Map<String, Map> allData = _updateTable();

    int semCount = _getSemCount(allData, false);
    List<String> sems = ['HS', 'FS'];
    List<int> semIndices = [1, 1];
    List<String> locations = ['Muttenz', 'Windisch'];
    int year = new DateTime.now().year;

    if (semCount % 2 != 0) {
      semCount++;
    }

    List<Container> tables = new List<Container>();

    for (var i = 0; i < semCount; i++) {
      for (var j = 0; j < 2; j++) {
        GridView table = _createTable(
            allData, locations[i % 2], sems[j % 2], year, semIndices[i % 2]);
        tables.add(Container(child: table));

        semIndices[i % 2]++;
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
  GridView _createTable(
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
      if (data[key]['location'] == location &&
          data[key]['sem'] == sem &&
          semIndex == data[key]['prop']) {
        var day = data[key]['day'];
        var time = data[key]['timeBegin'];
        tableData[day.toString() + '.' + time.toString()] = value;
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
        ...ModuleTableInkwell(
          context,
          tableData,
          colors,
          location,
          sem,
          year.toString(),
          Pointers.pointers[0],
        ).buildList(),
        TableContainer('10:00 - 12:00', Colors.black, Color(0xFFBE6E6FA)),
        ...ModuleTableInkwell(
          context,
          tableData,
          colors,
          location,
          sem,
          year.toString(),
          Pointers.pointers[1],
        ).buildList(),
        TableContainer('12:00 - 14:00', Colors.black, Color(0xFFBE6E6FA)),
        ...ModuleTableInkwell(
          context,
          tableData,
          colors,
          location,
          sem,
          year.toString(),
          Pointers.pointers[2],
        ).buildList(),
        TableContainer('14:00 - 16:00', Colors.black, Color(0xFFBE6E6FA)),
        ...ModuleTableInkwell(
          context,
          tableData,
          colors,
          location,
          sem,
          year.toString(),
          Pointers.pointers[3],
        ).buildList(),
        TableContainer('16:00 - 18:00', Colors.black, Color(0xFFBE6E6FA)),
        ...ModuleTableInkwell(
          context,
          tableData,
          colors,
          location,
          sem,
          year.toString(),
          Pointers.pointers[4],
        ).buildList(),
        TableContainer('18:00 - 20:00', Colors.black, Color(0xFFBE6E6FA)),
        ...ModuleTableInkwell(
          context,
          tableData,
          colors,
          location,
          sem,
          year.toString(),
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
  int _getSemCount(Map<String, Map> data, bool isCatalog) {
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

    int semCount = (lastYear - presentYear) * 2;

    semCount++;

    return semCount >= maxSem ? semCount : maxSem;
  }

  /// Process the data received from the server
  /// to get it into a useful form.
  /// returns a [Map].
  Map<String, Map> _updateTable() {
    TableData fullData = Provider.of<TableDataProvider>(context).tableData;

    Map<String, Map> allData = {};
    for (var zeile in fullData.modules["0"]) {
      var fach = zeile.fach;
      var year = zeile.jahr;
      var sem = zeile.semester;
      var prop = zeile.vorschlag;
      var name = zeile.veranstaltung;
      var day = zeile.wochentag;
      var timeBegin = zeile.beginn;
      var color = zeile.typ;
      var location = zeile.ort;
      Map<String, dynamic> data = {
        "fach": fach,
        "year": year,
        "name": name,
        "sem": sem,
        "day": day,
        "timeBegin": timeBegin,
        "color": color,
        "typ": color,
        "prop": prop,
        "location": location
      };
      allData[data["name"]] = data;
    }
    return _resolveOverlappingModules(allData);
  }

  /// Find overlapping modules and move one to resolve the problem.
  /// [data] the processed module data.
  /// returns a [Map].
  Map<String, Map> _resolveOverlappingModules(Map<String, Map> data) {
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
            _anyDoublesAtAll = true;
            hasDoubles = true;
            if (data[key2]["name"] != 'privater Termin') {
              data[key2]["year"] += 1;
              data[key2]["prop"] += 2;
              Provider.of<TableDataProvider>(context, listen: false)
                  .setFormerDuplicates(data[key2]["name"], data[key2]["prop"]);
            } else {
              data[key]["year"] += 1;
              data[key]["prop"] += 2;
              Provider.of<TableDataProvider>(context, listen: false)
                  .setFormerDuplicates(data[key]["name"], data[key]["prop"]);
            }
            break;
          }
        }
      }

      if (!hasDoubles) {
        noMoreDoubles = true;
      }
    }

    _processedData = data;

    return data;
  }

  /// Update the root data of the provider.
  /// This is done so the exam tables can be created with the most recent data.
  /// This function is called AFTER build only if there where any doubles
  /// [processedData] the most recent data.
  void _updateRootData(Map<String, Map> processedData) {
    TableData fullData =
        Provider.of<TableDataProvider>(context, listen: false).tableData;

    for (var zeile in fullData.modules["0"]) {
      for (var key in processedData.keys) {
        if (zeile.veranstaltung == processedData[key]["name"]) {
          zeile.jahr = processedData[key]["year"];
          zeile.vorschlag = processedData[key]["prop"];
        }
      }
    }

    Provider.of<TableDataProvider>(context, listen: false)
        .manipulatedTableData = fullData;
  }

  @override
  Widget build(BuildContext context) {
    List<CircularMenuItem> menuItems = [
      CircularMenuItem(
        icon: Icons.save,
        color: Colors.green,
        iconColor: Colors.white,
        onTap: () {
          if (Provider.of<TableDataProvider>(context, listen: false)
              .examScreenWasVisited) {
            Provider.of<TableDataProvider>(context, listen: false)
                .saveTableData(_scaffoldKey, context);
          } else {
            ShowDialog dialog = new ShowDialog();
            dialog.showCustomDialog(
              'Speichern noch nicht möglich!',
              () => Navigator.of(context).pop(),
              context,
              [
                Text(
                    'Bitte schau den Prüfungsplan einmal an, bevor du speicherst.'),
              ],
            );
          }
        },
      ),
      CircularMenuItem(
        icon: Icons.arrow_forward,
        color: Colors.cyan,
        iconColor: Colors.white,
        onTap: () {
          Navigator.of(context).pushNamed(ExamTablesScreen.routeName);
        },
      ),
      CircularMenuItem(
        icon: Icons.poll,
        color: Colors.blue,
        iconColor: Colors.white,
        onTap: () {},
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Stundenplan FHNW'),
      ),
      drawer: NawiDrawer(DropDownsScreen.routeName, 'Zur Fachauswahl'),
      body: CircularTableMenu(
        menuItems,
        Container(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: false,
            children: [
              _configureTables(),
            ],
          ),
        ),
      ),
    );
  }
}
