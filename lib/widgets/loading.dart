import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            new CircularProgressIndicator(),
            new Text('Loading...')
          ],
        ),
      ),
    );
  }
}
