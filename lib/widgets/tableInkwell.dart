import 'package:flutter/material.dart';

import '../models/cells.dart';
import '../models/pointers.dart';
import 'tableContainer.dart';
import 'targetCellList.dart';

class TableInkwell {
  final BuildContext ctx;
  final Map<String, dynamic> tableData;
  final List<Color> colors;
  final List<Pointer> pointerList;

  TableInkwell(this.ctx, this.tableData, this.colors, this.pointerList);

  List<Widget> buildList() {
    List<Widget> wells = new List<Widget>();

    for (var i = 0; i < pointerList.length; i++) {
      bool hasContent = false;
      String module = '';
      String year = '';
      String sem = '';
      String location = '';
      int type = 0;

      if (tableData.containsKey(pointerList[i].id)) {
        hasContent = true;
        module = tableData[pointerList[i].id]['name'];
        year = tableData[pointerList[i].id]['year'].toString();
        sem = tableData[pointerList[i].id]['sem'];
        location = tableData[pointerList[i].id]['location'];
        type = tableData[pointerList[i].id]['typ'];
      }

      pointerList[i]
          .content
          .putIfAbsent(year + '.' + sem + '.' + location, () => hasContent);

      var newWell = InkWell(
        onLongPress: tableData[pointerList[i].id] == null
            ? () => {}
            : () {
                TargetCellList dAD = new TargetCellList();
                dAD.showTargetCells(module, ctx);
              },
        child: TableContainer(
          module,
          Colors.black,
          colors[type],
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
      Cells.allCells.add(newWell.child);
    }

    return wells;
  }
}
