//import
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../widgets/Drawer.dart';

class Homepage extends StatelessWidget {
  final String? cityVal;
  const Homepage({Key? key, required this.cityVal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(cityVal: cityVal),
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: const Center(
        child: Text("Welcome to Milk Society App"),
      ),
    );
  }
}
