import 'package:NAWI/main.dart';
import 'package:NAWI/widgets/paddingButton.dart';
import 'package:flutter/material.dart';

import 'widgets/paddingDropDownButton.dart';
import 'widgets/paddingRadio.dart';
import 'widgets/showDialog.dart';
import 'widgets/simpleText.dart';
import 'xmlRequest.dart';
import 'timeTable.dart';

class DropDowns extends StatefulWidget {
  DropDowns({Key key, this.title, this.username}) : super(key: key);

  final String title;

  final String username;

  @override
  _DropDownsState createState() => _DropDownsState();
}

class _DropDownsState extends State<DropDowns> {
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
    body["function"] = 'getCatalogsOfUser';
    body["username"] = widget.username;
    Map<String, dynamic> response = await XmlRequest.createPost(body);

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

      Map<String, dynamic> response = await XmlRequest.createPost(body);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TimeTable(
                  title: 'Stundenplan FHNW',
                  fullData: response,
                  isCatalog: isCatalog)));
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
    XmlRequest.createPost(body);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(title: 'Stundenplan FHNW')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: _logoutUser,
        ),
        title: Text(widget.title),
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
