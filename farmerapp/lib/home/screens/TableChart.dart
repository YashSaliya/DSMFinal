// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DataTableDemo extends StatefulWidget {
  DataTableDemo() : super();

  final String title = "Data Table";

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  late List<User> users;
  late bool sort;

  @override
  void initState() {
    sort = false;
    users = User.getUsers();
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

  DataTable dataBody() {
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
          numeric: false,
        ),
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
      rows: users
          .map(
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: dataBody(),
          ),
        ],
      ),
    );
  }
}

class User {
  String amount;
  String date;
  String fatPercent;
  String milkType;
  String name;
  String quantity;
  String rate;
  String shift;

  User({
    required this.amount,
    required this.date,
    required this.fatPercent,
    required this.milkType,
    required this.name,
    required this.quantity,
    required this.rate,
    required this.shift,
  });

  static List<User> getUsers() {
    return <User>[
      User(
        amount: "12",
        date: "April 9, 2023 at 5:30:00 AM UTC+5:30",
        fatPercent: "2 %",
        milkType: "Cow",
        name: "ms1",
        quantity: "2",
        rate: "300",
        shift: "morning",
      ),
      User(
        amount: "12",
        date: "April 10, 2023 at 5:30:00 AM UTC+5:30",
        fatPercent: "2 %",
        milkType: "Cow",
        name: "ms2",
        quantity: "2",
        rate: "300",
        shift: "morning",
      ),
      User(
        amount: "12",
        date: "April 11, 2023 at 5:30:00 AM UTC+5:30",
        fatPercent: "2 %",
        milkType: "Cow",
        name: "ms3",
        quantity: "2",
        rate: "300",
        shift: "morning",
      ),
      User(
        amount: "12",
        date: "April 12, 2023 at 5:30:00 AM UTC+5:30",
        fatPercent: "2 %",
        milkType: "Cow",
        name: "ms4",
        quantity: "2",
        rate: "300",
        shift: "morning",
      ),
      User(
        amount: "12",
        date: "April 13, 2023 at 5:30:00 AM UTC+5:30",
        fatPercent: "2 %",
        milkType: "Cow",
        name: "ms5",
        quantity: "2",
        rate: "300",
        shift: "morning",
      ),
    ];
  }
}
