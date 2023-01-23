import 'package:flutter/material.dart';

import '../models/Models.dart';


class MilkSocietyDetails extends StatelessWidget{
  final MilkSociety ms;
  const MilkSocietyDetails({Key? key, required this.ms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ms.name!),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: Text(ms.name!),
            subtitle: Text(ms.address!),
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: Text(ms.storageCapacity.toString()),
            subtitle: const Text("Storage Capacity"),
          ),
          Center(
            child: ElevatedButton(
              child: const Text("Become A Member"),
              onPressed: () {

              },
            ),
          ),
        ],
      ),
    );
  }
}