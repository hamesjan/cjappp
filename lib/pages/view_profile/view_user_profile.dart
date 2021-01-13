import 'package:cjapp/pages/profile/display_reviews.dart';
import 'package:cjapp/pages/view_profile/view_user_plots.dart';
import 'package:cjapp/services/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/widgets/plotserror.dart';

import 'package:cjapp/services/app_colors.dart';
import 'package:cjapp/pages/settings/select_setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/pages/profile/get_local_rank.dart';
import 'package:cjapp/pages/feed/all_reviews.dart';

class ViewProfile extends StatefulWidget {
  final String username;
  final String homieStatus;

  const ViewProfile({Key key, this.username, this.homieStatus}) : super(key: key);
  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
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
    var oG = await _firestore.collection('appInfo').doc('certifiedOGs').get();
    if(oG.data().containsKey(widget.username)){
      oGStatus = true;
    }

    var resUsers = await _firestore.collection('users').doc(widget.username).get();
    info.add(resUsers.data());
    info.add(oGStatus);
    return info;
  }

  @override
  Widget build(BuildContext context) {
    final auth.FirebaseAuth _authFirebase = auth.FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
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
                            colors: [MaterialColor(0xfff2a3f3, color), Colors.white10]),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.pinkAccent,
                            size: 125,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  snapshot.data[0]['username'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Joined ${snapshot.data[0]['joined']}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 15),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              widget.homieStatus == 'no' ?
                                IconButton(
                                    icon: Icon(Icons.add_link,
                                    size: 30,
                                    color: Colors.green,),
                                    padding: EdgeInsets.all(0),
                                    onPressed: (){
                                      _authFirebase.currentUser == null ?
                                            showDialog(context: context,
                                                barrierDismissible: true,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('You must log in to link with ${widget.username}.'),
                                                    actions: <Widget>[
                                                      IconButton(
                                                        icon: Icon(Icons.close),
                                                        onPressed: (){
                                                          Navigator.pop(context);
                                                        },
                                                      )
                                                    ],
                                                  );
                                                }
                                            )
                                         :
                                      showDialog(
                                          context: context,
                                          barrierDismissible: true,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Send ${widget.username} a link request?'),
                                              actions: <Widget>[
                                                IconButton(
                                                  icon: Icon(Icons.add_link, color: Colors.green, size: 30,
                                                  ),
                                                  onPressed: ()async{
                                                    String myUsername = await returnUsername();
                                                    var resUsers = await _firestore.collection('users').doc(widget.username).get();
                                                    List currRequests = resUsers.data()['link_requests'];
                                                    currRequests.add(myUsername);
                                                    await _firestore.collection('users').doc(widget.username).update({
                                                      'link_requests': currRequests,
                                                    }).catchError((onError) => {print(onError.toString())});
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.close),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    }
                                ) : widget.homieStatus == 'pending' ? Container(
                                child: Text('Request Pending', style: TextStyle(color: Colors.blue),)  )
                                    : Container(
                                child: Row(
                                  children: [
                                    Text('Homie', style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.blue
                                    ),),
                                    IconButton(
                                      icon: Icon(Icons.link_off, color: Colors.red, size: 20,),
                                      onPressed: (){
                                        showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Remove ${widget.username}?'),
                                                actions: <Widget>[
                                                  IconButton(
                                                    icon: Icon(Icons.link_off, color: Colors.red, size: 20,
                                                    ),
                                                    onPressed: ()async{
                                                      String myUsername = await returnUsername();
                                                      var resUsers = await _firestore.collection('users').doc(widget.username).get();
                                                      var resUsers1 = await _firestore.collection('users').doc(myUsername).get();
                                                      List currRequests = resUsers.data()['homies'];
                                                      List myHomies = resUsers1.data()['homies'];
                                                      myHomies.remove(widget.username);
                                                      currRequests.remove(myUsername);
                                                      await _firestore.collection('users').doc(widget.username).update({
                                                        'homies': currRequests,
                                                      }).catchError((onError) => {print(onError.toString())});
                                                      await _firestore.collection('users').doc(myUsername).update({
                                                        'homies': myHomies,
                                                      }).catchError((onError) => {print(onError.toString())});
                                                      Navigator.pop(context);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.close),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                    }
                                    )
                                  ],
                                )
                              )

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
                      text: "Plots",
                      icon: Icon(Icons.place),
                      callback: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => UserPlots(
                                  plots: snapshot.data[0]['plots'],
                                  username: widget.username,
                                )
                            ));
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SelectIconSetting(
                      text: "Reviews",
                      icon: Icon(Icons.rate_review_outlined),
                      callback: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => DisplayReviews(
                                  reviews: snapshot.data[0]['reviews'],
                                  myReview: false,
                                )));
                      },
                    ),
                    SizedBox(
                      height: 15,
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
