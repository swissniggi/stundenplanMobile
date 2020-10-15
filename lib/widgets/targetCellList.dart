import 'package:flutter/material.dart';

import '../models/cells.dart';
import '../services/xmlRequest_service.dart';
import 'targetScrollView.dart';

class TargetCellList {
  void showTargetCells(String modulName, BuildContext ctx) async {
    String modulGroup = modulName.substring(0, modulName.length - 3);

    Cells.allCells.forEach((element) {
      if (element.childText == modulName) {
        Cells.selectedCell = element;
      }
    });

    var body = new Map<String, dynamic>();
    body["function"] = 'getPossibleTargetData';
    body["modulgroupName"] = modulGroup;

    Map<String, dynamic> response = await XmlRequestService.createPost(body);

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
