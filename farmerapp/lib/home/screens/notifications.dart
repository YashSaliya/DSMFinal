import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farmerapp/widgets/newContract.dart';

class newContracts extends StatefulWidget{
  final String cityVal;
  const newContracts({Key? key, required this.cityVal}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _newContractsState();
  }
}

class _newContractsState extends State<newContracts>{
  String uid = "";


  Future<void> precheck() async{
    SharedPreferences sh = await SharedPreferences.getInstance();
    uid = sh.getString('userId') ?? "";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Contracts"),
      ),
      body: FutureBuilder(
        future: precheck(),
        builder:(context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          else{
            return StreamBuilder(
                stream:FirebaseFirestore.instance.collection(widget.cityVal ?? "").doc('milkSociety')
                    .collection('district_farmer')
                    .doc(uid)
                    .collection('Request')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData){
                    return const Text("Loading...");
                  }
                  else{
                    List<DocumentSnapshot> ds = snapshot.data!.docs;
                    return ListView(
                        children: ds.map((DocumentSnapshot de){
                          return NewContract(ds:de);
                        }).toList()
                    );
                  }
                }

            );
          }
        }
      )
    );
  }
}