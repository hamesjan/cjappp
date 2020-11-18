import 'package:cjapp/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PleaseSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(

        elevation: 10,
        child:Container(
          padding: EdgeInsets.all(16),
          child: Text('Please log in.', textAlign: TextAlign.center, style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
        ),),),
        onPressed: (){
          Navigator.pop(context);
          Navigator.push(context,
          MaterialPageRoute(
            builder: (BuildContext context) => Login()
          ));
        },
      )
    );
  }
}
