//import
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
    );
  }
}
