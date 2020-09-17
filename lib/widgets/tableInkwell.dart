import 'package:flutter/material.dart';

import '../cellIdController.dart';
import '../dragAndDrop.dart';
import 'tableContainer.dart';

class TableInkwell {
  final BuildContext ctx;
  final String sem;
  final int year;
  final String location;
  final Map<dynamic, dynamic> tableData;
  final List<Color> colors;
  final List<Pointer> pointerList;

  TableInkwell(this.ctx, this.sem, this.year, this.location, this.tableData,
      this.colors, this.pointerList);

  List<Widget> buildList() {
    List<Widget> wells = new List<Widget>();
    bool hasContent = false;

    for (var i = 0; i < pointerList.length; i++) {
      if (tableData[pointerList[i].id] != null) {
        hasContent = true;
      }
      pointerList[i].content.putIfAbsent(
          year.toString() + '.' + sem + '.' + location, () => hasContent);

      var newWell = InkWell(
        onLongPress: tableData[pointerList[i].id] == null
            ? () => {}
            : () {
                String modulGroup = tableData[pointerList[i].id]['name'];
                DragAndDrop dAD = new DragAndDrop();
                dAD.getTargetCells(modulGroup, tableData, ctx);
              },
        child: TableContainer(
          tableData[pointerList[i].id] == null
              ? ''
              : tableData[pointerList[i].id]['name'],
          Colors.black,
          tableData[pointerList[i].id] == null
              ? colors[0]
              : colors[tableData[pointerList[i].id]['typ']],
        ),
      );

      wells.add(newWell);
    }

    return wells;
  }
}
