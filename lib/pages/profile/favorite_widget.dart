import 'package:cjapp/pages/feed/chosen_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteWidget extends StatelessWidget {
  final String name;
  FavoriteWidget({this.name,});


  Future getInformation () async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    var fav = await _firestore.collection('plots').where('name', isEqualTo: name).get();
    List test = [];
    fav.docs.forEach((element) {test.add(element.data()); });
    return test[0];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var info = await getInformation();
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(
          builder: (BuildContext context) => ChosenEvent(
            name: info['name'],
            zipCode: info['zipCode'],
            location: info['location'],
            ratingsNumbers: info['ratingsNumbers'],
            ratings: info['ratings'],
            website: info['website'],
            category: info['category'],
            by: info['by'],
            price: info['price'],
          )
        ));
      },
      child: new Ink(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Text(
              name,
              style: TextStyle(fontSize: 20),
            ),
            Expanded(child: Container(),),
            Icon(Icons.arrow_right)
          ],
        ),
      ),
    );
  }
}
