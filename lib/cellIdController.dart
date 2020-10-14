import 'widgets/tableContainer.dart';

class Pointer {
  String id;
  Map<String, bool> _content = new Map();

  Pointer(this.id);

  Map<String, bool> get content {
    return this._content;
  }
}

class CellIdController {
  static List<List<Pointer>> pointers = [
    [
      new Pointer('1.8'),
      new Pointer('2.8'),
      new Pointer('3.8'),
      new Pointer('4.8'),
      new Pointer('5.8'),
    ],
    [
      new Pointer('1.10'),
      new Pointer('2.10'),
      new Pointer('3.10'),
      new Pointer('4.10'),
      new Pointer('5.10')
    ],
    [
      new Pointer('1.12'),
      new Pointer('2.12'),
      new Pointer('3.12'),
      new Pointer('4.12'),
      new Pointer('5.12')
    ],
    [
      new Pointer('1.14'),
      new Pointer('2.14'),
      new Pointer('3.14'),
      new Pointer('4.14'),
      new Pointer('5.14')
    ],
    [
      new Pointer('1.16'),
      new Pointer('2.16'),
      new Pointer('3.16'),
      new Pointer('4.16'),
      new Pointer('5.16')
    ],
    [
      new Pointer('1.18'),
      new Pointer('2.18'),
      new Pointer('3.18'),
      new Pointer('4.18'),
      new Pointer('5.18')
    ]
  ];

  // contains Inkwells with child of type TableContainer
  static List<TableContainer> cells = new List<TableContainer>();
  static TableContainer selectedCell;
}
