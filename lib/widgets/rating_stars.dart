import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RatingStars extends StatelessWidget {
  final double rating;

  RatingStars({this.rating});
 @override
  Widget build(BuildContext context) {
    if (rating == 5) {
      return Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
//          color: Colors.grey
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
        ],),
      );
    } else if (rating >= 4.5) {
      return Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star_half, color: Colors.yellow,),
        ],),
      );
    }
    else if (rating >= 4.0) {
      return Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
        ],),
      );
    }else if (rating >= 3.5) {
      return Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star_half, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
        ],),
      );
    }
    else if (rating >= 3.0) {
      return Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
        ],),
      );
    }else if (rating >= 2.5) {
      return Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star_half, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
        ],),
      );
    }
    else if (rating >= 2.0) {
      return Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
        ],),
      );
    }else if (rating >= 1.5) {
      return Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star_half, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
        ],),
      );
    }else if (rating >= 1.0) {
      return Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
        ],),
      );
    }
    else if (rating >= 0.5) {
      return Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star_half, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
        ],),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
          Icon(Icons.star_border, color: Colors.yellow,),
        ],),
      );
    }
  }
}
