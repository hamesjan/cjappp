import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class EntertainmentCategoryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.local_parking),
            iconSize: 25,
            onPressed: (){
            },
          ),
          Text('Test\nButton', textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}
