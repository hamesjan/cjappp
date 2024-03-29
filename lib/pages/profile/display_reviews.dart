import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/profile/review_widget.dart';

class DisplayReviews extends StatelessWidget {
  final List reviews;
  final bool myReview;

  DisplayReviews({this.reviews, this.myReview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Reviews'),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: reviews.length == 0 ? Center(
        child: Text('No reviews found.', style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22
        ),),
      ):
        SingleChildScrollView(
            child: reviews == null ? Container() :
            new Column(children: [
              Column(children: reviews.map((item) => new Container( margin: EdgeInsets.all(15), child: ReviewWidget(myReview: myReview, place: item['place'], rating: item['rating'].toString(),
              review: item['review'],))).toList())
    ])
        ),
    );
  }
}
