import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlotsError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Something went wrong :(\nTry reloading the page or checking your connection.', textAlign: TextAlign.center, style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold
      ),),
    );
  }
}
