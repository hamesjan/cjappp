import 'package:cjapp/pages/feed/chosen_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/services/BaseAuth.dart';

class FavoriteWidget extends StatelessWidget {
  final String name;
  FavoriteWidget({this.name,});


  Future getInformation () async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    var fav = await _firestore.collection('plots').where('name', isEqualTo: name).get();
    List test = [];
    fav.docs.forEach((element) {test.add(element.data()); });

    // Getting Favorites
    var _auth = Auth();
    String username;
    auth.User _user = await _auth.getCurrentUser();
    var allUsers = await _firestore.collection('users').get();
    allUsers.docs.forEach((element) {
      if (element.data()['uid'] == _user.uid) {
        username = element.data()['username'];
      }
    });
    var resUsers = await _firestore.collection('users').doc(username).get();
    List currFavorites = resUsers.data()['favorites'];
    bool favorite = false;
    if(currFavorites.contains(test[0]['name'])){
      favorite = true;
    }

    return [favorite, test[0]];
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
            name: info[1]['name'],
            zipCode: info[1]['zipCode'],
            lat: info[1]['lat'],
            fav: info[0],
            fromFeed: false,
            burntRating: info[1]['burntRating'],
            byText: info[1]['by_text'],
            description: info[1]['description'],
            long: info[1]['long'],
            location: info[1]['location'],
            imgLink: info[1]['imgLink'],
            ratingsNumbers: info[1]['ratingsNumbers'].toDouble(),
            ratings: info[1]['ratings'],
            website: info[1]['website'],
            category: info[1]['category'],
            by: info[1]['by'],
            price: info[1]['price'],
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
