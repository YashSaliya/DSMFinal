import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Models.dart';

class fetchMS{
  final String? cityVal;
  fetchMS(this.cityVal);

  Future<List<MilkSociety>>? fetchList() {
    return FirebaseFirestore.instance
        .collection(cityVal!)
        .doc('milkSociety')
        .collection('district_ms')
        .get()
        .then((QuerySnapshot querySnapshot) {
      List<MilkSociety> msList = [];
      querySnapshot.docs.forEach((doc) {
        msList.add(MilkSociety(
         doc.id.toString(),doc['name'],doc['address'],doc['storage_capacity']
        ));
      });
      return msList;
    });
  }

}