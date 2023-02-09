// ignore_for_file: file_names

import 'package:farmerapp/home/screens/ListMilkSocietiesScreen.dart';
import 'package:farmerapp/home/screens/ShowContracts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/screens/notifications.dart';
import '../register.dart';

class AppDrawer extends StatelessWidget {
  final String? cityVal;
  const AppDrawer({Key? key, required this.cityVal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => newContracts(cityVal: cityVal?? "",)));
            },
          ),
        ],
      ),
    );
  }
}
