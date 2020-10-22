import 'package:cjapp/pages/feed/plots_web_view.dart';
import 'package:cjapp/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/widgets/price_icon_widget.dart';
import 'package:cjapp/pages/home.dart';
import 'package:cjapp/pages/feed/new_review.dart';
import 'package:cjapp/services/launch_google_map.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cjapp/widgets/rating_stars.dart';

class ChosenEvent extends StatelessWidget {
  final String name;
  final String zipCode;
  final String location;
  final double ratingsNumbers;
  final double lat;
  final double long;
  final List ratings;
  final String website;
  final String category;
  final String by;
  final String price;

  const ChosenEvent(
      {Key key,
      this.name,
      this.zipCode,
      this.location,
      this.by,
      this.ratingsNumbers,
        this.lat,
        this.long,
      this.ratings,
      this.website,
      this.category,
      this.price})
      : super(key: key);


  Future<Widget> _getImage(BuildContext context, String image) async {
    Image m;
    await GetFirebaseImage.loadFromStorage(context, image).then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
      );
    });

    return m;
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
            FutureBuilder(
              future: _getImage(context, '$name.jpg'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                  return Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(50, 30),
                            bottomRight: Radius.elliptical(50, 30)),
                        child: snapshot.data,
                      ));
                else if (snapshot.connectionState == ConnectionState.waiting)
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                else
                  return Container(
                    padding: EdgeInsets.all(16),

                    child: Text(
                        'The picture could not be found...\nCheck again later!'),
                  );
              },
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
                        Icon(Icons.bookmark_border, size: 30,)
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
