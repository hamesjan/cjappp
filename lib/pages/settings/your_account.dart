import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/pages/login/login.dart';
import 'package:cjapp/pages/settings/select_setting.dart';

class YourAccount extends StatelessWidget {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Account'),
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
            Divider(thickness: 2,),
            SelectIconSetting(
              icon: Icon(Icons.auto_awesome),
              text: 'Change Your Username',
              callback: (){},
            ),
            Divider(thickness: 2,),
            SelectTextSetting(
              text: 'Permanently Delete Account',
              callback: (){
                _auth.signOut();
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Login()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
