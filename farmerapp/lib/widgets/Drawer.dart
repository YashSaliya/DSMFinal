// ignore_for_file: file_names, prefer_const_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmerapp/home/screens/ListMilkSocietiesScreen.dart';
import 'package:farmerapp/home/screens/ShowContracts.dart';
import 'package:farmerapp/home/screens/ProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/screens/TableChart.dart';
import '../home/screens/notifications.dart';
import '../register.dart';

class AppDrawer extends StatefulWidget {
  final String? cityVal;

  AppDrawer({Key? key, required this.cityVal}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String user = "";
  String? userId;
  String? username;

  checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    var user = userId.toString();
    return user;
  }

  Future<String> abc() async {
    DocumentSnapshot temp;
    temp = await FirebaseFirestore.instance
        .collection(widget.cityVal ?? "")
        .doc('milkSociety')
        .collection('district_farmer')
        .doc(userId)
        .get();
    print("hello" + temp['full_name'].toString());
    return temp['full_name'].toString();
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    user = (await checkUser())!;
  }

  Future<String> getUserName()  async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    return FirebaseFirestore.instance
        .collection(widget.cityVal ?? "")
        .doc('milkSociety')
        .collection('district_farmer')
        .doc(userId)
        .get()
        .then((value) {
          print(value.data());
          return value.data()!['full_name'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: FutureBuilder(
                future: getUserName(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return Text("Hello "+ snapshot.data);
                  } else {
                    return Text('Hello');
                  }
                }),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                  // child: Image.network(
                  //   'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                  //   fit: BoxFit.cover,
                  //   width: 90,
                  //   height: 90,
                  // ),
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
              leading: Icon(Icons.location_city),
              title: const Text('Milk Societies'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ListMSScreen(cityVal: widget.cityVal)));
              }),
          ListTile(
            leading: Icon(Icons.person),
            title: const Text('My Profile'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: const Text('Contracts'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ShowContracts(cityVal: widget.cityVal, id: userId!)));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications_active_rounded),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => newContracts(
                        cityVal: widget.cityVal ?? "",
                      )));
            },
          ),
          ListTile(
            leading: Icon(Icons.table_chart),
            title: const Text('Record View'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DataTableDemo(cityVal:widget.cityVal ,)));
            },
          ),
          ListTile(
              leading: Icon(Icons.logout),
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
        ],
      ),
    );
  }
}
