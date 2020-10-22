import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/feed/hotspot.dart';
import  'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/services/BaseAuth.dart';
import 'package:cjapp/widgets/plotserror.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String sortBy = 'Popular';
  String price = 'Moderate';
  String category = 'No Preference';
  String radius = '10 miles';
  List plots = [];
  List receivedPlots = [];

  Future getInformation () async {
    List info = [];
    info.clear();
    var _auth = Auth();
    String username;
    auth.User _user = await _auth.getCurrentUser();
    var allUsers = await _firestore.collection('users').get();
    allUsers.docs.forEach((element) {
      if (element.data()['uid'] == _user.uid) {
        username = element.data()['username'];
      }
    });
    if (sortBy == 'Popular'){
      info.add(await _firestore.collection('plots').orderBy('clicks', descending: true).get());
    } else if (sortBy == 'Best Rated') {
      info.add(await _firestore.collection('plots').orderBy('ratingsNumbers', descending: true).get());
    } else if (sortBy == 'Newest'){
      info.add(await _firestore.collection('plots').get());
    } else if (sortBy == 'Rising'){
      info.add(await _firestore.collection('plots').get());
    }
    var resUsers = await _firestore.collection('users').doc(username).get();
    List currFavorites = resUsers.data()['favorites'];
    info.add(currFavorites);
    return info;
  }

  @override
  Widget build(BuildContext context) {
    return
    Container(
      padding: EdgeInsets.all(16),
            child: FutureBuilder(
                future: getInformation(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    plots.clear();
                    receivedPlots.clear();

                    snapshot.data[0].docs.forEach((element) => receivedPlots.add(element.data()));
                    receivedPlots.forEach((element) {
                      // if name in fav,
                      bool fav = false;
                      if(snapshot.data[1].contains(element['name'])){
                        fav = true;
                      }
                      if (element['approved']){
                        plots.add(HotSpot(
                          name: element['name'],
                          location: element['location'],
                          category: element['category'],
                          by: element['by'],
                          fav: fav,
                          lat: element['lat'],
                          long: element['long'],
                          ratings: element['ratings'],
                          price: element['price'],
                          ratingsNumbers: element['ratingsNumbers'].toDouble(),
                          website: element['website'],
                          zipCode: element['zipCode'],
                        ));
                      }
                    });
                    plots.sort((a, b) => price.contains(a.price) ? 0 : 1);
                    if (category != 'No Preference') {

                      plots.sort((a, b) => category.contains(a.category) ? 0 : 1);

                    }
                    plots.insert(0,
                        Column(children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.pinkAccent,
                                      Colors.white10
                                    ]
                                )
                            ),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text('Sort By', style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                        ),),
                                        SizedBox(width: 10,),
                                        DropdownButton<String>(
                                          value: sortBy,
                                          icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.black,
                                            fontSize: 15,
                                          ),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.pinkAccent,
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              sortBy = newValue;
                                            });
                                          },
                                          items: <String>['Popular', 'Best Rated', 'Newest', 'Rising']
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),

                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Category', style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15
                                        ),),
                                        SizedBox(width: 10,),
                                        DropdownButton<String> (
                                          value: category,
                                          icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.black,
                                          ),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.pinkAccent,
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              category = newValue;
                                            });
                                          },
                                          items: <String>['No Preference', 'Outdoors', 'Indoors', 'Action', 'Urban', 'View']
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    )

                                  ],
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('Price', style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),),
                                        SizedBox(width: 10,),
                                        DropdownButton<String>(
                                          value: price,
                                          icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.black),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.pinkAccent,
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              price = newValue;
                                            });
                                          },
                                          items: <String>['Free', 'Cheapest', 'Moderate', 'Expensive']
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Radius', style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        )
                                          ,),
                                        SizedBox(width: 10,),
                                        DropdownButton<String>(
                                          value: radius,
                                          icon: Icon(Icons.arrow_drop_down, color: Colors.black,),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: TextStyle(color: Colors.black),
                                          underline: Container(
                                            height: 2,
                                            color: Colors.pinkAccent,
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              radius = newValue;
                                            });
                                          },
                                          items: <String>['5 miles', '10 miles', '50 miles', '100 miles']
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Divider(
                            thickness: 3,
                            color: Colors.pinkAccent,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],)
                    );
                    return new
                        ListView.builder(
                        shrinkWrap: true,
                        itemCount: plots.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: plots[index],
                            padding: EdgeInsets.only(
                                top: 10,
                                bottom: 10
                            ),
                          );
                        });
                    // Column(children: plots.map((item) => new Container(margin: EdgeInsets.only(bottom: 20),child: item)).toList());
                  }
                  if( snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: Container(width: 200, height:200,child: CircularProgressIndicator()));
                  }
                  else {
                    return PlotsError();
                  }
                }
            )
    );
  }
}
