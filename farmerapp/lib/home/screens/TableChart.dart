// ignore_for_file: prefer_const_constructors

import 'package:farmerapp/home/DOS/fetchFarmerRecords.dart';
import 'package:flutter/material.dart';

class DataTableDemo extends StatefulWidget {
  final String? cityVal;
  const DataTableDemo({Key? key, required this.cityVal}) : super(key: key);

  final String title = "Data Table";

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  late List<User> users;
  late bool sort;

  @override
  void initState(){
    sort = true;
    users = [];
    super.initState();
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        users.sort((a, b) => a.name.compareTo(b.name));
      } else {
        users.sort((a, b) => b.name.compareTo(a.name));
      }
    }
  }

  DataTable dataBody(userList) {
    return DataTable(
      sortAscending: sort,
      sortColumnIndex: 0,
      columns: [
        DataColumn(
            label: Text("NAME"),
            numeric: false,
            onSort: (columnIndex, ascending) {
              setState(() {
                sort = !sort;
              });
              onSortColum(columnIndex, ascending);
            }),
        DataColumn(
          label: Text("DATE"),
          numeric: false,
        ),
        DataColumn(
          label: Text("QUANTITY"),
          numeric: false,
        ),
        DataColumn(
            label: Text("AMOUNT"),
            numeric: true,
            onSort: (columnIndex, ascending) {
              setState(() {
                sort = !sort;
              });
              onSortColum(columnIndex, ascending);
            }),
        DataColumn(
          label: Text("FAT PERCENT"),
          numeric: false,
        ),
        DataColumn(
          label: Text("MILK TYPE"),
          numeric: false,
        ),
        DataColumn(
          label: Text("RATE"),
          numeric: false,
        ),
        DataColumn(
          label: Text("SHIFT"),
          numeric: false,
        ),
      ],
      rows: userList
          .map<DataRow>(
            (user) => DataRow(cells: [
          DataCell(
            Text(user.name),
          ),
          DataCell(
            Text(user.date),
          ),
          DataCell(
            Text(user.quantity),
          ),
          DataCell(
            Text(user.amount),
          ),
          DataCell(
            Text(user.fatPercent),
          ),
          DataCell(
            Text(user.milkType),
          ),
          DataCell(
            Text(user.rate),
          ),
          DataCell(
            Text(user.shift),
          ),
        ]),
      )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: fetchRecords( cityVal: widget.cityVal).fetchList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: dataBody(snapshot.data),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

