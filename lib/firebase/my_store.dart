import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class MyStore {
  final _store = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance.ref();
  late DownloadTask snap;


  Stream<QuerySnapshot> get getAll {
    return _store.collection("books").snapshots();
  }

  Future<File> downloadBook(String url, Function(int count, int total) progress) async {
    final fileName = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final refPDF = _storage.child(url);
    var file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await refPDF.getData() as List<int>);

    snap = refPDF.writeToFile(file);
    await Future.delayed(const Duration(microseconds: 200));
    final snapshot = snap.snapshotEvents;

    print("path: ${dir.path}/$fileName");
    snapshot.listen((event) {
      switch (event.state) {
        case TaskState.success:
            Text("success");
          break;
        case TaskState.paused:
          print("paused");
          break;
        case TaskState.running:
          print("running");
          Text("${event.totalBytes} / ${event.bytesTransferred}");
          print("${event.bytesTransferred / (event.totalBytes / 100)} % ");
          break;
        case TaskState.canceled:
          print("canceled");
          break;
        case TaskState.error:
          print("error");
          break;
      }
    });
    return file;
  }

}

