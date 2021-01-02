import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/services/BaseAuth.dart';
import 'package:cjapp/widgets/thank_you.dart';
import 'package:cjapp/services/global_functions.dart';
import 'package:cjapp/pages/home.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class NewReview extends StatefulWidget {
  final String name;
  final bool fromFeed;
  final String by;

  const NewReview({Key key, this.name, this.by, this.fromFeed}) : super(key: key);

  @override
  _NewReviewState createState() => _NewReviewState();
}

class _NewReviewState extends State<NewReview> {
  final _submitReviewForm = GlobalKey<FormState>();
  final RoundedLoadingButtonController _submitButtonController = new RoundedLoadingButtonController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var _auth = Auth();
  String errorMessage;
  String review;
  double rating = 0.0;
  double burnt_rating = 0.0;
  String username;
  int local_score;

  void _startUploadReview() async {
    Timer(Duration(milliseconds: 300), () async{
      if (_submitReviewForm.currentState.validate()) {
        uploadReview();
      } else {
        _submitButtonController.reset();
        print(errorMessage);
      }
    });
  }


  Future<void> uploadReview() async {
    try {
      // setting username variable
      auth.User _user = await _auth.getCurrentUser();
      var allUsers = await _firestore.collection('users').get();
      allUsers.docs.forEach((element) {
        if (element.data()['uid'] == _user.uid) {
          setState(() {
            username = element.data()['username'];
            local_score = element.data()['status'];
          });
        }
      });


      // Adding Data to Plots collection
      var resPlots = await _firestore.collection('plots').doc(widget.name).get();
      var currNum = resPlots.data()['ratingsNumbers'];
      var currBurntRating = resPlots.data()['burntRating'];
      List currList = resPlots.data()['ratings'];
      var newBurntRating = (currList.length * currBurntRating + burnt_rating) / (currList.length + 1);
      var newNum = (currList.length * currNum + rating) / (currList.length + 1);
      var newEntry = {'by':username,'review':review, 'rating': rating, };
      currList.add(newEntry);
      await _firestore.collection('plots').doc(widget.name).update({
        'ratings': currList,
        'ratingsNumbers': newNum,
        'burntRating' : newBurntRating
      }).catchError((onError) => {print(onError.toString())});


      // Adding Data to Users Collection
      var resUsers = await _firestore.collection('users').doc(username).get();
      List currReviews = resUsers.data()['reviews'];
      var newReview = {'place': widget.name, 'review': review, 'rating': rating, 'burntRating': burnt_rating };
      currReviews.add(newReview);
      await _firestore.collection('users').doc(username).update({
        'reviews': currReviews,
      }).catchError((onError) => {print(onError.toString())});
      incrementLocalScore();
      _submitButtonController.success();
      Navigator.pop(context);
      Navigator.push(context,
      MaterialPageRoute(
        builder: (BuildContext context) => ThankYou()
      ));

    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      _submitButtonController.reset();
      setState(
            () {
          errorMessage = e.message;
        },
      );
    }
  }


  String validateReview(String value) {
    if (value == null || value.isEmpty || value.trim() == '') {
      return "Missing Review";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Burnt Rating'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: (){
            Navigator.pop(context);
            if (!widget.fromFeed) {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Home()
                  ));
            }
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
                   fontSize: 25
                 ),),
                 Text(widget.name, style: TextStyle(
                   color: Colors.pinkAccent,
                   fontSize: 25, fontWeight: FontWeight.bold
                 ),),
               ],),
               Expanded(child: Container(),),
             ],
           ),
           Container(
             padding: EdgeInsets.all(16),
             width: MediaQuery.of(context).size.width / 1.1,
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
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text('Slide Bars to Rate', style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 20
                     ),),
                   ],
                 ),
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
                     color: Colors.pinkAccent,
                   ),
                   onRatingUpdate: (rate) {
                     setState(() {
                       rating = rate;
                     });
                   },
                 ),
                 Text('${rating.toString()}', style: TextStyle(
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
                     Icons.local_fire_department,
                     color: Colors.red,
                   ),
                   onRatingUpdate: (rate) {
                     setState(() {
                       burnt_rating = rate;
                     });
                   },
                 ),
                 Text('${burnt_rating.toString()}', style: TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: 15
                 ),),
               ],
             ),
           ),
           SizedBox(
             height: 10,
           ),
           TextFormField(
               validator: (text) => validateReview(text),
               onChanged: (value) => review = value,
               autocorrect: false,
               maxLines: null,
               minLines: 5,
               toolbarOptions: ToolbarOptions(
                 copy: true,
                 paste: true,
                 selectAll: true,
                 cut: true,
               ),
               decoration: InputDecoration(
                   labelText: 'Write Your Review Here',
                   hintText: 'This place is lit!',
                   border: OutlineInputBorder(
                       borderRadius: BorderRadius.all(Radius.circular(3))
                   )
               )
           ),
           SizedBox(
             height: 10,
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
           RoundedLoadingButton(
             width: 200,
             errorColor: Colors.red,
             child: Text('Submit Review', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
             controller: _submitButtonController,
             onPressed: _startUploadReview,
           ),

         ],
       ),
     ),
   ),
    );
  }
}
