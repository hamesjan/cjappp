import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/widgets/rating_stars.dart';

class ReviewWidget extends StatelessWidget {
  final String review;
  final double rating;
  final String place;



  ReviewWidget({this.review, this.rating, this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      child: Column(
        crossAxisAlignment:  CrossAxisAlignment.center,
        children: [
          Text(place, style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
          Divider(thickness: 2,),
          Text('"$review"', style: TextStyle(fontSize: 15),),
          SizedBox(height: 5,),
          Row(
            children: [
              Expanded(child: Container(),),
              RatingStars(rating: rating,),
              Expanded(child: Container(),),
            ],
          ),
          Text('$rating / 5.0')
        ],
      ),
    );
  }
}
