import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/profile/review_widget.dart';

class AllReviews extends StatelessWidget {
  final List ratings;
  final String name;

  const AllReviews({Key key, this.ratings, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Reviews of $name'),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body:
      SingleChildScrollView(
          child: ratings == null ? Container() :
          new Column(children: [
            Column(children: ratings.map((item) => new Container( margin: EdgeInsets.all(15), child: ReviewWidget(place: item['by'], rating: item['rating'].toString(),
              review: item['review'],))).toList())
          ])
      ),
    );;;
  }
}

