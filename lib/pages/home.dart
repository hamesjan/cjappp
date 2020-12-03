import 'package:cjapp/widgets/please_sign_in.dart';
import 'package:cjapp/widgets/plotserror.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/feed/feed.dart';
import 'package:cjapp/pages/search/search_page.dart';
import 'package:cjapp/pages/map_page/map_page.dart';
import 'package:cjapp/pages/login/login.dart';
import 'package:cjapp/pages/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/services/lifecycle_handler.dart';
import 'package:location/location.dart';
import 'package:cjapp/pages/profile/new_place.dart';
import 'package:cjapp/services/app_colors.dart';
import 'package:cjapp/pages/profile/profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabController;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  Location location = new Location();
//  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(
        LifecycleEventHandler(resumeCallBack: () async => setStateIfMounted(checkPermissions()))
    );
    _tabController = TabController(vsync: this, length: 4);
  }

   setStateIfMounted(Future<void> f) {
    if (mounted) {
      setState(() {
        f;
      });
    }
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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Welcome',
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        backgroundColor: MaterialColor(0xfff2a3f3, color),
        actions: <Widget>[
          _auth.currentUser == null ?
          IconButton(
            icon: Icon(
              Icons.login,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Login()));
            },
          ): IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SettingsPage()));
            },
          )
        ],
      ),
      body: SafeArea(
        child: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: <Widget>[
            Feed(),
            SearchPage(),
            _auth.currentUser == null ? PleaseSignIn() : ProfilePage(),
            MapPage(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => NewPlace()));
        },
        child: Icon(Icons.add),
        backgroundColor: MaterialColor(0xfff2a3f3, color),
      ),

      bottomNavigationBar: SafeArea(
        child: TabBar(
          controller: _tabController,
          labelColor: Colors.black12,
          unselectedLabelColor: Colors.black38,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
            Tab(
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
            // Tab(
            //   icon: Icon(
            //     Icons.error,
            //     color: Colors.red,
            //   ),
            // ),
            Tab(
              icon: Icon(
                Icons.map,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
