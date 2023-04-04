// ignore_for_file: file_names, prefer_const_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmerapp/home/screens/ListMilkSocietiesScreen.dart';
import 'package:farmerapp/home/screens/ShowContracts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/screens/notifications.dart';
import '../register.dart';

class AppDrawer extends StatelessWidget {
  final String? cityVal;
  String user = "";

  AppDrawer({Key? key, required this.cityVal}) : super(key: key);

  checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId') ?? "";
    var user = userId.toString();
    return user;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   init();
  // }

  Future<void> init() async {
    user = (await checkUser())!;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("hey"),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
          ListTile(
              title: const Text('Milk Societies'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ListMSScreen(cityVal: cityVal)));
              }),
          ListTile(
            title: const Text('Update Profile Details'),
            onTap: () {},
          ),
          ListTile(
              title: const Text('Logout'),
              onTap: () async {
                SharedPreferences sh = await SharedPreferences.getInstance();
                sh.clear();
                FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .popUntil((route) => Navigator.of(context).canPop());
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Register()));
              }),
          ListTile(
            title: const Text('Contracts'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShowContracts(cityVal: cityVal)));
            },
          ),
          ListTile(
            title: const Text('Notifications'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => newContracts(
                        cityVal: cityVal ?? "",
                      )));
            },
          ),
        ],
      ),
    );
  }
}
