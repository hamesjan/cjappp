import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/feed/hotspot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/services/BaseAuth.dart';
import 'package:cjapp/widgets/plotserror.dart';
import 'package:flutter/widgets.dart';
import 'package:cjapp/services/app_colors.dart';
import 'package:location/location.dart';
import 'package:cjapp/pages/home.dart';
import 'package:cjapp/pages/map_page/distance_calculator.dart';



class Feed extends StatefulWidget {
  final String initSortBy;
  final String initPrice;
  final String initCategory;
  final double initRadius;
  final Function setInit;

  const Feed({Key key, this.initSortBy, this.initPrice, this.initCategory, this.initRadius, this.setInit}) : super(key: key);


  @override
  _FeedState createState() => _FeedState();
}



class _FeedState extends State<Feed> {
  final auth.FirebaseAuth _authFirebase = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  PermissionStatus _permissionGranted;
  bool _serviceEnabled;
  Location location = new Location();

  String sortBy = 'Newest';
  String price = 'Free';
  String category = 'No Preference';
  double radius = 40233.6;

  List plots = [];
  List receivedPlots = [];


  @override
  void initState() {
    super.initState();
    checkPermissions();
    setState(() {
      sortBy = widget.initSortBy;
      price = widget.initPrice;
      category = widget.initCategory;
      radius = widget.initRadius;
    });
  }

