import 'package:flutter/material.dart';

class TableDataProvider with ChangeNotifier {
  Map<String, dynamic> tableData = new Map<String, dynamic>();
  bool isCatalog = false;

  set newTableData(Map<String, dynamic> data) {
    this.tableData = data;
    notifyListeners();
  }

  Map<String, dynamic> get currentTableData {
    final Map<String, dynamic> currentTableData = this.tableData;
    return currentTableData;
  }

  set isCatalogValue(bool isCatalog) {
    this.isCatalog = isCatalog;
    notifyListeners();
  }

  bool get isCatalogValue {
    return this.isCatalog;
  }
}
