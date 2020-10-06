import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Testing extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List text = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firestore.collection('plots').get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            snapshot.data.docs.forEach((element) => text.add(element.data()));
            text.forEach((element) {
              print(element.toString());
            });

            return Container(width: 10, height: 10, color: Colors.red,);
            // return new ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: text.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       return Card(
            //         child: Text(text[index]),
            //       );
            //     });
          }
          if( snapshot.connectionState == ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          else {
            return Container();
          }
    }
        );
  }
}
