import 'package:cjapp/pages/settings/change_username.dart';
import 'package:cjapp/pages/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/pages/login/login.dart';
import 'package:cjapp/pages/settings/select_setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/services/BaseAuth.dart';
import 'package:flutter/services.dart';

class YourAccount extends StatelessWidget {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteUser(context) async {
    try {
      var _auth = Auth();
      String username;
      auth.User _user = await _auth.getCurrentUser();
      var allUsers = await _firestore.collection('users').get();
      allUsers.docs.forEach((element) {
        if (element.data()['uid'] == _user.uid) {
          username = element.data()['username'];
        }
      });
      await _firestore.collection('users').doc(username).delete();
      await _user.delete();
      await _auth.signOut();
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Login()));
    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Account'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: (){
            Navigator.pop(context);
            Navigator.push(context,
            MaterialPageRoute(
              builder: (BuildContext context) => SettingsPage()
            ));
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
              callback: () async {
                Navigator.pop(context);
                Navigator.push(context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ChangeUsername()
                ));
              },
            ),
            Divider(thickness: 2,),
            SelectTextSetting(
              text: 'Permanently Delete Account',
              callback: (){
                showDialog(context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Are you sure you want to delete your account?'),
                        content: Text('This action can not be undone.', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.red
                        ),),
                        actions: <Widget>[
                          IconButton(
                            onPressed: (){
                              deleteUser(context);
                            },
                            icon: Icon(Icons.delete_forever, color: Colors.red,),
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
