import 'package:cjapp/pages/login/reset_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cjapp/pages/login/registration.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:cjapp/pages/home.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:cjapp/services/BaseAuth.dart';
import 'dart:async';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;
  String token;
  String errorMessage;
  final _loginFormKey = GlobalKey<FormState>();

  var _auth = Auth();
  final RoundedLoadingButtonController _loginButtonController = new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _signUpButtonController = new RoundedLoadingButtonController();


  void _startLogin() async {
    Timer(Duration(milliseconds: 300), () async{
      if (_loginFormKey.currentState.validate()) {
        signInUser();
      } else {
        _loginButtonController.reset();
      }
    });
  }


  void _startRegister() async {
    Timer(Duration(milliseconds: 300), () async{
      _signUpButtonController.success();
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Registration()));
    });
  }

  signInUser() async {
    try {
      await _auth.signIn(email, password);
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
          _loginFormKey.currentState.reset();
          email = null;
          password = null;
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

  String validatePassword(String value) {
    if (value == null || value.isEmpty) {
      return "Missing Password";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 200,
                    minHeight: 200,
                  ),
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(25.0),
                    child: Image(
                      image: AssetImage('assets/images/loginlogo.png'),
                    ),
                  ),
                ),
                TextFormField(
                    onChanged: (value) => email = value,
                    validator: (text) => validateEmail(text),
                    decoration: InputDecoration(
                      icon: Icon(Icons.mail),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      hintText: 'Email',
                    )),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                    onChanged: (value) => password = value,
                    obscureText: true,
                    validator: (text) => validatePassword(text),
                    autocorrect: false,
                    decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key),
                        hintText: 'Password',
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
                  child: Text('Login', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  controller: _loginButtonController,
                  onPressed: _startLogin,
                ),
                SizedBox(
                  height: 15,
                ),
                RoundedLoadingButton(
                  width: 200,
                  errorColor: Colors.red,
                  child: Text('Register', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  controller: _signUpButtonController,
                  onPressed: _startRegister,
                ),
                SizedBox(
                  height: 15,
                ),
                FlatButton(
                  child: Text('Continue as Guest', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.blue
                  ),),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Home()
                        ));
                  },
                ),
                FlatButton(
                  child: Text('Forgot Password?', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.red
                  ),),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ResetPassword()
                        ));
                  },
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
