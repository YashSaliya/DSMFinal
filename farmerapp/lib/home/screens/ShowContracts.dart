// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmerapp/widgets/Contract.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowContracts extends StatefulWidget {
  final String? cityVal;
  final String id;
  const ShowContracts({Key? key, this.cityVal, required this.id})
      : super(key: key);

  @override
  _ShowContractsState createState() => _ShowContractsState();
}

class _ShowContractsState extends State<ShowContracts> {
  late final CollectionReference _collectionReference;

  void _precheck() {
    _collectionReference = FirebaseFirestore.instance
        .collection(widget.cityVal ?? "")
        .doc('milkSociety')
        .collection('district_farmer')
        .doc(widget.id)
        .collection('Contract');
  }

  @override
  void initState() {
    super.initState();
    _precheck();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Contracts"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _collectionReference.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Text('Loading...');
            } else {
              List<DocumentSnapshot> ds = snapshot.data!.docs;
              return ListView(
                children: ds.map((DocumentSnapshot de) {
                  return ContractCard(ds: de);
                }).toList(),
              );
            }
          },
        ));
  }
}
