import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmerapp/home_page.dart';
import 'package:farmerapp/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import shared pref
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmerapp/Routers/router.dart';
import 'home/screens/Homescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sh = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  var user = null;
  var registeredDetails = null;
  MyApp({Key? key}) : super(key: key);

  Future<Map<String,String>> checkUser() async {
    Map<String,String> res = {};
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId') == null ? "": prefs.getString('userId');
    user = userId.toString();
    String key = await checkUserDetails();
    res['user'] = userId.toString();
    res['key'] = key;
    return res;
  }

  Future<String> checkUserDetails() async{
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('Cluster_key').doc(user).get();
    return ds.exists ? ds.get('key') : '';
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String,String> mp = snapshot.data as Map<String,String>;
          if(mp['key'] != '' && mp['user'] != ''){
            return MaterialApp(
              title: 'Farmer App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: Homepage(cityVal: mp['key']),
            );
          }
          else if(mp['key'] == '' && mp['user'] != ''){
            return MaterialApp(
              title: 'Farmer App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const MyHomePage(),
            );
          }
          else{
            return MaterialApp(
              title: 'Farmer App',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: const Register(),
            );
          }
        }
        else {
          return MaterialApp(
            title: 'Farmer App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home:const Register(),
          );
        }
      }

    );
  }
}

