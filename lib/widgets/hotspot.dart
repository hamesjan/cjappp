import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class HotSpot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Colors.white70,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              height: 200,
              child: ClipRRect(
                borderRadius: new BorderRadius.circular(24.0),
                child: Image(
                  fit: BoxFit.fill,
                  image: NetworkImage('https://images-na.ssl-images-amazon.com/images/I/819TInppvbL._AC_SX522_.jpg'),
                ),
              ),),
            Row(
              children: <Widget>[
                Text('Hello', style: TextStyle(
                    fontSize: 22
                ),)
              ],
            )
          ],
        )
    );
  }
}

