import 'package:cjapp/pages/home.dart';
import 'package:cjapp/pages/profile/favorite_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/profile/review_widget.dart';

class DisplayFavorites extends StatelessWidget {
  final List favorites;

  DisplayFavorites({this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Bookmarks'),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => Home()
            ));
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: 
      SingleChildScrollView(
          child: favorites.length == 0 ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Divider(),
              Container(
                 padding: EdgeInsets.all(16), 
                  child: Text('No bookmarks yet.\nGo explore some plots and come back!', textAlign: TextAlign.center, style: TextStyle(
                  fontSize: 20,
                fontWeight: FontWeight.bold
              ),)),
              
              Icon(Icons.bookmarks_outlined)
            ],
          ) :
          new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: favorites.map((item) => new
              Column(children: [
                FavoriteWidget(name: item,),
                Divider(thickness: 2,)
              ],)
              ).toList())
      ),
    );
  }
}
