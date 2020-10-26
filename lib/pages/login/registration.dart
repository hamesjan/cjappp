import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/widgets/custom_button.dart';
import 'package:cjapp/pages/login/registration_2.dart';
import 'package:cjapp/services/BaseAuth.dart';
import 'package:flutter/services.dart';
import 'package:cjapp/pages/login/login.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String email;
  String password;
  String confirmPassword;
  String errorMessage;
  final _registrationFormKey = GlobalKey<FormState>();
  var _auth = Auth();

  String validateMatchingPasswords(
    String value,
  ) {
    if (value != password) {
      return "Password Do Not Match";
    }
    return null;
  }

  Future<void> registerUser() async {
    try {
      await _auth.signUp(email, password);
      await _auth.sendEmailVerification();

      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => RegistrationTwo(email: email,)));
    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      setState(
        () {
          errorMessage = e.message;
          _registrationFormKey.currentState.reset();
          email = null;
          password = null;
        },
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _registrationFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => email = value,
                  decoration: InputDecoration(
                    icon: Icon(Icons.mail),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                    hintText: 'Enter Your Email',
                  )),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  onChanged: (value) => password = value,
                  decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      hintText: 'Enter Your Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))))),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  validator: (value) => validateMatchingPasswords(value),
                  onChanged: (value) => confirmPassword = value,
                  decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      hintText: 'Confirm Password',
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
                text: 'Register',
                callback: () {
                  if (_registrationFormKey.currentState.validate()) {
                    registerUser();
                  } else {
                    return;
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
