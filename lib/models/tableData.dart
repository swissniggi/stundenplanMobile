class TableData {
  Map<String, List<ModuleData>> modules;
  Map<String, List<ExamData>> exams;
}

class ModuleData {
  String fach;
  String veranstaltung;
  int jahr;
  String semester;
  int wochentag;
  int beginn;
  int ende;
  int vorschlag;
  int typ;
  String beschreibung;
  String ort;
  bool confirmed;
}

class ExamData {
  String pruefung;
  String veranstaltung;
  int vorschlag;
  String kuerzel;
  int kreditpunkte;
  String ort;
}
