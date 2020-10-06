import 'package:flutter/material.dart';
import 'package:cjapp/pages/login.dart';
import 'package:cjapp/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'OpenSans',
        primarySwatch: Colors.pink,
      ),
      // home: Home(),
      home:_auth.currentUser == null ? Login() : Home(),
    );
  }
}

