import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/home.dart';
import 'package:cjapp/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:cjapp/services/BaseAuth.dart';

class RegistrationTwo extends StatefulWidget {
  final String email;

  const RegistrationTwo({Key key, this.email}) : super(key: key);

  @override
  _RegistrationTwoState createState() => _RegistrationTwoState();
}

class _RegistrationTwoState extends State<RegistrationTwo> {
  String username;
  String zipCode;
  String errorMessage;
  final _registration2FormKey = GlobalKey<FormState>();
  var _auth = Auth();
  final RoundedLoadingButtonController _loginButtonController = new RoundedLoadingButtonController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _startLogin() async {
    Timer(Duration(milliseconds: 300), () async{
      if (_registration2FormKey.currentState.validate()) {
        registerUser();
      } else {
        _loginButtonController.reset();
      }
    });
  }


  Future<void> registerUser() async {
    try {
      DateTime today = new DateTime.now();
      var _today = DateTime.parse(today.toString());
      var _formatToday = DateFormat.yMMMd().format(_today);

      auth.User _user = await _auth.getCurrentUser();
      await _firestore.collection('users').doc(username).set({
        'username': username,
        'email': widget.email,
        'joined': _formatToday,
        'zipCode': zipCode,
        'favorites': [],
        'local_score': 0,
        'reviews': [],
        'uid': _user.uid,
      }).catchError((onError) => print(onError.toString()));
      _loginButtonController.success();
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => Home()));
    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      _loginButtonController.reset();
      setState(
        () {
          errorMessage = e.message;
        },
      );
    }
  }

  String validateUsername(String value) {
    if (value == null || value.isEmpty) {
      return "Missing Username";
    }
    return null;
  }

  String validateZip(String value) {
    if (value == null || value.isEmpty) {
      return "Missing Password";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child:Form(
          key: _registration2FormKey,
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
                  hintText: 'Enter Your Username',
                )),
            SizedBox(
              height: 15,
            ),
            TextFormField(
                validator: (text) => validateZip(text),
                onChanged: (value) => zipCode = value,
                decoration: InputDecoration(
                    icon: Icon(Icons.location_on_rounded),
                    hintText: 'Zip Code',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))))),
            SizedBox(
              height: 10,
            ),
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
              child: Text('Register', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              controller: _loginButtonController,
              onPressed: _startLogin,
            ),
          ],
        ),
      ),
      )
    );
  }
}
