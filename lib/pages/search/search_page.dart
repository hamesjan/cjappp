import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/pages/feed/chosen_event.dart';
import 'package:cjapp/pages/home.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List receivedPlots = [];
  List plotsNames = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FutureBuilder(
                  future: _firestore.collection('plots').get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      receivedPlots.clear();
                      plotsNames.clear();
                      snapshot.data.docs.forEach((element) => receivedPlots.add(element.data()));
                      receivedPlots.forEach((element) { plotsNames.add(element['name']);});
                      return new
                      InkWell(
                        onTap: () {
                          showSearch(context: context, delegate: SearchEntertainment(plotsNames, receivedPlots));
                        },
                        child: Ink(
                          height: 50,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(15))),
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
                      );
                    }
                    if( snapshot.connectionState == ConnectionState.waiting){
                      return Container(child: CircularProgressIndicator());
                    }
                    else {
                      return Container(child: Text('An Error Occurred.'), color: Colors.red,);
                    }
                  }
              ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Trending',
            style: TextStyle(fontSize: 30),
          ),
          Divider(
            thickness: 3,
          ),
          Text(
            'Show Trending Searches Here',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Show Trending Searches Here',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Show Trending Searches Here',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Show Trending Searches Here',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Show Trending Searches Here',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Show Trending Searches Here',
            style: TextStyle(fontSize: 18),
          ),

        ],
      ),
    ));
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
    final suggestionList = query.isEmpty
        ? recentSearches
        : plotsNames
            .where((p) => p.toUpperCase().startsWith(query.toUpperCase()))
            .toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                query = '${suggestionList[index]}';
                var obj;
                receivedPlots.forEach((element) {
                  if (element['name'] == query) {
                    obj = element;
                  }
                });
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ChosenEvent(
                          name: obj['name'],
                          zipCode: obj['zipCode'],
                          location: obj['location'],
                          ratingsNumbers: obj['ratingsNumbers'],
                          ratings: obj['ratings'],
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
