import 'dart:convert';

import 'package:flutter/material.dart';

import '../services/xmlRequest_service.dart';
import '../models/tableData.dart';
import '../widgets/customFormField.dart';
import '../widgets/paddingButton.dart';
import '../widgets/snackbarText.dart';

/// A provider for the table data.
class TableDataProvider with ChangeNotifier {
  /// A [Map] containing the table data.
  TableData _tableData = new TableData();

  /// A [Map] containing the new proposed semesters of former duplicates.
  Map<String, int> _formerDuplicates = new Map();

  /// A [Map] containing the number of exams per semester by location.
  Map<String, Map<int, int>> _examsPerSemester = new Map();

  /// The processed exam of the current schedule.
  ExamsProcessed _processedExams = new ExamsProcessed();

  /// the preferred location selected by the user.
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

  /// Updater for [_formerDuplicates].
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

  /// Setter for [_examsPerSemester].
  set setExamsPerSemester(Map<String, Map<int, int>> examsPerSemester) {
    this._examsPerSemester = examsPerSemester;
  }

  /// Getter for [_examsPerSemester].
  Map<String, Map<int, int>> get examsPerSemester {
    Map<String, Map<int, int>> examsPerSemester = this._examsPerSemester;
    return examsPerSemester;
  }

  /// Setter for [_processedExams].
  set processedExams(ExamsProcessed processedExams) {
    this._processedExams = processedExams;
    notifyListeners();
  }

  /// Getter for [_processedExams].
  ExamsProcessed get processedExams {
    ExamsProcessed processedExams = _processedExams;
    return processedExams;
  }

  /// Setter for [_selectedLocation].
  set selectedLocation(String location) {
    this._selectedLocation = location;
  }

  /// Getter for [_selectedLocation].
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

  /// Prepares data for saving in the database.
  /// returns a [Map] containing the prepared data.
  Map<String, dynamic> _prepareExamDataForSaving() {
    Map<String, Map<String, dynamic>> preparedData = new Map();

    for (var zeile in _tableData.exams["0"]) {
      if (preparedData.containsKey(zeile.pruefung)) {
        if (zeile.vorschlag > preparedData[zeile.pruefung]['Semester']) {
          preparedData[zeile.pruefung]['Semester'] = zeile.vorschlag;
        }
      } else {
        Map<String, dynamic> singleRow = new Map();
        singleRow['Prüfung'] = zeile.pruefung;
        singleRow['Semester'] = zeile.vorschlag;
        singleRow['Ort'] = _isCatalog ? zeile.ort : _selectedLocation;

        preparedData[zeile.pruefung] = singleRow;
      }
    }

    return preparedData;
  }

  /// Prepares data for saving in the database.
  /// returns a [Map] containing the prepared data.
  Map<String, dynamic> _prepareModuleDataForSaving() {
    Map<String, dynamic> preparedData = new Map();
    int baseIndex = 0;

    for (var zeile in _tableData.modules["0"]) {
      Map<String, dynamic> singleRow = new Map();
      singleRow['Veranstaltung'] = zeile.veranstaltung;
      singleRow['Jahr'] = zeile.jahr;
      singleRow['Sem'] = zeile.semester;
      singleRow['Vorschlag'] = zeile.vorschlag;
      singleRow['Wochentag'] = zeile.wochentag;
      singleRow['Beginn'] = zeile.beginn;
      singleRow['Ort'] = zeile.ort;

      preparedData[baseIndex.toString()] = singleRow;
      baseIndex++;
    }

    return preparedData;
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

  void saveTableData(GlobalKey<ScaffoldState> scaffoldKey, BuildContext ctx) {
    TextEditingController catalogNameController = new TextEditingController();

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (_) {
        return SingleChildScrollView(
          child: Card(
            child: Container(
              padding: MediaQuery.of(ctx).viewInsets,
              child: Column(
                children: [
                  CustomFormField(
                    'Katalogbezeichnung',
                    catalogNameController,
                  ),
                  PaddingButton(
                    'Speichern',
                    () async {
                      if (catalogNameController.text != '') {
                        var body = new Map<String, dynamic>();
                        body["function"] = 'setModulesOfUser';
                        body["data"] =
                            json.encode(_prepareModuleDataForSaving());
                        body["footerData"] =
                            json.encode(_prepareExamDataForSaving());
                        body["previsitedModules"] = json.encode(new Map());
                        body["previsitedExams"] = json.encode(new Map());
                        body["location"] = _selectedLocation;
                        body["catalogName"] = catalogNameController.text;

                        Map<String, dynamic> response =
                            await XmlRequestService.createPost(body, ctx);

                        String snackBarText;

                        if (response['success'] == true) {
                          snackBarText = 'Erfolgreich gespeichert!';
                        } else {
                          snackBarText = 'Speichern fehlgeschlagen.';
                        }

                        final snackBar = SnackBar(
                          content: SnackbarText(snackBarText, Colors.green),
                        );
                        scaffoldKey.currentState.showSnackBar(snackBar);

                        Navigator.of(ctx).pop();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Process the data of the exams.
  /// [fullData] contains all data for exams and modules.
  /// [ctx] the given BuildContext.
  void processFooterData(BuildContext ctx) {
    TableData fullData = this.tableData;
    String selectedLocation = this.selectedLocation;
    Map<String, int> duplicates = this.formerDuplicates;
    ExamsProcessed pruefungen = new ExamsProcessed();
    pruefungen.exams = new Map();

    for (var zeile in fullData.exams["0"]) {
      if (pruefungen.exams.containsKey(zeile.pruefung)) {
        if (zeile.vorschlag > pruefungen.exams[zeile.pruefung].vorschlag) {
          pruefungen.exams[zeile.pruefung].vorschlag = zeile.vorschlag;
        }
        pruefungen.exams[zeile.pruefung].veranstaltungen
            .add(zeile.veranstaltung);
      } else {
        ExamProcessed newExam = new ExamProcessed();
        newExam.pruefung = zeile.pruefung;
        newExam.veranstaltungen = [zeile.veranstaltung];
        newExam.vorschlag = zeile.vorschlag;
        newExam.ort = zeile.ort == null ? selectedLocation : zeile.ort;
        pruefungen.exams.addAll({zeile.pruefung: newExam});
      }

      /* Since an exam (normaly) depends on more than one module this
        loop has to be executed each time.
        Down here an exams-Object for the given exam ALWAYS exists. */
      duplicates.forEach((veranstaltung, vorschlag) {
        if (veranstaltung == zeile.veranstaltung &&
            vorschlag > pruefungen.exams[zeile.pruefung].vorschlag) {
          pruefungen.exams[zeile.pruefung].vorschlag = vorschlag;
        }
      });
    }

    this.processedExams = pruefungen;
  }

  /// Reset all properties of this class.
  void reset() {
    _tableData = new TableData();
    _formerDuplicates = new Map<String, int>();
    _examsPerSemester = new Map<String, Map<int, int>>();
    _processedExams = new ExamsProcessed();
    _selectedLocation = '';
    _isCatalog = false;
  }
}
