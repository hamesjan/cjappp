import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/home.dart';

class ThankYou extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text(''),
        elevation: 0,
      ),
      body:  GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Color(0xfff2a3f3),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child:Container(
              margin: const EdgeInsets.all(20.0),
            child:
            Text('Thank you for contributing to plots.',textAlign: TextAlign.center, style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 55
            ),
            ),
          ),
        ),
      ),
    );
  }
}
