import 'package:flutter/material.dart';

import 'dragAndDrop.dart';
import 'tableContainer.dart';

class TableInkwell {
  static Map<Widget, int> wellIds = new Map<Widget, int>();

  List<Widget> setTableInkwells(
      dynamic sem,
      dynamic year,
      Map<dynamic, dynamic> tableData,
      List<Color> colors,
      List<String> pointerList) {
    TableContainer container = new TableContainer();
    List<Widget> wells = new List<Widget>();

    for (var i = 0; i < pointerList.length; i++) {
      var newWell = InkWell(
        onTap: () => DragAndDrop.getTargetCells(
            sem.toString() + '.' + year.toString() + '.' + pointerList[i]),
        child: container.setTableContainer(
          tableData[pointerList[i]] == null
              ? ''
              : tableData[pointerList[i]]['name'],
          Colors.black,
          tableData[pointerList[i]] == null
              ? colors[0]
              : colors[tableData[pointerList[i]]['typ']],
        ),
      );

      wells.add(newWell);

      int wellId = int.parse(pointerList[i].substring(2));

      // this has to be added to class, not instance
      TableInkwell.wellIds.putIfAbsent(newWell, () => wellId);
    }

    return wells;
  }
}
