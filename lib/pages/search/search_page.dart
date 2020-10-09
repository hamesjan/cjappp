import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              showSearch(context: context, delegate: SearchEntertainment());
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
  final tricks = [
    'Movies',
    'Paintball',
    'Skyzone',
    'Views',
    'Beaches',
    'Hiking Trails',
    'Parks',
    'Skate Parks',
    'Clubs'
  ];

  List<dynamic> recentSearches = [];

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
        : tricks.where((p) => p.startsWith(query)).toList();

    return Container(
      color: Colors.red,
      height: 100,
      width: 100,
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSearches
        : tricks
            .where((p) => p.toUpperCase().contains(query.toUpperCase()))
            .toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                query = '${suggestionList[index]}';
                recentSearches.add(query);
                showResults(context);
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
