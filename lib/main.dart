import 'package:flutter/material.dart';
import 'package:cjapp/pages/login/login.dart';
import 'package:cjapp/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:cjapp/services/app_colors.dart';

// Master branch


const String testDevice = 'Mobile_id';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'plots.',
       theme: ThemeData(
        fontFamily: 'OpenSans',
        primarySwatch: MaterialColor(0xfff2a3f3, color),
      ),
      // home: Home(),
      home: Home(),
    );
  }
}

