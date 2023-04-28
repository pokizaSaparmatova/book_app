import 'package:book_app/firebase/my_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Item extends StatelessWidget {
 final Function()? onTab;
  const Item({Key? key, this.onTab}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(20),
     ),
      child:Column(
        children: [
         // Image.network()
        ],
      )
      //Text(imageUrl)
    );
  }
}
