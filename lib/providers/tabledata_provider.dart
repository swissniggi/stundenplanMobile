import 'package:flutter/material.dart';

class TableDataProvider with ChangeNotifier {
  Map<String, dynamic> _tableData = new Map<String, dynamic>();
  bool _isCatalog = false;

  set newTableData(Map<String, dynamic> data) {
    this._tableData = data;
    notifyListeners();
  }

  Map<String, dynamic> get tableData {
    final Map<String, dynamic> currentTableData = this._tableData;
    return currentTableData;
  }

  set isCatalog(bool isCatalog) {
    this._isCatalog = isCatalog;
    notifyListeners();
  }

  bool get isCatalog {
    return this._isCatalog;
  }
}
