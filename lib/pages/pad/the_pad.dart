import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThePad extends StatefulWidget {
  @override
  _ThePadState createState() => _ThePadState();
}

class _ThePadState extends State<ThePad> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Text('The Pad', style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold
              ),),
            )
          ],
    ),
    );
  }
}
