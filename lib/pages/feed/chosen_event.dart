import 'package:cjapp/pages/feed/plots_web_view.dart';
import 'package:cjapp/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/widgets/price_icon_widget.dart';
import 'package:cjapp/pages/home.dart';
import 'package:cjapp/pages/feed/new_review.dart';
import 'package:cjapp/services/launch_google_map.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/services/BaseAuth.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:cjapp/widgets/rating_stars.dart';

class ChosenEvent extends StatelessWidget {
  final String name;
  final String zipCode;
  final String location;
  final double ratingsNumbers;
  final double lat;
  final double long;
  final String imgLink;
  final List ratings;
  final bool fav;
  final String website;
  final String category;
  final String by;
  final String price;

  const ChosenEvent(
      {Key key,
      this.name,
      this.zipCode,
        this.imgLink,
      this.location,
      this.by,
        this.fav,
      this.ratingsNumbers,
        this.lat,
        this.long,
      this.ratings,
      this.website,
      this.category,
      this.price})
      : super(key: key);

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
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChosenEvent(
        name: name,
        zipCode: zipCode,
        location: location,
        ratingsNumbers: ratingsNumbers,
        ratings: ratings,
        imgLink: imgLink,
        website: website,
        long: long,
        lat: lat,
        fav: true,
        category: category,
        by: by,
        price: price,
      )));
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
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChosenEvent(
        name: name,
        zipCode: zipCode,
        location: location,
        ratingsNumbers: ratingsNumbers,
        ratings: ratings,
        imgLink: imgLink,
        website: website,
        long: long,
        lat: lat,
        fav: false,
        category: category,
        by: by,
        price: price,
      )));
    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => Home()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxHeight: 350,
                minHeight: 350,
              ),
              child: OptimizedCacheImage(
                imageUrl: imgLink,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(25),
                      bottomLeft: Radius.circular(25)
                    ),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text(
                            name,
                            style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Row(children: [
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

                          ],)
                        ],),
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
                    Divider(
                      thickness: 3,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: <Widget>[
                        ratings.length == 0 ? Container() :RatingStars(rating: ratingsNumbers),
                        ratings.length == 0
                            ? Container()
                            : SizedBox(
                                width: 5,
                              ),
                        ratings.length == 0
                            ? Container()
                            : Text(
                                '${ratings.length} Ratings',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                        SizedBox(
                          width: 15,
                        ),
                        ratings.length == 0
                            ? InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              NewReview(
                                                by: by,
                                                name: name,
                                              )));
                                },
                                child: Ink(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: Colors.lightBlueAccent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          'Be the first review!',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                              )
                            : InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              NewReview(
                                                by: by,
                                                name: name,
                                              )));
                                },
                                child: Ink(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.lightBlueAccent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(thickness: 2,),
                    InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      onTap: () {
                        MapUtils.openMap(lat,long);
                      },
                      child: Ink(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.room,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                location,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ratings.length == 0 ? Container() : Divider(thickness: 2,),
                    ratings.length == 0 ? Container() : Text('Reviews', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),),
                    ratings.length > 0 ? Text('"${ratings[0]['review']}"\n- ${ratings[0]['by']}', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                    ),) : Container(),
                    ratings.length > 1 ? Divider(thickness: 2,) : Container(),
                    ratings.length > 1 ? SizedBox(height: 10,) : Container(),
                    ratings.length > 1 ? Text('"${ratings[1]['review']}"\n- ${ratings[1]['by']}', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),) : Container(),
                    Divider(thickness: 2,),
                    SizedBox(height: 10,),
                    website == '' ?
                    CustomButton(
                      text: 'Buy Ticket',
                      callback: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PlotsWebView()));
                      },
                    ) : Container()
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class GetFirebaseImage extends ChangeNotifier {
  GetFirebaseImage();

  static Future<dynamic> loadFromStorage(
      BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}
