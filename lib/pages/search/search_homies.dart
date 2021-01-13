import 'package:cjapp/services/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/services/BaseAuth.dart';
import 'package:cjapp/pages/view_profile/view_user_profile.dart';


class SearchHomies extends SearchDelegate<String> {
  final List homieNames;
  final List receivedHomies;

  List<dynamic> recentSearches = [];

  SearchHomies(this.homieNames, this.receivedHomies);

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
        : homieNames.where((p) => p.startsWith(query)).toList();
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final auth.FirebaseAuth _authFirebase = auth.FirebaseAuth.instance;
    final suggestionList = query.isEmpty
        ? recentSearches
        : homieNames
        .where((p) => p.toUpperCase().startsWith(query.toUpperCase()))
        .toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) => ListTile(
          onTap: () async{
            query = '${suggestionList[index]}';
            var obj;
            homieNames.forEach((element) {
              if (element == query) {
                obj = element;
              }
            });
            FirebaseFirestore _firestore = FirebaseFirestore.instance;

            incrementLocalScore();

              // Check homie status
              String myUsername = await returnUsername();
              var resUsers = await _firestore.collection('users').doc(obj).get();
              List currRequests = resUsers.data()['link_requests'];
              List currHomies = resUsers.data()['homies'];
              if(currRequests.contains(myUsername)){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => ViewProfile(
                    username: obj,
                    homieStatus: 'pending',
                  ),
                )
                );
              } else if (currHomies.contains(myUsername)){
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => ViewProfile(
                    username: obj,
                    homieStatus: 'yes',
                  ),
                )
                );
              } else {
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) => ViewProfile(
                    username: obj,
                    homieStatus: 'no',
                  ),
                )
                );
              }
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
