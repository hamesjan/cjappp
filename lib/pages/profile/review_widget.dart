import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/widgets/rating_stars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/services/global_functions.dart';

class ReviewWidget extends StatelessWidget {
  final String review;
  final String rating;
  final String place;
  final bool myReview;



  ReviewWidget({this.review, this.rating, this.place, this.myReview});

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
          myReview ?  Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            child: Text(
              place,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Container(),),
          IconButton(icon: Icon(Icons.delete, size: 25, color: Colors.red,),
            onPressed: (){
              showDialog(context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete Review?'),
                      actions: <Widget>[
                        IconButton(
                          onPressed: () async {
                            try {
                              String username = await returnUsername();
                              final FirebaseFirestore _firestore = FirebaseFirestore
                                  .instance;
                              // deleting from plots
                              var resPlots = await _firestore.collection(
                                  'plots').doc(place).get();
                              List currList = resPlots.data()['ratings'];
                              for (var i = 0; i < currList.length; i++) {
                                if (currList[i]['review'] == review) {
                                  currList.removeAt(i);
                                }
                              }
                              await _firestore.collection('plots')
                                  .doc(place)
                                  .update({
                                'ratings': currList,
                              });

                              // deleting from user
                              var resUsers = await _firestore.collection(
                                  'users').doc(username).get();
                              List currReviews = resUsers.data()['reviews'];
                              for (var i = 0; i < currReviews.length; i++) {
                                if (currReviews[i]['review'] == review) {
                                  currReviews.removeAt(i);
                                }
                              }
                              await _firestore.collection('users')
                                  .doc(username)
                                  .update({
                                'reviews': currReviews,
                              });

                            } catch (e) {
                              print(e.toString());
                            }
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.delete, color: Colors.red,),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  }
              );
            },)
        ],
      ) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  place,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(child: Container(),),
              IconButton(icon: Icon(Icons.report, size: 25, color: Colors.red,),
              onPressed: (){
                showDialog(context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Report review?'),
                        actions: <Widget>[
                          IconButton(
                            onPressed: () async {
                              final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                              var username = await returnUsername();
                              try {
                                await _firestore.collection('reports').doc(username).set({
                                  'review': review,
                                  'place': place,
                                }).catchError((onError) => {print(onError.toString())});
                              }  catch (e) {
                                print(e);
                              }
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.report, color: Colors.red,),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    }
                );
              },)
            ],
          ),
          Divider(thickness: 2,),
          Text('"$review"', style: TextStyle(fontSize: 15),),
          SizedBox(height: 5,),
          Row(
            children: [
              Expanded(child: Container(),),
              RatingStars(rating: double.parse(rating),),
              Expanded(child: Container(),),
            ],
          ),
          Text('$rating / 5.0')
        ],
      ),
    );
  }
}
