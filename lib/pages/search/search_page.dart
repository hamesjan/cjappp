import 'package:cjapp/services/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/pages/feed/chosen_event.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:cjapp/widgets/plotserror.dart';
import 'package:cjapp/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/services/BaseAuth.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List receivedPlots = [];
  List plotsNames = [];
  List trending = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _authFirebase = auth.FirebaseAuth.instance;


  Future getInformation() async {
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

    List info = [];
    info.add(await _firestore.collection('plots').orderBy('clicks', descending: true).get());

    var resUsers = await _firestore.collection('users').doc(username).get();
    // Checking if homies with privteplot
    List currHomies = resUsers.data()['homies'];
    List homieIds = [];
    var listHomies = await _firestore.collection('users').get();
    var temp = listHomies.docs.where((element) => currHomies.contains(element.data()['username']));
    temp.forEach((element) {homieIds.add(element.data()['uid']);});


    info.add(homieIds);
    return info;

  }

    @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(16),
          child: FutureBuilder(
              future: getInformation(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  receivedPlots.clear();
                  plotsNames.clear();
                  snapshot.data[0].docs.forEach((element) =>
                  element.data()['approved'] ?
                  element.data()['private'] && !snapshot.data[1].contains(element.data()['by']) ? null :
                  receivedPlots.add(element.data()): null
                  );
                  receivedPlots.forEach((element) {
                    plotsNames.add(element['name']);
                  });
                  if (plotsNames.length > 10) {
                    trending = plotsNames.sublist(0, 10);
                  } else {
                    trending = plotsNames;
                  }

                  return new SingleChildScrollView(child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                      InkWell(
                        onTap: () {
                          showSearch(
                              context: context,
                              delegate: SearchEntertainment(
                                  plotsNames, receivedPlots));
                        },
                        child: Ink(
                          height: 50,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              border: Border.all(color: Colors.black),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: <Widget>[
                              Align(
                                child: Icon(Icons.search),
                                alignment: Alignment.centerLeft,
                              ),
                              Align(
                                child: Text(
                                  "What's Plots?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                                alignment: Alignment.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      Row(children: [
                        Icon(Icons.local_fire_department, color: Colors.red,),
                        Text(
                          'Trending',
                          style: TextStyle(fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ],),
                      Divider(
                        thickness: 3,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: trending.map((item) => new Text('- $item',
                      style: TextStyle(
                        fontSize: 22,
                      ),)).toList()),
                      SizedBox(
                        height: 15,
                      ),

                    ],
                  )
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Container(width: 200, height:200,child: CircularProgressIndicator()));
                } else if (snapshot.connectionState == ConnectionState.none){
                  return Center(
                    child: Text(
                      'There are connectivity issues.\nPlease retry later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  );
                }else {
                 return PlotsError();

                }
              }),


      );
  }
}

class SearchEntertainment extends SearchDelegate<String> {
  final List plotsNames;
  final List receivedPlots;

  List<dynamic> recentSearches = [];

  SearchEntertainment(this.plotsNames, this.receivedPlots);

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for Appbar
    return [
//      IconButton(
//        icon: Icon(Icons.clear),
//        onPressed: () {
//          query = "";
//        },
//      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSearches
        : plotsNames.where((p) => p.startsWith(query)).toList();
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final auth.FirebaseAuth _authFirebase = auth.FirebaseAuth.instance;
    final suggestionList = query.isEmpty
        ? recentSearches
        : plotsNames
            .where((p) => p.toUpperCase().startsWith(query.toUpperCase()))
            .toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) => ListTile(
              onTap: () async{
                query = '${suggestionList[index]}';
                var obj;
                receivedPlots.forEach((element) {
                  if (element['name'] == query) {
                    obj = element;
                  }
                });
                FirebaseFirestore _firestore = FirebaseFirestore.instance;

                // Getting Favorites
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
                var resUsers = await _firestore.collection('users').doc(username).get();
                List currFavorites = resUsers.data()['favorites'];
                bool favorite = false;
                if(currFavorites.contains(obj['name'])){
                  favorite = true;
                }
                incrementLocalScore();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ChosenEvent(
                              name: obj['name'],
                              zipCode: obj['zipCode'],
                              location: obj['location'],
                              ratingsNumbers: obj['ratingsNumbers'].toDouble(),
                              private: obj['private'],
                              ratings: obj['ratings'],
                              burntRating: obj['burntRating'],
                              fromFeed: false,
                              byText: obj['by_text'],
                              description: obj['description'],
                              lat: obj['lat'],
                              long: obj['long'],
                              fav: favorite,
                              imgLink: obj['imgLink'],
                              website: obj['website'],
                              category: obj['category'],
                              by: obj['by'],
                              price: obj['price'],
                            )));
                // recentSearches.add(query);
                // showResults(context);
              },
              title: RichText(
                text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        style: TextStyle(color: Colors.black),
                        text: suggestionList[index].substring(query.length),
                      )
                    ]),
              ),
            ));
  }
}
