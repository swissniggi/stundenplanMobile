import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'timeTable_screen.dart';
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

class DropDownsScreen extends StatefulWidget {
  static const routeName = '/topicSelection';

  @override
  _DropDownsScreenState createState() => _DropDownsScreenState();
}

class _DropDownsScreenState extends State<DropDownsScreen> {
  String _selectedCatalog;
  bool _isLoading = false;
  int _groupValue = -1;
  List<String> locations = ['Muttenz', 'Windisch'];

  List<String> userCatalog = [];

  Padding _createCatalogs() {
    _prepareCatalogData();
    if (userCatalog.isNotEmpty) {
      var catalogs = Padding(
        padding: const EdgeInsets.all(30.0),
        child: new DropdownButton<String>(
            value: _selectedCatalog,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 28,
            elevation: 16,
            isExpanded: true,
            style: TextStyle(fontSize: 22, color: Colors.black),
            items: userCatalog.map((String value) {
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
        if (userCatalog.length == 0) {
          _selectedCatalog = ' -- Wählen Sie einen Stundenplan aus -- ';
          userCatalog.add(_selectedCatalog);
        }
        for (var i = 0; i < response['0'].length; i++) {
          var dateArray = response['0'][i]['Erstellt'].split('-');
          var datum = dateArray[2] + '.' + dateArray[1] + '.' + dateArray[0];
          var catalog =
              response['0'][i]['Bezeichnung'] + ', erstellt am ' + datum;

          if (!userCatalog.contains(catalog)) {
            userCatalog.add(catalog);
          }
        }
      }
    } else if (response['sessionTimedOut'] == true) {
      Provider.of<SecurityProvider>(context, listen: false)
          .logoutOnTimeOut(context);
    }
  }

  void _createTimeTables() async {
    if ((PaddingDropDownButton.selectedValues[0] !=
                PaddingDropDownButton.dropDownValues[0] &&
            PaddingDropDownButton.selectedValues[1] !=
                PaddingDropDownButton.dropDownValues[0] &&
            PaddingDropDownButton.selectedValues[2] !=
                PaddingDropDownButton.dropDownValues[0] &&
            _groupValue >= 0) ||
        (_selectedCatalog != null && _selectedCatalog != userCatalog[0])) {
      setState(() {
        _isLoading = true;
      });

      var body = new Map<String, dynamic>();

      bool isCatalog = false;

      if (_selectedCatalog != null && _selectedCatalog != userCatalog[0]) {
        var catalogId = userCatalog.indexOf(_selectedCatalog);
        body["function"] = 'getModulesOfUser';
        body["catalogId"] = catalogId.toString();
        isCatalog = true;
      } else {
        body["function"] = 'getAllModules';
        body["location"] = locations[_groupValue] == 'Muttenz' ? 'MU' : 'WI';
        body["faecher"] = PaddingDropDownButton.selectedValues[0] +
            ',' +
            PaddingDropDownButton.selectedValues[1] +
            ',' +
            PaddingDropDownButton.selectedValues[2];
      }

      Map<String, dynamic> response =
          await XmlRequestService.createPost(body, context);

      if (response['success']) {
        Provider.of<TableDataProvider>(context, listen: false).newTableData =
            response;
        Provider.of<TableDataProvider>(context, listen: false).isCatalog =
            isCatalog;

        Navigator.of(context).pushReplacementNamed(TimeTableScreen.routeName);
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
                  PaddingButton('Stundenplan erstellen', _createTimeTables),
                ],
              ),
            ),
    );
  }
}
