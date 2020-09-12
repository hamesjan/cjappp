import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cjapp/pages/home.dart';
import 'package:cjapp/pages/registration.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/widgets/custom_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;
  String token;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Future<auth.User> getUser() async{
    return _auth.currentUser;
  }

  signInUser() async{
    await _auth.signInWithEmailAndPassword(email: email, password: password);
    auth.User temp = await getUser();
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(
            builder: (BuildContext context) => Home()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            TextField(
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    icon: Icon(Icons.mail),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    ),
                    hintText: 'Email',
                    fillColor: Colors.deepPurpleAccent
                )
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
                onChanged: (value) => password = value,
                obscureText: true,
                autocorrect: false,
                decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    )
                )
            ),
            SizedBox(
              height: 15,
            ),
            CustomButton(
              text: 'Login',
              callback: () {
                signInUser();
              } ,
            ),
            SizedBox(
              height: 15,
            ),
            CustomButton(
              text: 'Sign Up',
              callback: (){
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Registration()
                    )
                );
              },
            )

          ],
        ),
      ),
    );
  }
}