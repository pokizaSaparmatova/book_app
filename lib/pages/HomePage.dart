import 'dart:io';
import 'package:book_app/firebase/my_store.dart';
import 'package:book_app/pages/pdf_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../di/di.dart';


class BookHomePage extends StatefulWidget {
  const BookHomePage({Key? key}) : super(key: key);

  @override
  State<BookHomePage> createState() => _BookHomePageState();
}

class _BookHomePageState extends State<BookHomePage> {
  final _store = MyStore();
  final _storage = FirebaseStorage.instance.ref();
  late UploadTask _uploadTask;
  bool state=false;

  @override
  void initState() {
    super.initState();
  }

  Future<File> download(String url) async {
    return await _store.downloadBook(url, (i, total) {

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("BookApp")),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: di.get<MyStore>().getAll,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final list = snapshot.data?.docs ?? [];
              // final snap=snapshot.data!;

              return ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, i) =>
                    const Padding(padding: EdgeInsets.all(16)),
                itemBuilder: (context, index) {
                  final url = list[index].get("url");
                 return GestureDetector(
                    onTap: () {
                      print("$state");
                      // StreamBuilder<TaskSnapshot>(
                      //   stream: _uploadTask.snapshotEvents,
                      //   builder: (context,snapshot){
                      //     if(snapshot.hasData){
                      //       TaskSnapshot taskSnapshot=snapshot.data!;
                      //       double progress = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
                      //       int percentage = (progress * 100).toInt();
                      //       print(" percentage:   $percentage%");
                      //       return Text('Uploading: $percentage%');
                      //     }
                      //     else if(snapshot.hasError){
                      //       return const Text("Error");
                      //     }
                      //     else{
                      //       return const Text('Paused');
                      //     }
                      //   },
                      // );

                      download(url).then((value) => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PdfViwerPage(path: value.path)))
                          });
                    },
                    child: Card(
                        elevation: 4,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  list[index].get("image"),
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.fill,
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(list[index].get("title")),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(list[index].get("author")),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        )
                        //Text(imageUrl)
                        ),
                  );
                },
              );
              return Center(
                child: Text(
                  "${snapshot.data?.docs[0].data()}",
                  style: const TextStyle(fontSize: 32),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
