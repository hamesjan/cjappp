import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/widgets/rating_stars.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/services/BaseAuth.dart';
import 'package:cjapp/pages/feed/chosen_event.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class MapPage extends StatefulWidget {
  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  double zoomVal = 5.0;
  bool _serviceEnabled;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  PermissionStatus _permissionGranted;
  Location location = new Location();
  List<Marker> markerList = [];
  List receivedPlots = [];
  String name;
  String zipCode;
  String imgLink;
  double lat;
  bool fav;
  double long;
  List ratings;
  String website;
  String by;
  String plotLocation;
  double ratingsNumbers;
  String category;
  String price;

  checkPermissions() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FutureBuilder<Widget>(
            future: buildMap(context),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              if(snapshot.hasData){
                return snapshot.data;
          }
              else {
                return Center(child: CircularProgressIndicator());
              }
          },
          ),
          _buildContainer(),
        ],
      ),
    );
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: name == null ? beforeSelect() : Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child:
        ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  name,
                  zipCode,
                  plotLocation,
                  ratingsNumbers,
                  ratings,
                  website,
                  category,
                  by,
                  price,
              imgLink),
            ),
          ],
        ),

      ),
    );
  }



  Widget beforeSelect(){
    return Container(
        padding: EdgeInsets.all(25),
        child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white
      ),
      padding: EdgeInsets.all(16),
      child:  Text('Select a marker!', style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 21
      ),)
    )
    );
  }


  Widget _boxes( name, zipCode, plotLocation, ratingsNumbers, ratings, website, category, by, price, imgLink) {
    return  GestureDetector(
      onTap: () {
        showDialog(context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Are you sure you want to leave map view?'),
                actions: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ChosenEvent(
                                name: name,
                                lat: lat,
                                fav: fav,
                                long: long,
                                zipCode: zipCode,
                                location: plotLocation,
                                ratingsNumbers: ratingsNumbers,
                                ratings: ratings,
                                website: website,
                                imgLink: imgLink,
                                category: category,
                                by: by,
                                price: price,
                              )));
                    },
                    icon: Icon(Icons.check, color: Colors.green, ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red,),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            }
        );
        },
      child:Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                 Container(
                          constraints: BoxConstraints(
                            maxHeight: 200,
                            minHeight: 200,
                          ),
                          child: ClipRRect(
                            borderRadius: new BorderRadius.circular(25.0),
                            child: Image(
                              image: NetworkImage(imgLink),
                            ),
                          ),
                        ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 200,
                      minWidth: 200,
                      maxWidth: 200,
                      maxHeight: 200
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Container(
                                child: Text(name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              category,textAlign: TextAlign.center, style: TextStyle(
                              fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blue
                            ),
                            ),
                          ),
                          ratings.length == 0 ? Container(
                            child: Text('No ratings available.', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red
                            ),),
                          ) :
                          Column(children: [
                            SizedBox(height:5.0),
                            Row(children: [
                              Expanded(child: Container(),),
                              RatingStars(rating: ratingsNumbers,),
                              Expanded(child: Container(),),
                            ],),
                            SizedBox(height:5.0),
                            Text('${ratingsNumbers.toString()} / 5.0', textAlign: TextAlign.center,)
                          ],)
                        ],
                      )
                    ),
                  ),
                ],)
          ),
        ),
      ),
    );
  }

  Future<Widget> buildMap(BuildContext context) async{
    Location location = new Location();
    LocationData _locationData = await location.getLocation();
    var firestoredata = await  _firestore.collection('plots').get();
    markerList.clear();
    receivedPlots.clear();
    firestoredata.docs.forEach((element) => receivedPlots.add(element.data()));


    // Getting Favorites
    var _auth = Auth();
    String username;
    auth.User _user = await _auth.getCurrentUser();
    var allUsers = await _firestore.collection('users').get();
    allUsers.docs.forEach((element) {
      if (element.data()['uid'] == _user.uid) {
        username = element.data()['username'];
      }
    });
    var resUsers = await _firestore.collection('users').doc(username).get();
    List currFavorites = resUsers.data()['favorites'];
    bool favorite = false;


    receivedPlots.forEach((element) {
      if (element['approved']){
        if(currFavorites.contains(element['name'])){
          favorite = true;
        }
        markerList.add(Marker(
          onTap: (){
            GoLocation(element['lat'], element['long']);
            setState(() {
              name = element['name'];
              zipCode = element['zipCode'];
              lat = element['lat'];
              imgLink = element['imgLink'];
              ratingsNumbers = element['ratingsNumbers'];
              long = element['long'];
              fav = favorite;
              plotLocation = element['location'];
              category = element['category'];
              price = element['price'];
              ratings = element['ratings'];
              by = element['by'];
            });
          },
          markerId: MarkerId(element['name']),
      position: LatLng(element['lat'],element['long']),
      // infoWindow: InfoWindow(title: element['name']),
      icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueBlue,
      ),
      ));
      }
    });
    markerList.add(myMarker(_locationData.latitude, _locationData.longitude));

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapType: MapType.normal,
        initialCameraPosition:  CameraPosition(target: LatLng(_locationData.latitude, _locationData.longitude), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markerList.toSet(),
      ),
    );
  }

  Future<void> GoLocation(double lat,double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 18,tilt: 50.0,
      bearing: 45.0,)));
  }

  Marker myMarker (lat, long) {
    return Marker(
      onTap: (){
        GoLocation(lat, long);
      },
      markerId: MarkerId('myMarker'),
      position: LatLng(lat, long),
      // infoWindow: InfoWindow(title: 'You are Here'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
  }

}


