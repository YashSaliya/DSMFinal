import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NewContract extends StatelessWidget{
  final DocumentSnapshot ds;
  NewContract({Key? key, required this.ds}) : super(key: key);
  String name_ms = "";

  bool check(){
    return ds['url'] == "" ?  false : true;
  }


  Future<void> msDetails() async{
    final SharedPreferences sh = await SharedPreferences.getInstance();
    sh.getString('key');
    DocumentSnapshot msDocument = await FirebaseFirestore.instance.collection(sh.getString('key')?? "").doc('milkSociety').collection('district_ms').doc(ds.get('msid')).get();
    name_ms = msDocument['name'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: msDetails(),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }
        else{
          return Card(
            child: ListTile(
              title: Text(name_ms),
              subtitle: otherParts1(context),
            ),
          );
        }
      },
    );
  }


  Widget otherParts1(BuildContext context){

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:ds['pin'] != null ? [
        Text(
          "Pin: ${ds['pin']}",
          style: Theme.of(context).textTheme.bodyText2 //bodyText2
        ),
        ElevatedButton(
          child: const Text("View"),
          onPressed: () async {
            if(check() == false){return null;}
            String url = ds['url'];
            print(url);
            var uri = Uri.parse(url);
            await launchUrl(uri,mode: LaunchMode.externalApplication);

          },
        ),
        ElevatedButton(
          child: const Text("r"),
          onPressed: () async {
            final SharedPreferences sh = await SharedPreferences.getInstance();
            String userId = sh.getString('user') ?? "";
            await FirebaseFirestore.instance.collection(sh.getString('key')?? "").doc('milkSociety').collection('district_farmer').doc(userId).collection('Request').doc(ds.id).delete();
            await FirebaseFirestore.instance.collection(sh.getString('key')?? "").doc('milkSociety').collection('district_ms').doc(ds.get('msid')).collection('Request').doc(userId).delete();
          },
        ),

      ] : [
        ElevatedButton(
        child: const Text("Cancel"),
        onPressed: () async {
          final SharedPreferences sh = await SharedPreferences.getInstance();
          String userId = sh.getString('user') ?? "";
          await FirebaseFirestore.instance.collection(sh.getString('key')?? "").doc('milkSociety').collection('district_farmer').doc(userId).collection('Request').doc(ds.id).delete();
          await FirebaseFirestore.instance.collection(sh.getString('key')?? "").doc('milkSociety').collection('district_ms').doc(ds.get('msid')).collection('Request').doc(userId).delete();
        },
      ),]
    );
  }
}