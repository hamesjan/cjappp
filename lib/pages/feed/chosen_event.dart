import 'package:cjapp/pages/feed/plots_web_view.dart';
import 'package:cjapp/pages/login/login.dart';
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
  final bool fromFeed;
  final String name;
  final String zipCode;
  final String location;
  final double ratingsNumbers;
  final double burntRating;
  final double lat;
  final double long;
  final String byText;
  final String description;
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
        this.fromFeed,
      this.zipCode,
        this.imgLink,
      this.location,
        this.burntRating,
        this.description,
        this.byText,
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
    final auth.FirebaseAuth _authFirebase = auth.FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
              Navigator.pop(context);
              if (!fromFeed) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) => Home()));
              }
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
                            Container(
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: Text(
                                name,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.pink,
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          Row(children: [
                            Text(
                              category,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '  • ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            PriceIconWidget(price: price,)

                          ],),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.3,
                              child: Text(
                                byText,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),

                        ],),
                        Expanded(child: Container(),),
                        _authFirebase.currentUser == null ?  Container(
                            child: IconButton(icon: Icon(Icons.bookmark_border), onPressed: (){
                              showDialog(context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('You must log in to bookmark.'),
                                      actions: <Widget>[
                                        IconButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext context) => Login()
                                                ));
                                          },
                                          icon: Icon(Icons.login, color: Colors.green,),
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
                        ) : Container(
                          child:

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
                        )
                      ],
                    ),
                    description.isEmpty ? Container():
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          thickness: 3,
                        ),
                        Text('Description', style: TextStyle(
                            fontSize: 22,
                            color: Colors.pink,
                            fontWeight: FontWeight.bold
                        ),),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: Text(
                            description,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(

                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 3,),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text('Burnt Rating', style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold
                              ),),
                              Row(children: [
                                Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: Row(children: <Widget>[
                                        Icon(Icons.local_fire_department,size: 55, color: Colors.redAccent,),
                                      ],),
                                    ),
                                    ratings.length == 0 ? Text('No Ratings Yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),) : Text(burntRating.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.info_outline),
                                  onPressed: (){
                                    showDialog(context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Column(
                                              children: [
                                                Text('A "burnt" rating dictates how populous a plot is.'),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text('Lowkey', style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    ),),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Icon(Icons.local_fire_department, color: Colors.red,),
                                                                Text('1'),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Icon(Icons.local_fire_department, color: Colors.red,),
                                                                Text('2'),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Icon(Icons.local_fire_department, color: Colors.red,),
                                                                Text('3'),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Icon(Icons.local_fire_department, color: Colors.red,),
                                                                Text('4'),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Icon(Icons.local_fire_department, color: Colors.red,),
                                                                Text('5'),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        Icon(Icons.switch_left_sharp)
                                                      ],
                                                    ),
                                                    Text('Saturated', style: TextStyle(
                                                        fontWeight: FontWeight.bold
                                                    ))
                                                  ],)

                                              ],
                                            ),
                                            actions: <Widget>[
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
                                  },
                                ),
                              ],),
                            ],
                          )
                        ],
                      ),
                    ),
                    Divider(thickness: 3,),
                    Row(
                      children: <Widget>[
                        Text('Reviews', style: TextStyle(
                            fontSize: 22,
                            color: Colors.pink,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(width: 10,),
                        ratings.length == 0 ? Container() : RatingStars(rating: ratingsNumbers),
                        ratings.length == 0
                            ? Container()
                            : SizedBox(
                                width: 5,
                              ),
                        ratings.length == 0
                            ? Container()
                            : Text(
                                '${ratings.length} Reviews',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                        ratings.length == 0 ? Container() : SizedBox(
                          width: 15,
                        ),
                        ratings.length == 0
                            ? InkWell(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                onTap: () {
                                  if (_authFirebase.currentUser == null) {
                                    showDialog(context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('You must log in to leave a review.'),
                                            actions: <Widget>[
                                              IconButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext context) => Login()
                                                      ));
                                                },
                                                icon: Icon(Icons.login, color: Colors.green,),
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
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                NewReview(
                                                  fromFeed: fromFeed,
                                                  by: by,
                                                  name: name,
                                                )));
                                  }
                                },
                                child: Ink(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          'Be the first rating!',
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
                                  if (_authFirebase.currentUser == null ){
                                    showDialog(context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('You must log in to leave a review.'),
                                            actions: <Widget>[
                                              IconButton(
                                                onPressed: (){
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext context) => Login()
                                                      ));
                                                },
                                                icon: Icon(Icons.login, color: Colors.green,),
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
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                NewReview(
                                                  by: by,
                                                  fromFeed: fromFeed,
                                                  name: name,
                                                )));
                                  }
                                },
                                child: Ink(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.redAccent,
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
                    ratings.length > 0 ?SizedBox(
                      height: 10,
                    ) : Container(),
                    ratings.length > 0 ? Text('"${ratings[0]['review']}"\n- ${ratings[0]['by']}', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),) : Container(),
                    ratings.length > 1 ? SizedBox(height: 5,) : Container(),
                    ratings.length > 1 ? Divider(thickness: 2,) : Container(),
                    ratings.length > 1 ? SizedBox(height: 5,) : Container(),
                    ratings.length > 1 ? Text('"${ratings[1]['review']}"\n- ${ratings[1]['by']}', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),) : Container(),
                    SizedBox(height: 10,),
                    Divider(thickness: 2,),
                    Text('Location', style: TextStyle(
                        fontSize: 22,
                        color: Colors.pink,
                        fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 5,),
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
                    // website == '' ?
                    // CustomButton(
                    //   text: 'Buy Ticket',
                    //   callback: () {
                    //     Navigator.pop(context);
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (BuildContext context) =>
                    //                 PlotsWebView()));
                    //   },
                    // ) : Container()
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
