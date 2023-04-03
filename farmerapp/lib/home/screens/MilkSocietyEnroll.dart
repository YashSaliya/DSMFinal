// ignore_for_file: avoid_unnecessary_containers, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmerapp/home/models/Models.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/MilkSocietyDetails.dart';

class MilkSocietyEnroll extends StatefulWidget {
  final MilkSociety ms;
  const MilkSocietyEnroll({Key? key, required this.ms}) : super(key: key);

  @override
  _MilkSocietyEnrollState createState() => _MilkSocietyEnrollState();
}

class _MilkSocietyEnrollState extends State<MilkSocietyEnroll> {
  late final MilkSociety ms;
  String shiftSelected = "Morning";
  String animalSelected = "Cow";
  bool isEnrolled = false;
  late String uid;
  late String key;

  late SharedPreferences prefs;

  Future<bool>? precheck() async {
    ms = widget.ms;
    isEnrolled = await checkEnrollment();

    return isEnrolled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Enroll Milk Society"),
        ),
        body: FutureBuilder(
            future: precheck(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  bool t = snapshot.data as bool;
                  if (t) {
                    return Column(
                      children: [
                        Container(child: MilkSocietyDetails(ms: ms)),
                        const Center(
                            child: Text(
                                "You have already applied in this society")),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        Container(child: MilkSocietyDetails(ms: ms)),
                        Container(
                          child: Column(
                            children: [
                              const Text("Select Shift"),
                              DropdownButton<String>(
                                value: shiftSelected,
                                isExpanded: true,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    shiftSelected = newValue!;
                                  });
                                },
                                items: <String>[
                                  "Morning",
                                  "Evening",
                                  "Both"
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              const Text("Select Animal"),

                              DropdownButton<String>(
                                value: animalSelected,
                                isExpanded: true,
                                onChanged: (newValue) {
                                  setState(() {
                                    animalSelected = newValue??"";
                                  });
                                },
                                items: <String>[
                                  "Cow",
                                  "Buffalo"
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              ElevatedButton(
                                onPressed: isEnrolled ? null : enroll,
                                child: const Text("Enroll"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  void enroll() {
    FirebaseFirestore.instance
        .collection(key)
        .doc('milkSociety')
        .collection('district_ms')
        .doc(ms.id)
        .collection('Request')
        .doc(uid)
        .set({
      'status': 'pending',
      'shift': shiftSelected,
      'animal': animalSelected,
      'requestTime': DateTime.now(),
    });
    FirebaseFirestore.instance
        .collection(key)
        .doc('milkSociety')
        .collection('district_farmer')
        .doc(uid)
        .collection('Request')
        .doc(ms.id)
        .set({
      'status': 'pending',
      'shift': shiftSelected,
      'animal': animalSelected,
      'requestTime': DateTime.now(),
      "url": "",
    });
    Navigator.of(context).pop();
    //show toast
  }

  Future<bool> checkEnrollment() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    key = prefs.getString('key') ?? "";
    uid = prefs.getString('userId') ?? "";
    return FirebaseFirestore.instance
        .collection(key)
        .doc('milkSociety')
        .collection('district_farmer')
        .doc(uid)
        .collection('Request')
        .doc(ms.id)
        .get()
        .then((DocumentSnapshot ds) {
      return ds.exists;
    });
  }


  Widget makeInput(
      {label, keyboardtype, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardtype,
          decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey[400]!,
              ),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]!)),
          ),
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }

}
