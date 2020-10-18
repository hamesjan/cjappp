import 'package:cjapp/pages/profile/new_place.dart';
import 'package:cjapp/widgets/plotserror.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/profile/display_reviews.dart';
import 'package:cjapp/pages/profile/display_favorites.dart';
import 'package:cjapp/pages/settings/select_setting.dart';
import  'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/widgets/custom_button.dart';
import 'package:cjapp/services/BaseAuth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future getInformation () async {
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
      body:
        FutureBuilder(
            future: getInformation(),
            builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                      return SingleChildScrollView(child: Column(
                          children: <Widget>[
                            Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.blueAccent,
                                  Colors.white10
                                ]
                            ),

                          ),
                          child: Row(
                            children: [
                              Icon(Icons.person, color: Colors.blueAccent, size: 100,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data['username'], style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40
                                  ),),
                                  SizedBox(height: 10,),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlueAccent,
                                        borderRadius: BorderRadius.all(Radius.circular(25))
                                    ),
                                    child:Text('Joined ${snapshot.data['joined']}',textAlign: TextAlign.center, style: TextStyle(
                                        fontSize: 15
                                    ),),
                                  ),

                                ],
                              )
                            ],
                          ),
                        ),
                            Divider(thickness: 2,),
                            SelectIconSetting(
                              text: 'Bookmarks',
                              icon: Icon(Icons.bookmarks_outlined),
                              callback: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => DisplayFavorites(favorites: snapshot.data['favorites'],)
                                    )
                                );
                              },
                            ),
                            SizedBox(height: 10,),
                            SelectIconSetting(
                              text: 'Reviews',
                              icon: Icon(Icons.rate_review_outlined),
                              callback: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) => DisplayReviews(reviews: snapshot.data['reviews'],)
                                    )
                                );
                              },
                            ),
                            SizedBox(height: 10,),
                            SelectIconSetting(
                              text: 'Submit a Plot!',
                              icon: Icon(Icons.maps_ugc_sharp),
                              callback: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (BuildContext context) => NewPlace())
                                );
                              },
                            )
                          ]
                      )
              );
                  }
                  if( snapshot.connectionState == ConnectionState.waiting){
                    return Column(
                      children: [
                        Expanded(child: Container(),),
                        Container(width: 200, height:200,child: CircularProgressIndicator()),
                        Expanded(child: Container(),),
                      ],
                    );
                  }
                  else {
                    return PlotsError();
                  }
                }
            ),
    );
  }
}
