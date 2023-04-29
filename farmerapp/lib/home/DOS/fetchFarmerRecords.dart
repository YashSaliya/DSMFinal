

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import firebase
import 'package:cloud_firestore/cloud_firestore.dart';

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
}

class fetchRecords {
  final String? cityVal;
  fetchRecords({required this.cityVal});

  Future<List<User>>? fetchList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId') ?? "";
    return FirebaseFirestore.instance
        .collection(cityVal!)
        .doc('milkSociety')
        .collection('district_farmer')
        .doc(userId)
        .collection('Records')
        .get()
        .then((QuerySnapshot querySnapshot) {
            List<User> res = [];
            for (var doc in querySnapshot.docs) {
              res.add(User(
                  amount: doc['amt'].toString(),
                  date: doc['date'].toString(),
                  fatPercent: doc['fatpercent'].toString(),
                  milkType: doc['milktype'],
                  name: doc['name'],
                  quantity: doc['qty'].toString(),
                  rate: doc['rate'].toString(),
                  shift: doc['shift']
              ));
            }
            return res;
    });
  }
}
