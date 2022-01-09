import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TablePlus extends StatefulWidget {
  const TablePlus({Key? key}) : super(key: key);

  static const MethodChannel _channel = MethodChannel('table_plus');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  @override
  _TablePlusState createState() => _TablePlusState();
}

class _TablePlusState extends State<TablePlus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Table(
        defaultColumnWidth: FixedColumnWidth(120.0),
        border: TableBorder.all(
            color: Colors.black, style: BorderStyle.solid, width: 2),
        children: [
          TableRow(children: [
            Column(
                children: [Text('Website', style: TextStyle(fontSize: 20.0))]),
            Column(
                children: [Text('Tutorial', style: TextStyle(fontSize: 20.0))]),
            Column(
                children: [Text('Review', style: TextStyle(fontSize: 20.0))]),
          ]),
          TableRow(children: [
            Column(children: [Text('Javatpoint')]),
            Column(children: [Text('Flutter')]),
            Column(children: [Text('5*')]),
          ]),
          TableRow(children: [
            Column(children: [Text('Javatpoint')]),
            Column(children: [Text('MySQL')]),
            Column(children: [Text('5*')]),
          ]),
          TableRow(children: [
            Column(children: [Text('Javatpoint')]),
            Column(children: [Text('ReactJS')]),
            Column(children: [Text('5*')]),
          ]),
        ],
      ),
    );
  }
}
