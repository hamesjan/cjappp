import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/home.dart';
import 'package:cjapp/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String email;
  String username;
  String password;
  String token;


  final FirebaseFirestore _firestore = Firestore.instance;

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;


  Future<void> registerUser() async{
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
    auth.User _user =  _auth.currentUser;
    await _firestore.collection('users').doc(username).setData({
      'username': username,
      'email' : email,
      'uid' : _user.uid,
    });


    auth.User temp = await getUser();
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(
            builder: (BuildContext context) => Home()
        )
    );
  }

  Future<auth.User> getUser() async{
    return _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                onChanged: (value) => username = value,
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3))
                  ),
                  hintText: 'Enter Your Username',
                )
            ),
            TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                  icon: Icon(Icons.mail),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(3))
                  ),
                  hintText: 'Enter Your Email',
                )
            ),
            SizedBox(
              height: 15,
            ),
            TextField(
                autocorrect: false,
                obscureText: true,
                onChanged: (value) => password = value,
                decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    hintText: 'Enter Your Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    )
                )
            ),
            SizedBox(
              height: 15,
            ),
            CustomButton(
              text: 'Register',
              callback: ()  async{
               registerUser();

              },
            )
          ],
        ),
      ),
    );
  }
}
