import 'package:cjapp/pages/profile/new_place.dart';
import 'package:cjapp/widgets/plotserror.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/profile/display_reviews.dart';
import 'package:cjapp/pages/profile/display_favorites.dart';
import 'package:cjapp/pages/settings/select_setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'get_local_rank.dart';
import 'package:cjapp/services/global_functions.dart';
import 'package:device_info/device_info.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String lastDT;

  // Future<String> _getId() async {
  //   var deviceInfo = DeviceInfoPlugin();
  //     var iosDeviceInfo = await deviceInfo.iosInfo;
  //     return iosDeviceInfo.identifierForVendor; // unique ID on iOS
  //
  // }

  Future getInformation() async {
    List info = [];
    bool oGStatus = false;
    String username = await returnUsername();
    var oG = await _firestore.collection('appInfo').doc('certifiedOGs').get();
    if(oG.data().containsKey(username)){
        oGStatus = true;
    }

    var resUsers = await _firestore.collection('users').doc(username).get();
    info.add(resUsers.data());
    info.add(oGStatus);
    return info;
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
                            snapshot.data[0]['username'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 40),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Joined ${snapshot.data[0]['joined']}',
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
                        snapshot.data[0]['local_score'].toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent,
                            fontSize: 60),
                      ),
                      getLocalRank(snapshot.data[0]['username'],
                          snapshot.data[0]['local_score'], snapshot.data[1]),
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
                                      Text('As you interact with plots, your local score will grow and along with will your title.'),
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
                                  favorites: snapshot.data[0]['favorites'],
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
                                  reviews: snapshot.data[0]['reviews'],
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
                              // FlatButton(
                              //   child: Text(';hae'),
                              //   onPressed: () async {
                              //   },
                              // )
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
