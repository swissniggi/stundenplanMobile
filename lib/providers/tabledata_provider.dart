import 'package:flutter/material.dart';

/// A provider for the table data.
class TableDataProvider with ChangeNotifier {
  /// A [Map] containing the table data.
  Map<String, dynamic> _tableData = new Map<String, dynamic>();

  /// A boolean to determine whether the data comes from a saved catalog.
  bool _isCatalog = false;

  /// Setter for the table data.
  set newTableData(Map<String, dynamic> data) {
    this._tableData = data;
    notifyListeners();
  }

  /// Getter for [_tableData].
  Map<String, dynamic> get tableData {
    final Map<String, dynamic> currentTableData = this._tableData;
    return currentTableData;
  }

  /// Setter for [_isCatalog].
  set isCatalog(bool isCatalog) {
    this._isCatalog = isCatalog;
    notifyListeners();
  }

  /// Getter for [_isCatalog].
  bool get isCatalog {
    return this._isCatalog;
  }

  /// Reset all properties of this class.
  void reset() {
    _tableData = new Map<String, dynamic>();
    _isCatalog = false;
  }
}
