import 'package:flutter/material.dart';

import '../models/cells.dart';
import '../models/pointers.dart';
import 'tableContainer.dart';
import '../services/targetCellList_service.dart';

class ModuleTableInkwell {
  /// The given [BuildContext].
  final BuildContext ctx;

  /// The data to be display in the [InkWell]s.
  final Map<String, dynamic> tableData;

  /// A [List] of all module colors.
  final List<Color> colors;

  /// The location of the current table.
  final String location;

  /// The semester of the current table.
  final String sem;

  /// The semester index of the current table.
  final int semIndex;

  /// The year of the current table.
  final String year;

  /// a [List] of [Pointer]s containing the id's of modules.
  final List<Pointer> pointerList;

  ModuleTableInkwell(this.ctx, this.tableData, this.colors, this.location,
      this.sem, this.semIndex, this.year, this.pointerList);

  /// Creates a [List] of [InkWell]s either empty
  /// or containing the data of the designated module.
  List<InkWell> buildList() {
    List<InkWell> wells = new List<InkWell>();

    for (var i = 0; i < pointerList.length; i++) {
      bool hasContent = false;
      String module = '';
      String year = this.year;
      String sem = this.sem;
      String location = this.location;
      int type = 0;
      int prop = semIndex;

      if (tableData.containsKey(pointerList[i].id)) {
        hasContent = true;
        module = tableData[pointerList[i].id]['name'];
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
                TargetCellListService possibleTargetList =
                    new TargetCellListService();
                possibleTargetList.showTargetCells(module, ctx);
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
              year.toString() +
              '.' +
              prop.toString(),
        ),
      );

      wells.add(newWell);
      Cells.allCells.add(newWell.child);
    }

    return wells;
  }
}
