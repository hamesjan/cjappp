import 'package:cjapp/pages/profile/new_place.dart';
import 'package:cjapp/widgets/plotserror.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/profile/display_reviews.dart';
import 'package:cjapp/pages/profile/display_favorites.dart';
import 'package:cjapp/pages/settings/select_setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'get_local_rank.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/widgets/custom_button.dart';
import 'package:cjapp/services/BaseAuth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future getInformation() async {
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
    return resUsers.data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getInformation(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                  child: Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blueAccent, Colors.white10]),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.blueAccent,
                        size: 125,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data['username'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 40),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Joined ${snapshot.data['joined']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Local Score',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        snapshot.data['local_score'].toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent,
                            fontSize: 60),
                      ),
                      getLocalRank(snapshot.data['username'],
                          snapshot.data['local_score']),
                      IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: SingleChildScrollView(child:Column(
                                    children: [
                                      Text(
                                        'Local Score',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                      ),
                                      Divider(thickness: 2,),
                                      Text('As you interact with plots, your local score will grow and along with will your title.\n'
                                          'Listed elow are the possible titles to earn'),
                                      Divider(thickness: 2,),
                                      Text('Rando', style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Colors.blue
                                      ),),
                                      Icon(Icons.arrow_downward_rounded),
                                      Text('Homie', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.green
                                      ),),
                                      Text('> 100'),
                                      Icon(Icons.arrow_downward_rounded),
                                      Text('G', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.red
                                      ),),
                                      Text('> 1,000'),
                                      Icon(Icons.arrow_downward_rounded),
                                      Text('Local', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.deepOrange
                                      ),),
                                      Text('> 10,000'),
                                      Icon(Icons.arrow_downward_rounded),
                                      Text('Certified OG', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Colors.purpleAccent
                                      ),),
                                      Text('> 100,000 and Homies'),
                                    ],
                                  ),
                                  ),
                                  actions: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                ),
                SelectIconSetting(
                  text: 'Bookmarks',
                  icon: Icon(Icons.bookmarks_outlined),
                  callback: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => DisplayFavorites(
                                  favorites: snapshot.data['favorites'],
                                )));
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SelectIconSetting(
                  text: 'Reviews',
                  icon: Icon(Icons.rate_review_outlined),
                  callback: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => DisplayReviews(
                                  reviews: snapshot.data['reviews'],
                                )));
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => NewPlace()));
                  },
                  child: new Ink(
                      child: Container(
                          color: Colors.white30,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(Icons.maps_ugc_sharp, color: Colors.pink,),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'Submit a Plot!',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                        fontSize: 22, color: Colors.pink),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Icon(Icons.arrow_right),
                                ],
                              ),
                            ],
                          ))),
                ),
              ]));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator()),
                  Expanded(
                    child: Container(),
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Center(
                child: Text(
                  'There are connectivity issues.\nPlease retry later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return PlotsError();
            }
          }),
    );
  }
}
