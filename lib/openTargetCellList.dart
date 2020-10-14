import 'package:flutter/material.dart';

import 'widgets/targetScrollView.dart';
import 'cellIdController.dart';
import 'xmlRequest.dart';

class OpenTargetCellList {
  void getTargetCells(String modulName, Map<dynamic, dynamic> tableData,
      BuildContext ctx) async {
    String modulGroup = modulName.substring(0, modulName.length - 3);

    CellIdController.cells.forEach((element) {
      if (element.childText == modulName) {
        CellIdController.selectedCell = element;
      }
    });

    var body = new Map<String, dynamic>();
    body["function"] = 'getPossibleTargetData';
    body["modulgroupName"] = modulGroup;

    Map<String, dynamic> response = await XmlRequest.createPost(body);

    if (response != null) {
      showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: TargetScrollView(response),
            behavior: HitTestBehavior.opaque,
          );
        },
      );
    }
  }
}
