import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RatingStars extends StatelessWidget {
  final double rating;

  RatingStars({this.rating});
 @override
  Widget build(BuildContext context) {
    if (rating == 5) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
//          color: Colors.grey
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
        ],),
      );
    } else if (rating >= 4.5) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star_half, color: Colors.pink,),
        ],),
      );
    }
    else if (rating >= 4.0) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
        ],),
      );
    }else if (rating >= 3.5) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star_half, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
        ],),
      );
    }
    else if (rating >= 3.0) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
        ],),
      );
    }else if (rating >= 2.5) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star_half, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
        ],),
      );
    }
    else if (rating >= 2.0) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
        ],),
      );
    }else if (rating >= 1.5) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star_half, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
        ],),
      );
    }else if (rating >= 1.0) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
        ],),
      );
    }
    else if (rating >= 0.5) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star_half, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
        ],),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(children: <Widget>[
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
          Icon(Icons.star_border, color: Colors.pink,),
        ],),
      );
    }
  }
}
