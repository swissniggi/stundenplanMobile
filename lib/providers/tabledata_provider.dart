import 'package:flutter/material.dart';

import '../models/tableData.dart';

/// A provider for the table data.
class TableDataProvider with ChangeNotifier {
  /// A [Map] containing the table data.
  TableData _tableData = new TableData();

  Map<String, int> _formerDuplicates = new Map();

  /// the preferred location selected by the user
  String _selectedLocation;

  /// A boolean to determine whether the data comes from a saved catalog.
  bool _isCatalog = false;

  /// Setter for [_tableData] when downloaded from server.
  set newTableData(Map<String, dynamic> data) {
    this._tableData = _processDataFromServer(data);
    notifyListeners();
  }

  /// Setter for [_tableData] when manipulated.
  set manipulatedTableData(TableData data) {
    this._tableData = data;
    notifyListeners();
  }

  /// Getter for [_tableData].
  TableData get tableData {
    final TableData currentTableData = this._tableData;
    return currentTableData;
  }

  /// Daten eines vormalig überlappenden Moduls speichern oder aktualisieren.
  void setFormerDuplicates(String moduleName, int newProp) {
    this
        ._formerDuplicates
        .update(moduleName, (value) => newProp, ifAbsent: () => newProp);
  }

  /// Getter for [_formerDuplicates].
  Map<String, int> get formerDuplicates {
    Map<String, int> duplicates = this._formerDuplicates;
    return duplicates;
  }

  /// Setter for [_selectedLocation]
  set selectedLocation(String location) {
    this._selectedLocation = location;
  }

  /// Getter fpr [_selectedLocation]
  String get selectedLocation {
    String location = this._selectedLocation;
    return location;
  }

  /// Setter for [_isCatalog].
  set isCatalog(bool isCatalog) {
    this._isCatalog = isCatalog;
    notifyListeners();
  }

  /// Getter for [_isCatalog].
  bool get isCatalog {
    return this._isCatalog;
  }

  /// Process the data delivered from the server.
  /// [serverData] the data from the server
  /// returns a [TableData]-Object
  TableData _processDataFromServer(Map<String, dynamic> serverData) {
    TableData processedData = new TableData();
    processedData.modules = new Map<String, List<ModuleData>>();
    processedData.exams = new Map<String, List<ExamData>>();
    processedData.modules.putIfAbsent("0", () => new List());
    processedData.exams.putIfAbsent("0", () => new List());

    for (var modulZeile in serverData["0"]) {
      int prop = 0;

      // calculate the correct proposed semester number
      if (modulZeile["Semester"] == 'FS') {
        prop = int.parse(modulZeile["Vorschlag"]) * 2;
      } else {
        prop = (int.parse(modulZeile["Vorschlag"]) * 2) - 1;
      }

      ModuleData moduleData = new ModuleData();
      moduleData.fach = modulZeile["Fach"];
      moduleData.veranstaltung = modulZeile["Veranstaltung"];
      moduleData.jahr = int.parse(modulZeile["Jahr"]);
      moduleData.semester = modulZeile["Semester"];
      moduleData.wochentag = int.parse(modulZeile["Wochentag"]);
      moduleData.beginn = int.parse(modulZeile["Beginn"]);
      moduleData.ende = int.parse(modulZeile["Ende"]);
      moduleData.vorschlag =
          this._isCatalog ? int.parse(modulZeile["Vorschlag"]) : prop;
      moduleData.typ = int.parse(modulZeile["Typ"]);
      moduleData.beschreibung = modulZeile["Beschreibung"];
      moduleData.ort = modulZeile["Ort"];
      moduleData.confirmed = int.parse(modulZeile["Confirmed"]) == 1;

      processedData.modules["0"].add(moduleData);
    }

    for (var examZeile in serverData["1"]) {
      ExamData examData = new ExamData();
      examData.pruefung = examZeile["Prüfung"];
      examData.veranstaltung = examZeile["Veranstaltung"];
      examData.vorschlag = int.parse(examZeile["Vorschlag"]);
      examData.kuerzel = examZeile["Kürzel"];
      examData.kreditpunkte = int.parse(examZeile["Kreditpunkte"]);

      processedData.exams["0"].add(examData);
    }

    return processedData;
  }

  /// Reset all properties of this class.
  void reset() {
    _tableData = new TableData();
    _isCatalog = false;
  }
}
