import 'package:cjapp/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:cjapp/services/BaseAuth.dart';
import 'dart:async';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String email;
  String errorMessage;
  final _resetPasswordFormKey = GlobalKey<FormState>();
  var _auth = Auth();
  final RoundedLoadingButtonController _loginButtonController = new RoundedLoadingButtonController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _startResetPassword() async {
    Timer(Duration(milliseconds: 300), () async{
      if (_resetPasswordFormKey.currentState.validate()) {
        _resetPassword();
      } else {
        _loginButtonController.reset();
      }
    });
  }


  Future<void> _resetPassword() async {
    try {
      await _auth.resetPassword(email);
      _loginButtonController.success();
      showDialog(context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Thank you; an email will be sent out immediately.\nAllow a couple of minutes for the email to arrive.'),
              actions: <Widget>[
                IconButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Login()
                        ));
                  },
                  icon: Icon(Icons.check, color: Colors.green,),
                ),
              ],
            );
          }
      );
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

  String validateEmail(String value) {
    if (value == null || value.isEmpty) {
      return "Missing Email";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: (){
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Login()));
            },
          ),
          title: Text('Reset Password'),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child:Form(
            key: _resetPasswordFormKey,
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                    validator: (text) => validateEmail(text),
                    onChanged: (value) => email = value,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      hintText: 'Enter Your Email',
                    )),
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
                  child: Text('Reset Password', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  controller: _loginButtonController,
                  onPressed: _resetPassword,
                ),
              ],
            ),
          ),
        )
    );
  }
}
