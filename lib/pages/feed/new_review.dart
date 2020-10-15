import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/services/BaseAuth.dart';
import 'package:cjapp/pages/home.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/services.dart';

class NewReview extends StatefulWidget {
  final String name;
  final String by;

  const NewReview({Key key, this.name, this.by}) : super(key: key);

  @override
  _NewReviewState createState() => _NewReviewState();
}

class _NewReviewState extends State<NewReview> {
  final _submitReviewForm = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var _auth = Auth();
  String errorMessage;
  String review;
  double rating = 0.0;
  String username;


  Future<void> uploadReview() async {
    try {
      // setting username variable
      auth.User _user = await _auth.getCurrentUser();
      var allUsers = await _firestore.collection('users').get();
      allUsers.docs.forEach((element) {
        if (element.data()['uid'] == _user.uid) {
          setState(() {
            username = element.data()['username'];
          });
        }
      });

      // Adding Data to Plots collection
      var resPlots = await _firestore.collection('plots').doc(widget.name).get();
      var currNum = resPlots.data()['ratingsNumbers'];
      List currList = resPlots.data()['ratings'];
      var newNum = (currList.length * currNum + rating) / (currList.length + 1);
      var newEntry = {'by':username,'review':review, 'rating': rating };
      currList.add(newEntry);
      await _firestore.collection('plots').doc(widget.name).update({
        'ratings': currList,
        'ratingsNumbers': newNum,
      }).catchError((onError) => {print(onError.toString())});


      // Adding Data to Users Collection
      var resUsers = await _firestore.collection('users').doc(username).get();
      List currReviews = resUsers.data()['reviews'];
      var newReview = {'place': widget.name, 'review': review, 'rating': rating};
      currReviews.add(newReview);
      await _firestore.collection('users').doc(username).update({
        'reviews': currReviews,
      }).catchError((onError) => {print(onError.toString())});

      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(
              builder: (BuildContext context) => Home()
          ));

    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      setState(
            () {
          errorMessage = e.message;
        },
      );
    }
  }


  String validateReview(String value) {
    if (value == null || value.isEmpty) {
      return "Missing Review";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write a Review'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: (){
            Navigator.pop(context);
            Navigator.push(context,
            MaterialPageRoute(
              builder: (BuildContext context) => Home()
            ));
          },
        ),
      ),
   body: SingleChildScrollView(
     padding: EdgeInsets.all(16),
     child: Form(
       key: _submitReviewForm,
       child: Column(
         children: [
           Row(
             children: [
               Expanded(child: Container(),),
               Row(children: [
                 Text('For ', style: TextStyle(
                   fontSize: 20
                 ),),
                 Text(widget.name, style: TextStyle(
                   fontSize: 20, fontWeight: FontWeight.bold
                 ),),
               ],),
               Expanded(child: Container(),),
             ],
           ),
           SizedBox(
             height: 10,
           ),
           TextFormField(
               validator: (text) => validateReview(text),
               onChanged: (value) => review = value,
               autocorrect: false,
               maxLines: null,
               decoration: InputDecoration(
                   icon: Icon(Icons.rate_review),
                   hintText: 'Write Your Review Here',
                   border: OutlineInputBorder(
                       borderRadius: BorderRadius.all(Radius.circular(3))
                   )
               )
           ),
           SizedBox(
             height: 10,
           ),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey,
                Colors.white
              ]
            ),
            borderRadius: BorderRadius.all(Radius.circular(25))
          ),
          child: Column(
            children: [
              Text('Slide Stars to Rate', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),),
              SizedBox(height: 5,),
              RatingBar(
                initialRating: 0,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.pink,
                ),
                onRatingUpdate: (rate) {
                  setState(() {
                    rating = rate;
                  });
                },
              ),
              Text('${rating.toString()} / 5.0', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
              ),),
            ],
          ),
        ),
           errorMessage != null
               ? Text(
             errorMessage,
             style: TextStyle(color: Colors.red),
             textAlign: TextAlign.center,
           )
               : Container(),
           SizedBox(
             height: 10,
           ),
           CustomButton(
             text: 'Submit Review',
             callback: () async {
               if (_submitReviewForm.currentState.validate()) {
                 uploadReview();
               } else {
                 print(errorMessage);
               }
             },
           )
         ],
       ),
     ),
   ),
    );
  }
}
