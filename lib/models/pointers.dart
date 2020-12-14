class Pointer {
  String id;
  Map<String, bool> _content = new Map();

  Pointer(this.id);

  Map<String, bool> get content {
    return this._content;
  }
}

class Pointers {
  static List<List<Pointer>> pointers = [
    [
      new Pointer('1.08'),
      new Pointer('2.08'),
      new Pointer('3.08'),
      new Pointer('4.08'),
      new Pointer('5.08'),
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
}
