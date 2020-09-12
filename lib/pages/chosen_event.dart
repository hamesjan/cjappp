import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/home.dart';
import 'package:cjapp/widgets/rating_stars.dart';

class ChosenEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('[CHOSEN EVENT NAME HERE]'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => Home()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(50, 30),
                    bottomRight: Radius.elliptical(50, 30)),
                child: Image(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://images-na.ssl-images-amazon.com/images/I/819TInppvbL._AC_SX522_.jpg'),
                ),
              ),
            ),
            Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Sky Zone',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Action, Moderate Price, 10 miles',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        RatingStars(rating: 4.5),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '23 Ratings',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      onTap: () {
                        print('Hello');
                      },
                      child: Ink(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.room,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('1234 Test St. Torrance, CA 90503')
                          ],
                        ),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
