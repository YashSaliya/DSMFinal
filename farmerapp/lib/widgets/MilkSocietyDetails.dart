// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../home/models/Models.dart';

class MilkSocietyDetails extends StatelessWidget {
  final MilkSociety ms;
  const MilkSocietyDetails({Key? key, required this.ms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.account_balance),
          title: Text(ms.name),
          subtitle: Text(ms.address),
        ),
        ListTile(
          leading: const Icon(Icons.storage),
          title: Text(ms.storageCapacity.toString()),
          subtitle: const Text("Storage Capacity"),
        ),
      ],
    );
    // return Container(
    //   child: const Text("hello")
    // );
  }
}
