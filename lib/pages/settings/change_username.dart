import 'package:cjapp/pages/settings/your_account.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:cjapp/services/BaseAuth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:cjapp/services/global_functions.dart';


// Change Bytext on each plots

class ChangeUsername extends StatefulWidget {
  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final _changeUsernameFormKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _changeUsernameButtonController = new RoundedLoadingButtonController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String username;
  String errorMessage;


  Future<void> changeName() async {
    try {
      bool taken = false;
      String oldUsername = await returnUsername();
      var takenNames = await _firestore.collection('users').get();
      takenNames.docs.forEach((element) {
        if (element.data()['username'] == username){
          taken = true;
        }
      });
      if(taken){
        _changeUsernameButtonController.reset();
        setState(
              () {
            errorMessage = 'Sorry, that username is taken.';
          },
        );
      } else {
        await _firestore.collection('users').doc(oldUsername).update({
          'username': username
        });
        var resUsers = await _firestore.collection('users').doc(oldUsername).get();
        Map<String,dynamic> holder = resUsers.data();
        await _firestore.collection('users').doc(username).set(holder);
        await _firestore.collection('users').doc(oldUsername).delete();
        _changeUsernameButtonController.success();
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => YourAccount()));
      }
    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      _changeUsernameButtonController.reset();
      setState(
            () {
          errorMessage = e.message;
        },
      );
    }
  }

  void _startLogin() async {
    Timer(Duration(milliseconds: 300), () async{
      if (_changeUsernameFormKey.currentState.validate()) {
        changeName();
      } else {
        _changeUsernameButtonController.reset();
      }
    });
  }

  String validateUsername(String value) {
    List<String> validLetters = ['a', 'b', 'c', 'd', 'e', 'f', 'g','h','i','j',
      'k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z', '1', '2',
      '3','4','5','6','7','8','9','0', '_', '.'];
    for (var i = 0; i < value.length; i++) {
      if (validLetters.contains(value[i].toLowerCase())){
        continue;
      } else {
        return "Invalid characters in username";
      }
    }
    if (value == null || value.isEmpty) {
      return "Username is invalid.";
    } else if (value.length > 20) {
      return "Username has to be less than 20 characters.";
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Change Username'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => YourAccount()
                  )
              );
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child:Form(
            key: _changeUsernameFormKey,
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                    validator: (text) => validateUsername(text),
                    onChanged: (value) => username = value,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      hintText: 'Enter Your New Username',
                    )),
                errorMessage != null
                    ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                RoundedLoadingButton(
                  width: 200,
                  errorColor: Colors.red,
                  child: Text('Change Name', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  controller: _changeUsernameButtonController,
                  onPressed: _startLogin,
                ),
              ],
            ),
          ),
        )
    );
  }
}
