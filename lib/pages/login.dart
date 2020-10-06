import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cjapp/pages/registration.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:cjapp/pages/home.dart';
import 'package:cjapp/services/BaseAuth.dart';
import 'package:flutter/services.dart';
import 'package:cjapp/widgets/custom_button.dart';

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

  signInUser() async {
    try {
      String userId = await _auth.signIn(email, password);
      print(userId);

      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => Home()));
    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
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
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  onChanged: (value) => email = value,
                  validator: (text) => validateEmail(text),
                  decoration: InputDecoration(
                      icon: Icon(Icons.mail),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      hintText: 'Email',
                      fillColor: Colors.deepPurpleAccent)),
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
              CustomButton(
                text: 'Login',
                callback: () {
                  if (_loginFormKey.currentState.validate()) {
                    signInUser();
                  } else {
                    print(errorMessage);
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              CustomButton(
                text: 'Sign Up',
                callback: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Registration()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
