import 'package:flutter/material.dart';

import '../models/cells.dart';
import '../models/pointers.dart';
import 'tableContainer.dart';
import 'targetCellList.dart';

class TableInkwell {
  /// The given [BuildContext].
  final BuildContext ctx;

  /// The data to be display in the [InkWell]s.
  final Map<String, dynamic> tableData;

  /// a [List] of all module colors.
  final List<Color> colors;

  /// a [List] of [Pointer]s containing the id's of modules.
  final List<Pointer> pointerList;

  TableInkwell(this.ctx, this.tableData, this.colors, this.pointerList);

  /// Creates a [List] of [InkWell]s either empty
  /// or containing the data of the designated module.
  List<InkWell> buildList() {
    List<InkWell> wells = new List<InkWell>();

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