  checkPermissions() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }


  Future getInformation() async {
    List info = [];
    info.clear();
    String username;
    if (_authFirebase.currentUser == null) {
      username = 'testUser1';
    } else {
      var _auth = Auth();
      auth.User _user = await _auth.getCurrentUser();
      var allUsers = await _firestore.collection('users').get();
      allUsers.docs.forEach((element) {
        if (element.data()['uid'] == _user.uid) {
          username = element.data()['username'];
        }
      });
    }


    if (sortBy == 'Popular') {
      info.add(await _firestore
          .collection('plots')
          .orderBy('clicks', descending: true)
          .get());
    } else if (sortBy == 'Best Rated') {
      info.add(await _firestore
          .collection('plots')
          .orderBy('ratingsNumbers', descending: true)
          .get());
    } else if (sortBy == 'Newest') {
      info.add(await _firestore.collection('plots').orderBy('timestamp', descending: true).get());
    } else if (sortBy == 'Locals Only') {
      info.add(await _firestore.collection('plots').where('private', isEqualTo: true).get());
    }

    var resUsers = await _firestore.collection('users').doc(username).get();
    List currFavorites = resUsers.data()['favorites'];

    // Checking if homies with privteplot
    List currHomies = resUsers.data()['homies'];
    List homieIds = [];
    var listHomies = await _firestore.collection('users').get();
    var temp = listHomies.docs.where((element) => currHomies.contains(element.data()['username']));
    temp.forEach((element) {homieIds.add(element.data()['uid']);});

    info.add(currFavorites);
    info.add(resUsers.data()['zipCode']);
    if(_permissionGranted.toString() == 'PermissionStatus.granted'){
      LocationData _locationData = await location.getLocation();
      info.add(_locationData.latitude);
      info.add(_locationData.longitude);
    } else {
      info.add(34.0522);
      info.add(-118.2437);
    }
    info.add(homieIds);
    return info;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        child: FutureBuilder(
            future: getInformation(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                plots.clear();
                receivedPlots.clear();
                snapshot.data[0].docs
                    .forEach((element) => receivedPlots.add(element.data()));
                if (_permissionGranted.toString() == 'PermissionStatus.granted') {
                  receivedPlots.forEach((element) {
                    // if name in fav,
                    bool fav = false;
                    if (snapshot.data[1].contains(element['name'])) {
                      fav = true;
                    }
                    if (getDist(snapshot.data[3], snapshot.data[4],
                        element['lat'], element['long'], getMiles(radius))) {
                      if (element['approved']) {
                        if (element['private'] && !snapshot.data[5].contains(element['by'])) {
                        } else {
                        plots.add(HotSpot(
                          name: element['name'],
                          location: element['location'],
                          category: element['category'],
                          by: element['by'],
                          fav: fav,
                          private: element['private'],
                          burntRating: element['burntRating'],
                          byText: element['by_text'],
                          description: element['description'],
                          timestamp: element['timestamp'],
                          imgLink: element['imgLink'],
                          lat: element['lat'],
                          long: element['long'],
                          ratings: element['ratings'],
                          price: element['price'],
                          ratingsNumbers: element['ratingsNumbers'].toDouble(),
                          website: element['website'],
                          zipCode: element['zipCode'],
                        ));
                      }
                      }
                    }
                  });
                  plots.sort((a, b) => price.contains(a.price) ? 0 : 1);
                  if (category != 'No Preference') {
                    plots.sort((a, b) => category.contains(a.category) ? 0 : 1);
                  }
                }
                else {
                  receivedPlots.forEach((element) {
                    bool fav = false;
                    if (snapshot.data[1].contains(element['name'])) {
                      fav = true;
                    }
                      if (element['approved']  && element['zipCode'] == snapshot.data[2]) {
                        // Checking if plot is private
                        if (element['private'] && !snapshot.data[5].contains(element['by'])) {
                        } else {
                          plots.add(HotSpot(
                            name: element['name'],
                            location: element['location'],
                            category: element['category'],
                            by: element['by'],
                            fav: fav,
                            private: element['private'],
                            burntRating: element['burntRating'],
                            byText: element['by_text'],
                            description: element['description'],
                            timestamp: element['timestamp'],
                            imgLink: element['imgLink'],
                            lat: element['lat'],
                            long: element['long'],
                            ratings: element['ratings'],
                            price: element['price'],
                            ratingsNumbers: element['ratingsNumbers'].toDouble(),
                            website: element['website'],
                            zipCode: element['zipCode'],
                          ));
                        }
                      }
                  });
                  plots.sort((a, b) => price.contains(a.price) ? 0 : 1);
                  if (category != 'No Preference') {
                    plots.sort((a, b) => category.contains(a.category) ? 0 : 1);
                  }
                  plots.insert(0, Container(
                    child: Text(
                      'Enable location permissions to view plots outside your Zip Code.\n\nSettings -> Privacy -> Location Services -> Plots',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  )
                  );
                }
                plots.insert(
                    0,
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [MaterialColor(0xfff2a3f3, color), Colors.white10])),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Sort By',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      _authFirebase.currentUser == null ? DropdownButton<String>(
                                        value: sortBy,
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: Colors.black),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                        underline: Container(
                                          height: 2,
                                          color: MaterialColor(0xfff2a3f3, color),
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            sortBy = newValue;
                                          });
                                          widget.setInit(
                                              sortBy,
                                              price,
                                              category,
                                              radius
                                          );
                                        },
                                        items: <String>[
                                          'Newest',
                                          'Best Rated',
                                          'Popular',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value, style: TextStyle(
                                                fontWeight: FontWeight.normal
                                            ),),
                                          );
                                        }).toList(),
                                      ) :DropdownButton<String>(
                                        value: sortBy,
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: Colors.black),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                        underline: Container(
                                          height: 2,
                                          color: MaterialColor(0xfff2a3f3, color),
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            sortBy = newValue;
                                          });
                                          widget.setInit(
                                              sortBy,
                                              price,
                                              category,
                                              radius
                                          );
                                        },
                                        items: <String>[
                                          'Newest',
                                          'Best Rated',
                                          'Popular',
                                          'Locals Only'
                                        ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value, style: TextStyle(
                                                    fontWeight: FontWeight.normal
                                                ),),
                                              );
                                            }).toList(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Category',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      DropdownButton<String>(
                                        value: category,
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: Colors.black),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        underline: Container(
                                          height: 2,
                                          color: MaterialColor(0xfff2a3f3, color),
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            category = newValue;
                                          });
                                          widget.setInit(
                                              sortBy,
                                              price,
                                              category,
                                              radius
                                          );
                                        },
                                        items: <String>[
                                          'No Preference',
                                          'Outdoors',
                                          'Indoors',
                                          'Action',
                                          'Urban',
                                          'View'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value, style: TextStyle(
                                              fontWeight: FontWeight.normal
                                            ),),
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
                                      Text(
                                        'Price',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      DropdownButton<String>(
                                        value: price,
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: Colors.black),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(color: Colors.black),
                                        underline: Container(
                                          height: 2,
                                          color: MaterialColor(0xfff2a3f3, color),
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            price = newValue;
                                          });
                                          widget.setInit(
                                              sortBy,
                                              price,
                                              category,
                                              radius
                                          );
                                        },
                                        items: <String>[
                                          'Free',
                                          'Cheapest',
                                          'Moderate',
                                          'Expensive'
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value, style: TextStyle(
                                                fontWeight: FontWeight.normal
                                            ),),
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  ),
                                  
                                  _permissionGranted.toString() == 'PermissionStatus.granted' ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Radius',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      DropdownButton<double>(
                                        value: radius,
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: Colors.black),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        underline: Container(
                                          height: 2,
                                          color: MaterialColor(0xfff2a3f3, color),
                                        ),
                                        onChanged: (double newValue) {
                                          setState(() {
                                            radius = newValue;
                                          });
                                          widget.setInit(
                                              sortBy,
                                              price,
                                              category,
                                              radius
                                          );
                                        },
                                        items: <double>[
                                          16093.4,
                                          40233.6,
                                          80467.2,
                                          160934
                                        ].map<DropdownMenuItem<double>>(
                                            (double value) {
                                          return DropdownMenuItem<double>(
                                            value: value,
                                            child: Text(getMiles(value)
                                                .toStringAsFixed(0), style: TextStyle(
                                                fontWeight: FontWeight.normal
                                            ),),
                                          );
                                        }).toList(),
                                      ),
                                      Text(
                                        'mi',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ) :
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                          color: Colors.white
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                        'Enable Location\nto sort by radius.',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                      ),)
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          thickness: 3,
                          color: MaterialColor(0xfff2a3f3, color),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        plots.length == 0 && sortBy == "Locals Only" ? Container(
                          child: Text("Your homies have posted no plots.\nIt's going to be a boring day.")
                        ): Container()
                      ],
                    ));
                return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: plots.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: plots[index],
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                      );
                    });
                // Column(children: plots.map((item) => new Container(margin: EdgeInsets.only(bottom: 20),child: item)).toList());
              }
              else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Container(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator()));
              }
              else if (snapshot.connectionState == ConnectionState.none){
                return Center(
                  child: Text(
                    'There are connectivity issues.\nPlease retry later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                );
              }
              else {
                return PlotsError();
              }
            }));
  }
}
