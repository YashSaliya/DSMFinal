// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmerapp/widgets/Contract.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowContracts extends StatefulWidget {
  final String? cityVal;
  const ShowContracts({Key? key, this.cityVal}) : super(key: key);

  @override
  _ShowContractsState createState() => _ShowContractsState();
}

class _ShowContractsState extends State<ShowContracts> {
  late final CollectionReference _collectionReference;

  Future<void> _precheck() async {
    final SharedPreferences sh = await SharedPreferences.getInstance();
    String? uid = sh.getString('userId');
    _collectionReference = FirebaseFirestore.instance
        .collection(widget.cityVal ?? "")
        .doc('milkSociety')
        .collection('district_farmer')
        .doc(uid)
        .collection('Contract');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Contracts"),
        ),
        body: FutureBuilder(
            future: _precheck(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.connectionState == ConnectionState.active) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return StreamBuilder<QuerySnapshot>(
                  stream: _collectionReference.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
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
                );
              }
            }));
  }
}
