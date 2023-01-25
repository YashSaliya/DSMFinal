import 'package:farmerapp/home/screens/ListMilkSocietiesScreen.dart';
import 'package:farmerapp/home/screens/ShowContracts.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget{
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
              Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new ListMSScreen(cityVal: cityVal)));
              }
          ),
          ListTile(
            title: const Text('Update Profile Details'),
            onTap: () {
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap:(){}
          ),
          ListTile(
            title: const Text('Contracts'),
            onTap: (){
              Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new ShowContracts(cityVal: cityVal)));
            },
          )

        ],
      ),
    );
  }
}