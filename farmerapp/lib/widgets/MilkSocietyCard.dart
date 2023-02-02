// ignore_for_file: file_names

import 'package:farmerapp/home/screens/MilkSocietyEnroll.dart';
import 'package:flutter/material.dart';
import '../home/models/Models.dart';

class MilkSocietyCard extends StatelessWidget {
  final MilkSociety ms;
  const MilkSocietyCard({Key? key, required this.ms}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: Text(ms.name),
            subtitle: Text(ms.address),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('View'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MilkSocietyEnroll(ms: ms)));
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
