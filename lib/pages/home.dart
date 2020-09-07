import 'package:flutter/material.dart';
import 'package:cjapp/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/feed.dart';
import 'package:cjapp/pages/search_page.dart';
import 'package:cjapp/pages/map_page.dart';
import 'package:cjapp/pages/new_place.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  TabController _tabController;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;



  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Welcome', style: TextStyle(
            color: Colors.white,
            fontSize: 22
        ),),
        backgroundColor: Colors.pinkAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white,),
            onPressed: (){
              _auth.signOut();
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Login()
                  ));
            },
          )
        ],
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Feed(),
            SearchPage(),
            MapPage(),
          ],
        ),
      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          Navigator.pop(context);
//          Navigator.push(context,
//              MaterialPageRoute(
//                  builder: (BuildContext context) => NewPlace()
//              ));        },
//        child: Icon(Icons.add),
//        backgroundColor: Colors.pink,
//      ),
      bottomNavigationBar: SafeArea(
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.black12,
          unselectedLabelColor: Colors.black38,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home, color: Colors.black,),
            ),
            Tab(
              icon: Icon(Icons.search, color:  Colors.black,),
            ),
            Tab(
              icon: Icon(Icons.map, color: Colors.black,),
            ),
          ],
        ),
      ),
    );
  }
}
