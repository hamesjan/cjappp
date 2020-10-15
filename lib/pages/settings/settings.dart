import 'package:cjapp/pages/settings/select_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cjapp/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/pages/login/login.dart';
import 'package:cjapp/pages/settings/your_account.dart';

class SettingsPage extends StatelessWidget {
    final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
            Navigator.push(context,
            MaterialPageRoute(
              builder: (BuildContext context) => Home()
            ));
          },
        ),
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Divider(thickness: 2,),
            SelectIconSetting(
              icon: Icon(Icons.security),
              text: 'Privacy',
              callback: (){},
            ),
            SelectIconSetting(
              icon: Icon(Icons.person),
              text: 'Your Account',
              callback: (){
                Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => YourAccount()));
              },
            ),
            SelectIconSetting(
              icon: Icon(Icons.payment),
              text: 'Payment Method',
              callback: (){},
            ),
            SelectIconSetting(
              icon: Icon(Icons.info),
              text: 'About',
              callback: (){},
            ),
            Divider(thickness: 2,),
            SelectTextSetting(
              text: 'Log Out',
              callback: (){
                showDialog(context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Are you sure you want to log out?'),
                        actions: <Widget>[
                          IconButton(
                            onPressed: (){
                        _auth.signOut();
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Login()));
                      },
                            icon: Icon(Icons.logout),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    }
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
