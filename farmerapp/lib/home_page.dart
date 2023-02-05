// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, unused_local_variable, avoid_print

import 'dart:io';
import 'package:farmerapp/locators/geolocatorfun.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/screens/Homescreen.dart';
import 'package:geolocator/geolocator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noofanimalsController = TextEditingController();
  final TextEditingController dairymilkoutputController =
      TextEditingController();

  String countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String address = "";

  final List<String> _typesofanimals = [
    'Cow',
    'Buffalo',
    'Sheep',
    'Goat'
  ]; // Option 2
  String? _selectedAnimal;

  XFile? image;

  final ImagePicker picker = ImagePicker();

  //we can upload image from camera or from gallery based on parameter
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
    print("reached here");
    print(image!.path);
  }

  // final File? imagefile = File(image!.path.toString());

  //show popup dialog
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        makeInput(
                          label: "Name",
                          controller: nameController,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: const Text(
                              "Location",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CSCPicker(
                          ///Enable disable state dropdown [OPTIONAL PARAMETER]
                          showStates: true,

                          /// Enable disable city drop down [OPTIONAL PARAMETER]
                          showCities: true,

                          ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                          flagState: CountryFlag.DISABLE,

                          ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                          dropdownDecoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1)),

                          ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                          disabledDropdownDecoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: Colors.grey.shade300,
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1)),

                          ///placeholders for dropdown search field
                          countrySearchPlaceholder: "Country",
                          stateSearchPlaceholder: "State",
                          citySearchPlaceholder: "City",

                          ///labels for dropdown
                          countryDropdownLabel: "*Country",
                          stateDropdownLabel: "*State",
                          cityDropdownLabel: "*City",

                          ///Default Country
                          //defaultCountry: DefaultCountry.India,

                          ///Disable country dropdown (Note: use it with default country)
                          //disableCountry: true,

                          ///selected item style [OPTIONAL PARAMETER]
                          selectedItemStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),

                          ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                          dropdownHeadingStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),

                          ///DropdownDialog Item style [OPTIONAL PARAMETER]
                          dropdownItemStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),

                          ///Dialog box radius [OPTIONAL PARAMETER]
                          dropdownDialogRadius: 10.0,

                          ///Search bar radius [OPTIONAL PARAMETER]
                          searchBarRadius: 10.0,

                          ///triggers once country selected in dropdown
                          onCountryChanged: (value) {
                            setState(() {
                              ///store value in country variable
                              countryValue = value;
                              print(countryValue);
                            });
                          },

                          ///triggers once state selected in dropdown
                          onStateChanged: (value) {
                            setState(() {
                              ///store value in state variable
                              stateValue = value;
                            });
                          },

                          ///triggers once city selected in dropdown
                          onCityChanged: (value) {
                            setState(() {
                              ///store value in city variable
                              cityValue = value;
                              address =
                                  "$cityValue, $stateValue, $countryValue";
                            });
                          },
                        ),

                        ///print newly selected country state and city in Text Widget
                        // TextButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       address =
                        //           "$cityValue, $stateValue, $countryValue";
                        //     });
                        //   },
                        //   child: const Text("Print Data"),
                        // ),
                        // Text(address),
                        const SizedBox(
                          height: 20,
                        ),
                        makeInput(
                          label: "No of animals",
                          keyboardtype: TextInputType.phone,
                          controller: noofanimalsController,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: const Text(
                              "Types of animals",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black87),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        DropdownButton(
                          isExpanded: true,
                          hint: const Text(
                              'Please choose a type of animal'), // Not necessary for Option 1
                          value: _selectedAnimal,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedAnimal = newValue as String?;
                            });
                          },
                          items: _typesofanimals.map((location) {
                            return DropdownMenuItem(
                              value: location,
                              child: Text(location),
                            );
                          }).toList(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        makeInput(
                          label: "Dairy milk output (in litres)",
                          keyboardtype: TextInputType.phone,
                          controller: dairymilkoutputController,
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      myAlert();
                    },
                    child: const Text('Upload Photo'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //if image not null show the image
                  //if image null show text
                  image != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(
                                image!.path,
                              ),
                              //to show image, you type like this.
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        )
                      : const Text(
                          "No Image Uploaded yet",
                          style: TextStyle(fontSize: 20),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () async {
                          try {
                            FirebaseStorage storage = FirebaseStorage.instance;
                            var now = DateTime.now();
                            var formatter = DateFormat('dd-MM-yyyy');
                            String formattedTime =
                                DateFormat('kk:mm:a').format(now);
                            String formattedDate = formatter.format(now);
                            Reference ref = storage
                                .ref()
                                .child("image $formattedDate $formattedTime");
                            UploadTask uploadTask =
                                ref.putFile(File(image!.path));
                            uploadTask.then((res) async {
                              print('File Uploaded');
                              CollectionReference users = FirebaseFirestore
                                  .instance
                                  .collection('farmers');
                              // Call the user's CollectionReference to add a new user
                              var imageurl = await res.ref.getDownloadURL();
                              SharedPreferences.getInstance().then((instance) {
                                String userId =
                                    instance.get('userId').toString();
                                determinePosition().then((Position pos) async {
                                  await FirebaseFirestore.instance
                                      .collection('Cluster_key')
                                      .doc(userId)
                                      .set({'key': cityValue!});
                                  FirebaseFirestore.instance
                                      .collection(cityValue!)
                                      .doc('milkSociety')
                                      .collection('district_farmer')
                                      .doc(userId)
                                      .set({
                                    'latitude': pos.latitude,
                                    'longitude': pos.longitude,
                                    'full_name': nameController.text,
                                    'address': address,
                                    'no_of_animals': noofanimalsController.text,
                                    'types_of_animals': _selectedAnimal,
                                    'dairy_milk_output':
                                        dairymilkoutputController.text,
                                    'image_url': imageurl,
                                  }).then((val) {
                                    final String? cityName = cityValue;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Homepage(
                                            cityVal: cityName!.toString()),
                                      ),
                                    );
                                  });
                                });
                              });
                            });
                          } catch (e) {
                            print('Error adding user');
                          }
                        },
                        color: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
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

class DatabaseService {
  Future<String?> addUser({
    required String fullName,
    required String age,
    required String email,
  }) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      // Call the user's CollectionReference to add a new user
      await users.doc(email).set({
        'full_name': fullName,
        'age': age,
      });
      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }

  Future<String?> getUser(String email) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final snapshot = await users.doc(email).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['full_name'];
    } catch (e) {
      return 'Error fetching user';
    }
  }
}
