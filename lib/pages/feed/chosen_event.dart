import 'package:cjapp/pages/feed/all_reviews.dart';
import 'package:cjapp/pages/login/login.dart';
import 'package:cjapp/pages/view_profile/view_user_profile.dart';
import 'package:cjapp/services/global_functions.dart';
import 'package:share/share.dart';
import 'package:firebase_admob/firebase_admob.dart';
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

// const String testDevice = 'AEF6DE53-7481-4037-B60E-37B5AE065D58[37493]';
const String testDevice = '8CB7D76E-52F4-44E3-A581-61FBD3D38BEC';

class ChosenEvent extends StatefulWidget {
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

  const ChosenEvent({Key key, this.fromFeed, this.name, this.zipCode, this.location, this.ratingsNumbers, this.burntRating, this.lat, this.long, this.byText, this.description, this.imgLink, this.ratings, this.fav, this.website, this.category, this.by, this.price}) : super(key: key);

  @override
  _ChosenEventState createState() => _ChosenEventState();
}

class _ChosenEventState extends State<ChosenEvent> {
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>['Entertainment', 'Plots', 'Los Angeles', 'Restaurants']
  );

  // BannerAd _bannerAd;
  // BannerAd createBannerAd(){
  //   return BannerAd(adUnitId: 'ca-app-pub-1671319682516251/1543231558',
  //       size: AdSize.banner,
  //     targetingInfo: targetingInfo,
  //
  //     listener: (MobileAdEvent event){
  //       print('BannerAd $event');
  //     }
  //   );
  // }
  //
  // @override
  // void initState(){
  //   FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-1671319682516251~7637527304');
  //   _bannerAd = createBannerAd()..load()..show(
  //     anchorType: AnchorType.bottom,
  //   );
  //   super.initState();
  // }
  //
  // @override
  // void dispose(){
  //   _bannerAd.dispose();
  //   super.dispose();
  // }

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
          currFavorites.add(widget.name);
          await _firestore.collection('users').doc(element.data()['username']).update({
            'favorites': currFavorites,
          }).catchError((onError) => {print(onError.toString())});
        }
      });

        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChosenEvent(
        name: widget.name,
        zipCode: widget.zipCode,
        location: widget.location,
        ratingsNumbers: widget.ratingsNumbers,
        ratings: widget.ratings,
        burntRating: widget.burntRating,
        fromFeed: widget.fromFeed,
        byText: widget.byText,
        description: widget.description,
        lat: widget.lat,
        long: widget.long,
        fav: true,
        imgLink: widget.imgLink,
        website: widget.website,
        category: widget.category,
        by: widget.by,
        price: widget.price,
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
          currFavorites.remove(widget.name);
          await _firestore.collection('users').doc(element.data()['username']).update({
            'favorites': currFavorites,
          }).catchError((onError) => {print(onError.toString())});

        }
      });
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChosenEvent(
        name: widget.name,
        zipCode: widget.zipCode,
        location: widget.location,
        ratingsNumbers: widget.ratingsNumbers,
        ratings: widget.ratings,
        burntRating: widget.burntRating,
        fromFeed: widget.fromFeed,
        byText: widget.byText,
        description: widget.description,
        lat: widget.lat,
        long: widget.long,
        fav: false,
        imgLink: widget.imgLink,
        website: widget.website,
        category: widget.category,
        by: widget.by,
        price: widget.price,
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
        title: Text(widget.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            if (!widget.fromFeed) {
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
                imageUrl: widget.imgLink,
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
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                widget.name,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.pink,
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(children: [
                              Text(
                                widget.category,
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
                              PriceIconWidget(price: widget.price,)

                            ],),
                          ],),
                        Expanded(child: Container(),),
                        Container(
                            child: IconButton(icon: Icon(Icons.share), onPressed: (){
                              Share.share('Check out ${widget.name} on plots! https://www.google.com/maps/search/?api=1&query=${widget.lat},${widget.long}', subject: '${widget.name}');
                            })
                        ),
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

                            widget.fav ? IconButton(icon: Icon(Icons.bookmark), onPressed: (){
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
                    InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      onTap: () async{
                        if (widget.byText.split(' ')[5] == 'Anonymous'){
                        } else {
                          final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                          String str;
                          var allUsers = await _firestore.collection('users').get();
                          allUsers.docs.forEach((element) {
                            if (element.data()['uid'] == widget.by) {
                              str = element.data()['username'];
                            }
                          });
                          // Check homie status
                          String myUsername = await returnUsername();
                          var resUsers = await _firestore.collection('users').doc(str).get();
                          List currRequests = resUsers.data()['link_requests'];
                          List currHomies = resUsers.data()['homies'];
                          if(currRequests.contains(myUsername)){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) => ViewProfile(
                              username: str,
                              homieStatus: 'pending',
                            ),
                            )
                            );
                          } else if (currHomies.contains(myUsername)){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) => ViewProfile(
                                username: str,
                                homieStatus: 'yes',
                              ),
                            )
                            );
                          } else {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) => ViewProfile(
                                username: str,
                                homieStatus: 'no',
                              ),
                            )
                            );
                          }
                        }
                      },
                      child: Ink(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: Row(
                              children: <Widget>[
                                widget.byText.split(' ')[5] == 'Anonymous' ?  Icon(
                                  Icons.face,
                                  color: Colors.red,
                                ) :  Icon(
                                  Icons.face,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 1.5,
                                  child: Text(
                                    widget.byText,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.blue,

                                        fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          )
                      ),
                    ),
                    widget.description.isEmpty || widget.description == null ? Container():
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
                            widget.description,
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
                                    widget.ratings.length == 0 ? Text('No Ratings Yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),) : Text(widget.burntRating.toStringAsFixed(2), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
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
                    Divider(thickness: 2,),
                    SizedBox(width: 10,),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          widget.ratings.length == 0 ? Container() :
                          Column(
                            children: [
                              RatingStars(rating: widget.ratingsNumbers),
                              Text( '${widget.ratingsNumbers.toStringAsFixed(1)} / 5.0',)
                            ],
                          ),
                          widget.ratings.length == 0
                              ? Container()
                              : SizedBox(
                            width: 5,
                          ),
                          widget.ratings.length == 0
                              ? Container()
                              : Text(
                            '( ${widget.ratings.length} )',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          widget.ratings.length == 0 ? Container() : SizedBox(
                            width: 15,
                          ),
                          widget.ratings.length == 0
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
                                              fromFeed: widget.fromFeed,
                                              by: widget.by,
                                              name: widget.name,
                                            )
                                    ));
                              }
                            },
                            child: Ink(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(color: Colors.redAccent,
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
                                              by: widget.by,
                                              fromFeed: widget.fromFeed,
                                              name: widget.name,
                                            )
                                    ));
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

                    ),
                    widget.ratings.length > 0 ? SizedBox(
                      height: 10,
                    ) : Container(),
                    widget.ratings.length > 0 ? Text('"${widget.ratings[0]['review']}"\n- ${widget.ratings[0]['by']}', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),) : Container(),
                    widget.ratings.length > 1 ? SizedBox(height: 5,) : Container(),
                    widget.ratings.length > 1 ? Divider(thickness: 2,) : Container(),
                    widget.ratings.length > 1 ? SizedBox(height: 5,) : Container(),
                    widget.ratings.length > 1 ? Text('"${widget.ratings[1]['review']}"\n- ${widget.ratings[1]['by']}', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),) : Container(),
                    SizedBox(height: 10,),
                    Divider(thickness: 2,),
                    widget.ratings.length > 2 ? FlatButton(
                      child: Text('More Reviews', style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.blue
                      ),),
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => AllReviews(
                                  ratings: widget.ratings,
                                  name: widget.name,
                                )
                            ));
                      },
                    ): Container(),
                    Text('Location', style: TextStyle(
                        fontSize: 22,
                        color: Colors.pink,
                        fontWeight: FontWeight.bold
                    ),),
                    SizedBox(height: 5,),
                    Text('Click to access location', style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                    InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      onTap: () {
                        MapUtils.openMap(widget.lat,widget.long);
                      },
                      child: Ink(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
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
                                widget.location,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        )
                      ),
                    ),
                    Container(height: 100,)
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




