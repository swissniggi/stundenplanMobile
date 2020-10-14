import 'package:flutter/material.dart';

import 'tableContainer.dart';
import '../cellIdController.dart';
import '../openTargetCellList.dart';

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
                String module = tableData[pointerList[i].id]['name'];
                OpenTargetCellList dAD = new OpenTargetCellList();
                dAD.getTargetCells(module, tableData, ctx);
              },
        child: TableContainer(
          tableData[pointerList[i].id] == null
              ? ''
              : tableData[pointerList[i].id]['name'],
          Colors.black,
          tableData[pointerList[i].id] == null
              ? colors[0]
              : colors[tableData[pointerList[i].id]['typ']],
          pointerList[i].id +
              '.' +
              location +
              '.' +
              sem +
              '.' +
              year.toString(),
        ),
      );

      wells.add(newWell);
      CellIdController.cells.add(newWell.child);
    }

    return wells;
  }
}
