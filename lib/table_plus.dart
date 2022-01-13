import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
// import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class TablePlus extends StatefulWidget {
  final bool isSearchEnabled;

  const TablePlus({Key? key, required this.isSearchEnabled}) : super(key: key);

  @override
  _TablePlusState createState() => _TablePlusState();
}

List<List<String>> data = [
  ["No.", "Name", "Roll No."],
  ["1", "1", "1"],
  ["2", "2", "2"],
  ["3", "3", "3"]
];

class _TablePlusState extends State<TablePlus> {
  final TextEditingController _searchFirstNameTextController =
      TextEditingController();
  final TextEditingController _searchLastNameTextController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          bodyData(),
          InkWell(
            onTap: () {
              getCsv();
            },
            child: Container(
              child: const Text("Export as CSV"),
            ),
          )
        ],
      ),
    );
  }

  Widget searchWidget(searchCtrl, otherTxtCtrl, isFirstName) {
    return Container(
      height: 25.0,
      width: MediaQuery.of(context).size.width * 0.3,
      margin: const EdgeInsets.only(top: 30.0, bottom: 10.0),
      child: TextField(
        decoration: const InputDecoration(hintText: "Search..."),
        controller: searchCtrl,
        onChanged: (value) {
          otherTxtCtrl.clear();
          List<Name> searchList = onChangedFunction(value, isFirstName);
          setState(() {
            searchNameList = searchList;
          });
        },
      ),
    );
  }

  Widget bodyData() => DataTable(
      columnSpacing: 60,
      headingRowHeight: widget.isSearchEnabled ? 130.0 : 56.0,
      onSelectAll: (b) {},
      sortColumnIndex: 1,
      sortAscending: true,
      columns: <DataColumn>[
        DataColumn(
          label: Container(
            margin: widget.isSearchEnabled
                ? const EdgeInsets.only(top: 25.0, bottom: 20.0)
                : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "First Name",
                  style: TextStyle(color: Colors.black),
                ),
                widget.isSearchEnabled
                    ? searchWidget(_searchFirstNameTextController,
                        _searchLastNameTextController, true)
                    : Container(),
              ],
            ),
          ),
          numeric: false,
          tooltip: "To display first name of the Name",
        ),
        DataColumn(
          label: Container(
            margin: widget.isSearchEnabled
                ? const EdgeInsets.only(top: 25.0, bottom: 20.0)
                : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Last Name",
                  style: TextStyle(color: Colors.black),
                ),
                widget.isSearchEnabled
                    ? searchWidget(_searchLastNameTextController,
                        _searchFirstNameTextController, false)
                    : Container(),
              ],
            ),
          ),
          numeric: false,
          tooltip: "To display last name of the Name",
        ),
      ],
      rows: _searchFirstNameTextController.text.isNotEmpty ||
              _searchLastNameTextController.text.isNotEmpty
          ? searchNameList
              .map(
                (name) => DataRow(
                  cells: [
                    DataCell(
                      Text(name.firstName),
                      showEditIcon: false,
                      placeholder: false,
                    ),
                    DataCell(
                      Text(name.lastName),
                      showEditIcon: false,
                      placeholder: false,
                    )
                  ],
                ),
              )
              .toList()
          : names
              .map(
                (name) => DataRow(
                  cells: [
                    DataCell(
                      Text(name.firstName),
                      showEditIcon: false,
                      placeholder: false,
                    ),
                    DataCell(
                      Text(name.lastName),
                      showEditIcon: false,
                      placeholder: false,
                    )
                  ],
                ),
              )
              .toList());

  getCsv() async {
    List<String> nameContexts = <String>[];
    List<List<String>> data = [];
    data.add(["Fist Name", "Last Name"]);

    for (int i = 0; i < names.length; i++) {
      nameContexts = [names[i].firstName, names[i].lastName];
      data.add(nameContexts);
    }
    // exportCSV(names, context);

    if (await requestPermission()) {
//store file in documents folder
      String dir = '';
      if (Platform.isAndroid) {
        // saveInStorage("mycsv",

        // File.fromUri((await getExternalStorageDirectory())!.uri), "csv");
        // dir = (await getApplicationDocumentsDirectory(
        //     ExtStorage.DIRECTORY_DOWNLOADS)) + "/mycsv.csv";
        // dir = (await getApplicationDocumentsDirectory()).path + "/mycsv.csv";
        dir = (await getApplicationSupportDirectory()).path + "/mycsv.csv";
      } else {
        dir = (await getApplicationSupportDirectory()).path + "/mycsv.csv";
      }
      String file = dir;

      File f = File(file);

// convert rows to String and write as csv file

      String csv = const ListToCsvConverter().convert(data);
      f.writeAsString(csv);
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
  }

  /* static Future saveInStorage(
      String fileName, File file, String extension) async {
    String _localPath = (await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS))!;
    String filePath = _localPath +
        "/" +
        fileName.trim() +
        "_" +
        const Uuid().v4() +
        extension;

    File fileDef = File(filePath);
    await fileDef.create(recursive: true);
    Uint8List bytes = await file.readAsBytes();
    await fileDef.writeAsBytes(bytes);
  }*/

  Future<bool> requestPermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    var status1 = await Permission.manageExternalStorage.status;
    if (!status1.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    return status.isGranted && status1.isGranted;
  }
}

class Name {
  String firstName;
  String lastName;

  Name({required this.firstName, required this.lastName});
}

var names = <Name>[
  Name(firstName: "Pawan", lastName: "Kumar"),
  Name(firstName: "Aakash", lastName: "Tewari"),
  Name(firstName: "Rohan", lastName: "Singh"),
  Name(firstName: "rajesh", lastName: "ajeeth"),
  Name(firstName: "babu", lastName: "balaji"),
  Name(firstName: "raj", lastName: "thulasi"),
  Name(firstName: "mohan", lastName: "sasi"),
  Name(firstName: "sundar", lastName: "jothi"),
  Name(firstName: "veera", lastName: "eashwari"),
];

List<Name> searchNameList = <Name>[];

List<Name> onChangedFunction(String value, bool isFirstName) {
  List<Name> searchList = <Name>[];

  if (value != null && value.isNotEmpty) {
    searchList.clear();
    for (int i = 0; i < names.length; i++) {
      String data = isFirstName ? names[i].firstName : names[i].lastName;
      Name nameData = names[i];
      if (data.toLowerCase().contains(value.toLowerCase())) {
        searchList.add(nameData);
      }
    }
  } else {}
  return searchList;
}
/*
exportCSV(dynamic value, BuildContext context) async {
  String csvData = const ListToCsvConverter().convert(data);
  final String directory = (await getApplicationSupportDirectory()).path;
  final path = "$directory/csv-${DateTime.now()}.csv";
  if (kDebugMode) {
    print(path);
  }
  final File file = File(path);
  await file.writeAsString(csvData);
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) {
        return LoadCsvDataScreen(path: path);
      },
    ),
  );
}*/
