import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/widgets/rating_stars.dart';
import 'package:cjapp/pages/chosen_event.dart';

class HotSpot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ChosenEvent()));
        },
        child: new Ink(
            width: MediaQuery.of(context).size.width / 1.1,
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
                ]),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(25.0),
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
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Sky Zone',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' • ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            RatingStars(rating: 4.5),
                            Text(
                              ' 4.6/5',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Action, Moderate Price, 10 miles',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ))
              ],
            )));
  }
}
