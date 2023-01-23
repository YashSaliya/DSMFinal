import 'package:farmerapp/home/DOS/fetchMilkSociety.dart';
import 'package:flutter/material.dart';

import '../../widgets/MilkSocietyCard.dart';

class ListMSScreen extends StatefulWidget{
  final String? cityVal;
  const ListMSScreen({Key? key, required this.cityVal}) : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListMSScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Milk Societies"),
      ),
      body: FutureBuilder(
        future: fetchMS(widget.cityVal).fetchList(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                return MilkSocietyCard( ms: snapshot.data[index]);
              },
            );
          }
          else if(snapshot.hasError){
            print(snapshot.error);
            return const Center(
              child: Text("Error"),
            );
            }
          else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          },
      )
    );
  }
}