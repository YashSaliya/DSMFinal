// ignore_for_file: file_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:farmerapp/home/screens/documentview.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ContractCard extends StatelessWidget {
  final DocumentSnapshot ds;
  const ContractCard({Key? key, required this.ds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text("Text(ds.get('name'))"),
        subtitle: ElevatedButton(
          child: const Text("View"),
          onPressed: () async {
            String url = ds.get('url');
            var uri = Uri.parse(url);
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            // final file = await loadPdfFromNetwork(url);
            // openPdf(context, file, url);
          },
        ),
      ),
    );
  }

  Future<File> loadPdfFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return _storeFile(url, bytes);
  }

  Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    if (kDebugMode) {
      print('$file');
    }
    return file;
  }

  //final file = File('example.pdf');
  //await file.writeAsBytes(await pdf.save());

  void openPdf(BuildContext context, File file, String url) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DocumentViewer(
            file: file,
            url: url,
          ),
        ),
      );
}
