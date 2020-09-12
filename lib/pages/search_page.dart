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
      body: Center(
          child: FlatButton(
            child: Container(
              padding: EdgeInsets.all(50),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(100))
              ),
              child: Icon(Icons.search, size: 50,)
            ),
            onPressed: (){
              showSearch(context: context, delegate: SearchEntertainment());
            },
          )
      ),
    );
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
    return [IconButton(icon: Icon(Icons.clear), onPressed: (){
      query = "";
    },)];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: (){
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSearches
        : tricks.where((p) => p.startsWith(query)).toList();

    return Container(
      color:Colors.red,
      height: 100,
      width: 100,
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? recentSearches
        : tricks.where((p) => p.toUpperCase().contains(query.toUpperCase())).toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) => ListTile(
          onTap: (){
            query = '${suggestionList[index]}';
            recentSearches.add(query);
            showResults(context);
          },
          title: RichText(
            text: TextSpan(
                text: suggestionList[index].substring(0, query.length),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
                children: [
                  TextSpan(
                    style: TextStyle(
                        color: Colors.black
                    ),
                    text: suggestionList[index].substring(query.length),
                  )
                ]
            ),
          ),
        )
    );
  }

}