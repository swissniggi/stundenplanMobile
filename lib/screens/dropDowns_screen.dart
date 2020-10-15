import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tabledata_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/paddingButton.dart';
import '../widgets/paddingDropDownButton.dart';
import '../widgets/paddingRadio.dart';
import '../widgets/showDialog.dart';
import '../widgets/simpleText.dart';
import '../services/xmlRequest_service.dart';
import 'timeTable_screen.dart';

class DropDownsScreen extends StatefulWidget {
  static const routeName = '/topicSelection';

  @override
  _DropDownsScreenState createState() => _DropDownsScreenState();
}

class _DropDownsScreenState extends State<DropDownsScreen> {
  String selectedCatalog;

  var _groupValue = -1;
  List<String> locations = ['Muttenz', 'Windisch'];

  List<String> userCatalog = [];

  Padding _createCatalogs() {
    _prepareCatalogData();
    if (userCatalog.isNotEmpty) {
      var catalogs = Padding(
        padding: const EdgeInsets.all(30.0),
        child: new DropdownButton<String>(
            value: selectedCatalog,
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
                selectedCatalog = newValue;
              });
            }),
      );
      return catalogs;
    } else {
      return Padding(padding: EdgeInsets.all(30.0));
    }
  }

  PaddingDropDownButton _createDropDown(var index) {
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
    Map<String, dynamic> response = await XmlRequestService.createPost(body);

    if (response['success'] == true) {
      if (response['0'].length > 0) {
        if (userCatalog.length == 0) {
          selectedCatalog = ' -- Wählen Sie einen Stundenplan aus -- ';
          userCatalog.add(selectedCatalog);
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
        (selectedCatalog != null && selectedCatalog != userCatalog[0])) {
      var body = new Map<String, dynamic>();

      bool isCatalog = false;

      if (selectedCatalog != null && selectedCatalog != userCatalog[0]) {
        var catalogId = userCatalog.indexOf(selectedCatalog);
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

      Map<String, dynamic> response = await XmlRequestService.createPost(body);

      Provider.of<TableDataProvider>(context, listen: false).newTableData =
          response;
      Provider.of<TableDataProvider>(context, listen: false).isCatalogValue =
          isCatalog;

      Navigator.of(context).pushReplacementNamed(TimeTableScreen.routeName);
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

  void _logoutUser() {
    var body = new Map<String, dynamic>();
    body["function"] = 'logoutUser';
    XmlRequestService.createPost(body);
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: _logoutUser,
        ),
        title: Text('Stundenplan FHNW'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _createDropDown(0),
            _createDropDown(1),
            _createDropDown(2),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
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
