import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/pages/login/login.dart';
import 'package:cjapp/pages/settings/select_setting.dart';

class AboutPlots extends StatelessWidget {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
                child: Text(
              'Plots is a mobile app designed to facilitate the discovery of cultural attractions, breathtaking views, local entertainment, and everything else to eat up your boredom.',
                    style: TextStyle(fontWeight:
                    FontWeight.bold,
                    fontSize: 20), )),
            Image(
              image: AssetImage('assets/images/loginlogo.png'),
            ),
            Text('Brought to you by James Han.')

          ],
        ),
      ),
    );
  }
}
