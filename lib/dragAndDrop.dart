import 'package:flutter/material.dart';

import 'widgets/targetScrollView.dart';
import 'xmlRequest.dart';

class DragAndDrop {
  void getTargetCells(String modulName, Map<dynamic, dynamic> tableData,
      BuildContext ctx) async {
    String modulType = modulName.substring(0, modulName.length - 3);

    var body = new Map<String, dynamic>();
    body["function"] = 'getPossibleTargetData';
    body["modulgroupName"] = modulType;

    Map<String, dynamic> response = await XmlRequest.createPost(body);

    if (response != null) {
      showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              child: TargetScrollView(response),
              behavior: HitTestBehavior.opaque);
        },
      );
    }
  }
}
