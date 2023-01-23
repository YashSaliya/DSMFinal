// import
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/screens/Homescreen.dart';
import 'home_page.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const RegisterPage(title: 'Enter Your Details'),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Map<String, String> _countryCodes = {
    'India': '+91',
    'USA': '+1',
    'UK': '+44',
    'Canada': '+1',
    'Australia': '+61',
    'New Zealand': '+64',
    'Singapore': '+65',
    'Malaysia': '+60',
    'China': '+86',
    'Japan': '+81',
    'South Korea': '+82',
    'Russia': '+7',
    'Germany': '+49',
    'France': '+33',
    'Italy': '+39',
    'Spain': '+34',
    'Netherlands': '+31',
    'Belgium': '+32',
    'Switzerland': '+41',
    'Austria': '+43',
    'Sweden': '+46',
    'Norway': '+47',
    'Denmark': '+45',
    'Finland': '+358',
    'Iceland': '+354',
    'Greece': '+30',
    'Portugal': '+351',
    'Ireland': '+353',
    'Poland': '+48',
    'Czech Republic': '+420',
    'Romania': '+40',
    'Hungary': '+36',
    'Bulgaria': '+359',
    'Turkey': '+90',
    'Ukraine': '+380',
    'Belarus': '+375',
    'Moldova': '+373',
    'Armenia': '+374',
    'Georgia': '+995',
    'Azerbaijan': '+994',
    'Kazakhstan': '+7',
    'Kyrgyzstan': '+996',
    'Tajikistan': '+992',
    'Turkmenistan': '+993',
    'Uzbekistan': '+998',
    'Bangladesh': '+880',
    'Bhutan': '+975',
    'Nepal': '+977',
    'Sri Lanka': '+94',
    'Pakistan': '+92',
    'Afghanistan': '+93',
    'Iran': '+98',
    'Iraq': '+964',
    'Saudi Arabia': '+966',
    'Yemen': '+967',
    'Oman': '+968',
  };
  String? _bydefaultCountry;
  String _mobileNumber = "";
  final _codecontroller = TextEditingController();
  String? _correspondingCode;

  @override
  void initState() {
    _codecontroller.text = "";
    _bydefaultCountry = 'India';
    _correspondingCode = _countryCodes[_bydefaultCountry];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.only(left: 25, right: 25),
            alignment: Alignment.center,
            //Input field with phone number
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/img1.png',
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "Phone Verification",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "We need to register your phone without getting started!",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                              width: 100,
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration.collapsed(
                                    hintText: ""),
                                isExpanded: true,
                                value: _bydefaultCountry,
                                items: _countryCodes.keys
                                    .map((label) => DropdownMenuItem(
                                          child: Text(
                                            label +
                                                " (" +
                                                _countryCodes[label]
                                                    .toString() +
                                                ")",
                                            style: const TextStyle(
                                                fontSize: 13.00),
                                          ),
                                          value: label,
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _bydefaultCountry = value as String?;
                                    _correspondingCode =
                                        _countryCodes[_bydefaultCountry];
                                  });
                                },
                              )),
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 33, color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: TextField(
                            controller: _codecontroller,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone",
                            ),
                          ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // TextField(
                    //   decoration: const InputDecoration(
                    //     hintText: 'Enter Phone Number',
                    //   ),
                    //   onChanged: (String val) {
                    //     setState(() {
                    //       _mobileNumber = val;
                    //     });
                    //   },
                    // ),
                    ElevatedButton(
                      child: const Text('Send OTP'),
                      onPressed: () => {
                        //Send OTP
                        _mobileNumber = _correspondingCode! +
                            _codecontroller.text.toString(),
                        _codecontroller.text = "",
                        FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: _mobileNumber,
                            verificationCompleted:
                                (PhoneAuthCredential credential) async {
                              FirebaseAuth.instance
                                  .signInWithCredential(credential)
                                  .then((UserCredential us) {});
                            },
                            verificationFailed: (FirebaseAuthException e) {
                              if (e.code == 'invalid-phone-number') {
                                print(
                                    'The provided phone number is not valid.');
                              }
                            },
                            codeSent: (String verificationId,
                                int? resendToken) async {
                              String smsCode = 'xxxx';
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Material(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/img1.png',
                                              width: 150,
                                              height: 150,
                                            ),
                                            const SizedBox(
                                              height: 25,
                                            ),
                                            const Text(
                                              "Phone Verification",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              "Please Enter OTP sent to the Phone Number",
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Pinput(
                                              length: 6,
                                              showCursor: true,
                                              onCompleted: (pin) {
                                                smsCode = pin;
                                              },
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            TextButton(
                                              child: const Text('Submit'),
                                              onPressed: () {
                                                PhoneAuthCredential credential =
                                                    PhoneAuthProvider
                                                        .credential(
                                                            verificationId:
                                                                verificationId,
                                                            smsCode: smsCode);
                                                FirebaseAuth.instance
                                                    .signInWithCredential(
                                                        credential)
                                                    .then(
                                                        (UserCredential value) {
                                                  SharedPreferences
                                                          .getInstance()
                                                      .then((pref) {
                                                    pref.setString(
                                                        "userId", value.user!.uid.toString());
                                                  });
                                                  print(value);
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              const MyHomePage()));
                                                });
                                              },
                                            )
                                          ]),
                                    );
                                  });
                            },
                            codeAutoRetrievalTimeout: (verificationId) => {})
                      },
                    )
                  ]),
            )));
  }
}
