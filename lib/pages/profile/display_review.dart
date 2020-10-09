import 'package:cjapp/widgets/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/profile/display_review.dart';

class DisplayReview extends StatelessWidget {
  final double rating;
  final String text;
  final int likes;
  final String title;

  DisplayReview({this.rating, this.text, this.title, this.likes});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    '$title - ',
                    style: TextStyle(fontSize: 25),
                  ),
                  RatingStars(
                    rating: rating,
                  ),
                  Expanded(child: Container(),),
                  Text(likes.toString(), textAlign: TextAlign.center, style: TextStyle(
                    fontSize: 15
                  ),),
                  SizedBox(width: 5,),
                  Icon(Icons.thumb_up),
                ],
              ),
              Divider(
                thickness: 2,
              ),
              Text(text),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }
}
