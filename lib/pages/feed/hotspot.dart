import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/widgets/rating_stars.dart';
import 'package:cjapp/pages/feed/chosen_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:cjapp/services/BaseAuth.dart';
import 'package:cjapp/widgets/price_icon_widget.dart';

class HotSpot extends StatelessWidget {
  final String name;
  final String zipCode;
  final String location;
  final double ratingsNumbers;
  final double lat;
  final double long;
  final String imgLink;
  final List ratings;
  final String website;
  final String category;
  final String by;
  final bool fav;
  final String price;

  const HotSpot({Key key, this.name, this.zipCode, this.imgLink, this.location, this.by, this.ratingsNumbers, this.lat, this.long, this.ratings, this.website, this.category, this.price, this.fav}) : super(key: key);


  Future<void> addFavorite(context) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var _auth = Auth();
    try {
      // setting username variable
      auth.User _user = await _auth.getCurrentUser();
      var allUsers = await _firestore.collection('users').get();
      allUsers.docs.forEach((element) async{
        if (element.data()['uid'] == _user.uid) {
          var resUsers = await _firestore.collection('users').doc(element.data()['username']).get();
          List currFavorites = resUsers.data()['favorites'];
          currFavorites.add(name);
          await _firestore.collection('users').doc(element.data()['username']).update({
            'favorites': currFavorites,
          }).catchError((onError) => {print(onError.toString())});
        }
      });

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
    }
      on PlatformException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeFavorite(context) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var _auth = Auth();

    try {
      // setting username variable
      auth.User _user = await _auth.getCurrentUser();
      var allUsers = await _firestore.collection('users').get();
      allUsers.docs.forEach((element) async{
        if (element.data()['uid'] == _user.uid) {
          var resUsers = await _firestore.collection('users').doc(element.data()['username']).get();
          List currFavorites = resUsers.data()['favorites'];
          currFavorites.remove(name);
          await _firestore.collection('users').doc(element.data()['username']).update({
            'favorites': currFavorites,
          }).catchError((onError) => {print(onError.toString())});

        }
      });
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Home()));
    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  Future<void> registerClick() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      // Adding Data to Plots collection
      var resPlots = await _firestore.collection('plots').doc(name).get();
      var currNum = resPlots.data()['clicks'];
      await _firestore.collection('plots').doc(name).update({
        'clicks': currNum + 1,
      }).catchError((onError) => {print(onError.toString())});


    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        onTap: () {
          registerClick();
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ChosenEvent(
                    name: name,
                    zipCode: zipCode,
                    location: location,
                    ratingsNumbers: ratingsNumbers.toDouble(),
                    ratings: ratings,
                    imgLink: imgLink,
                    website: website,
                    long: long,
                    lat: lat,
                    fav: fav,
                    category: category,
                    by: by,
                    price: price,
                  )));
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
                        constraints: BoxConstraints(
                          maxHeight: 200,
                          minHeight: 200,
                        ),
                        child: OptimizedCacheImage(
                          imageUrl: imgLink,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                name,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),

                            Expanded(child: Container(),),
                           fav ? IconButton(icon: Icon(Icons.bookmark), onPressed: (){
                             showDialog(context: context,
                                 barrierDismissible: true,
                                 builder: (BuildContext context) {
                                   return AlertDialog(
                                     title: Text('Remove Bookmark?'),
                                     actions: <Widget>[
                                       IconButton(
                                         onPressed: (){
                                           removeFavorite(context);
                                         },
                                         icon: Icon(Icons.check),
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
                           }):  IconButton(icon: Icon(Icons.bookmark_border), onPressed: (){
                              showDialog(context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Bookmark this Plot?'),
                                      actions: <Widget>[
                                        IconButton(
                                          onPressed: (){
                                            addFavorite(context);
                                          },
                                          icon: Icon(Icons.check),
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
                            })
                          ],
                        ),
                       Row(
                            children: <Widget>[
                              ratings.length == 0 ? Container() : RatingStars(rating: ratingsNumbers),
                              ratings.length == 0 ? Container() : Text(
                                ' • ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              ratings.length == 0 ? Text('No Reviews Yet!', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.red
                              ),) : Text(
                                '${ratingsNumbers.toStringAsFixed(1)} / 5.0',
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
                              category,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' • ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          PriceIconWidget(price: price,)
                          ],
                        )
                      ],
                    ))
              ],
            )
        )
    );
  }
}
