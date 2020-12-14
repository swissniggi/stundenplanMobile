import 'package:NAWI/models/pointers.dart';
import 'package:NAWI/screens/examTables_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'moduleTables_screen.dart';
import '../screens/welcome_screen.dart';
import '../providers/security_provider.dart';
import '../providers/tabledata_provider.dart';
import '../providers/user_provider.dart';
import '../services/xmlRequest_service.dart';
import '../widgets/paddingButton.dart';
import '../widgets/paddingDropDownButton.dart';
import '../widgets/paddingRadio.dart';
import '../widgets/showDialog.dart';
import '../widgets/simpleText.dart';
import '../widgets/nawiDrawer.dart';

/// Return a [Scaffold] displaying the dropdown screen.
class DropDownsScreen extends StatefulWidget {
  /// The route name of the screen.
  static const routeName = '/topicSelection';

  @override
  _DropDownsScreenState createState() => _DropDownsScreenState();
}

class _DropDownsScreenState extends State<DropDownsScreen> {
  String _selectedCatalog;
  bool _isLoading = false;
  int _groupValue = -1;
  List<String> _locations = ['Muttenz', 'Windisch'];

  List<String> _userCatalog = [];

  /// Create a dropdown with the given catalog data.
  /// returns a [Padding] containing the dropdown if there are any catalogs
  /// else returns an empty [Padding].
  Padding _createCatalogs() {
    _prepareCatalogData();
    if (_userCatalog.isNotEmpty) {
      var catalogs = Padding(
        padding: const EdgeInsets.all(30.0),
        child: new DropdownButton<String>(
            value: _selectedCatalog,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 28,
            elevation: 16,
            isExpanded: true,
            style: TextStyle(fontSize: 22, color: Colors.black),
            items: _userCatalog.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (String newValue) {
              setState(() {
                _selectedCatalog = newValue;
              });
            }),
      );
      return catalogs;
    } else {
      return Padding(padding: EdgeInsets.all(30.0));
    }
  }

  PaddingDropDownButton _createDropDown(int index) {
    return PaddingDropDownButton(
        index,
        (String newValue) => setState(
            () => PaddingDropDownButton.selectedValues[index] = newValue));
  }

  /// Get the catalogs of the current user from the server.
  /// fills [_userCatalog] with the response data if any received.
  void _prepareCatalogData() async {
    var body = new Map<String, dynamic>();
    String username =
        Provider.of<UserProvider>(context, listen: false).username;
    body["function"] = 'getCatalogsOfUser';
    body["username"] = username;
    Map<String, dynamic> response =
        await XmlRequestService.createPost(body, context);

    if (response['success'] == true) {
      if (response['0'].length > 0) {
        if (_userCatalog.length == 0) {
          _selectedCatalog = ' -- Wählen Sie einen Stundenplan aus -- ';
          _userCatalog.add(_selectedCatalog);
        }
        for (var i = 0; i < response['0'].length; i++) {
          var dateArray = response['0'][i]['Erstellt'].split('-');
          var datum = dateArray[2] + '.' + dateArray[1] + '.' + dateArray[0];
          var catalog =
              response['0'][i]['Bezeichnung'] + ', erstellt am ' + datum;

          if (!_userCatalog.contains(catalog)) {
            _userCatalog.add(catalog);
          }
        }
      }
    } else if (response['sessionTimedOut'] == true) {
      Provider.of<SecurityProvider>(context, listen: false)
          .logoutOnTimeOut(context);
    }
  }

  /// Get the timetable data from the server
  /// and redirect to the [ModuleTablesScreen].
  /// call [showCustomDialog()] if less than 3 topics have been chosen
  /// or if no location has been chosen.
  /// call [showErrorDialog()] if an error occurs.
  void _getTimeTableDataAndRedirect() async {
    if ((PaddingDropDownButton.selectedValues[0] !=
                PaddingDropDownButton.dropDownValues[0] &&
            PaddingDropDownButton.selectedValues[1] !=
                PaddingDropDownButton.dropDownValues[0] &&
            PaddingDropDownButton.selectedValues[2] !=
                PaddingDropDownButton.dropDownValues[0] &&
            _groupValue >= 0) ||
        (_selectedCatalog != null && _selectedCatalog != _userCatalog[0])) {
      setState(() {
        _isLoading = true;
      });

      var body = new Map<String, dynamic>();

      bool isCatalog = false;

      if (_selectedCatalog != null && _selectedCatalog != _userCatalog[0]) {
        var catalogId = _userCatalog.indexOf(_selectedCatalog);
        body["function"] = 'getModulesOfUser';
        body["catalogId"] = catalogId.toString();
        isCatalog = true;
      } else {
        body["function"] = 'getAllModules';
        body["location"] = _locations[_groupValue] == 'Muttenz' ? 'MU' : 'WI';
        body["faecher"] = PaddingDropDownButton.selectedValues[0] +
            ',' +
            PaddingDropDownButton.selectedValues[1] +
            ',' +
            PaddingDropDownButton.selectedValues[2];
      }

      Map<String, dynamic> response =
          await XmlRequestService.createPost(body, context);

      if (response['success']) {
        TableDataProvider tableDataProvider =
            Provider.of<TableDataProvider>(context, listen: false);
        tableDataProvider.reset();
        Pointers.resetPointers();
        tableDataProvider.newTableData = response;
        tableDataProvider.isCatalog = isCatalog;

        if (!isCatalog) {
          tableDataProvider.selectedLocation = _locations[_groupValue];
        }

        Navigator.of(context)
            .pushReplacementNamed(ModuleTablesScreen.routeName);
      } else if (response['sessionTimedOut'] == true) {
        Provider.of<SecurityProvider>(context, listen: false)
            .logoutOnTimeOut(context);
      } else {
        Provider.of<SecurityProvider>(context, listen: false)
            .showErrorDialog(context, response['message']);

        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ShowDialog dialog = new ShowDialog();
      dialog.showCustomDialog(
        'Fehler',
        () {
          Navigator.of(context).pop();
        },
        context,
        [
          Text('Sie müssen drei Fächer und einen Standort'),
          Text('oder einen Stundenplan wählen.')
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stundenplan FHNW'),
        centerTitle: true,
      ),
      drawer: NawiDrawer(WelcomeScreen.routeName, 'Zum Hauptmenü'),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _createDropDown(0),
                  _createDropDown(1),
                  _createDropDown(2),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        PaddingRadio(0, _groupValue,
                            (value) => setState(() => _groupValue = value)),
                        SimpleText('Muttenz')
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      PaddingRadio(1, _groupValue,
                          (value) => setState(() => _groupValue = value)),
                      SimpleText('Windisch')
                    ],
                  ),
                  _createCatalogs(),
                  PaddingButton(
                      'Stundenplan erstellen', _getTimeTableDataAndRedirect),
                ],
              ),
            ),
    );
  }
}
