import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/security_provider.dart';
import '../models/cells.dart';
import 'xmlRequest_service.dart';
import '../widgets/targetScrollView.dart';

class TargetCellListService {
  /// Get all possible targets and
  /// call [showModalBottomSheet()] to display them.
  /// [modulName] contains the name of the chosen module.
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

    Map<String, dynamic> response =
        await XmlRequestService.createPost(body, ctx);

    if (response['sessionTimedOut'] == true) {
      Provider.of<SecurityProvider>(ctx, listen: false).logoutOnTimeOut(ctx);
    } else if (response.containsKey('message')) {
      Provider.of<SecurityProvider>(ctx, listen: false)
          .showErrorDialog(ctx, response['message']);
    }

    if (response != null) {
      showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return TargetScrollView(response);
        },
      );
    }
  }
}
