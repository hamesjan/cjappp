import 'dart:async';
import 'package:cjapp/widgets/plotserror.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/widgets/rating_stars.dart';
import 'package:location/location.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/services/BaseAuth.dart';
import 'package:cjapp/services/global_functions.dart';
import 'package:cjapp/pages/feed/chosen_event.dart';
import 'package:cjapp/pages/map_page/distance_calculator.dart';

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
  double burntRating;
  String byText;
  String description;
  List ratings;
  String website;
  String by;
  String plotLocation;
  double ratingsNumbers;
  String category;
  double myRadiusMeters = 40233.6;
  String price;

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }


   checkPermissions() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled)  {
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
    return
          FutureBuilder<Widget>(
            future: buildMap(context),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData ) {
                  return Stack(
                      children: <Widget>[
                      snapshot.data,
                       _buildContainer(),
                        _permissionGranted.toString() == 'PermissionStatus.granted'? _setRadius(): enableLocation()
                      ]
                  );
                }
                else if (snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: Container(width: 200, height:200,child: CircularProgressIndicator()));
                }else if (snapshot.connectionState == ConnectionState.none){
                  return Center(
                    child: Text(
                      'There are connectivity issues.\nPlease retry later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                else{
                  return PlotsError();
                }
              }
    );
  }

  Set<Circle> myCircle (lat, long, double myRadius){ return Set.from([Circle(
    circleId: CircleId('my circle'),
    center: LatLng(lat, long),
    radius: myRadius,
    strokeColor: Colors.pinkAccent,
    fillColor: Colors.pinkAccent.withOpacity(0.3),
    strokeWidth: 2
  )]);}

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
                  ratingsNumbers.toDouble(),
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

  Widget enableLocation(){
    return Align(
      alignment: Alignment.center,
        child:Container(
        padding: EdgeInsets.all(25),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white
            ),
            padding: EdgeInsets.all(16),
            child:  Text('Enable your location to access more features.', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21
            ),)
        )
        )
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

  Widget _setRadius(){
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        padding: EdgeInsets.all(10),
          child: new FittedBox(
            child: Material(
                color: Colors.white,
                elevation: 14.0,
                borderRadius: BorderRadius.circular(24.0),
                shadowColor: Color(0x802196F3),
                child: Container(
                    padding: EdgeInsets.all(8),
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Radius: ', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    DropdownButton<double> (
                      value: myRadiusMeters,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black,
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.pinkAccent,
                      ),
                      onChanged: (double newValue) {
                        setState(() {
                          myRadiusMeters = newValue;
                        });
                      },
                      items: <double>[16093.4,40233.6, 80467.2, 160934]
                          .map<DropdownMenuItem<double>>((double value) {
                        return DropdownMenuItem<double>(
                          value: value,
                          child: Text(getMiles(value).toStringAsFixed(0)),
                        );
                      }).toList(),
                    ),
                    Text('miles', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  ],)
                )
            ),
          ),
        ),
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
                      incrementLocalScore();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ChosenEvent(
                                name: name,
                                lat: lat,
                                fav: fav,
                                 byText: byText,
                                 burntRating: burntRating,
                                 description: description,
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
                                fromFeed: false,
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
                            maxHeight: 250,
                            minHeight: 250,
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
                      minHeight: 250,
                      minWidth: 250,
                      maxWidth: 250,
                      maxHeight: 250
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
                            Text('${ratingsNumbers.toString()} / 5.0', textAlign: TextAlign.center,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Row(children: <Widget>[
                                    Icon(Icons.local_fire_department,size: 22, color: Colors.redAccent,),
                                  ],),
                                ),
                                Text(burntRating.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                              ],
                            )
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
    final auth.FirebaseAuth _authFirebase = auth.FirebaseAuth.instance;
    if (_permissionGranted.toString() != 'PermissionStatus.granted') {
      var firestoredata = await _firestore.collection('plots').get();
      markerList.clear();
      receivedPlots.clear();
      firestoredata.docs.forEach((element) =>
          receivedPlots.add(element.data()));
      String username;
      if (_authFirebase.currentUser == null) {
        username = 'testUser1';
      } else {
       username = await returnUsername();
      }
      var resUsers = await _firestore.collection('users').doc(username).get();
      List currFavorites = resUsers.data()['favorites'];
      bool favorite = false;

      receivedPlots.forEach((element) {
        if (element['approved']) {
          if (currFavorites.contains(element['name'])) {
            favorite = true;
          }
          markerList.add(Marker(
            onTap: () {
              GoLocation(element['lat'], element['long']);
              setState(() {
                name = element['name'];
                zipCode = element['zipCode'];
                lat = element['lat'];
                burntRating = element['burntRating'];
                description = element['description'];
                byText = element['by_text'];
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
            position: LatLng(element['lat'], element['long']),
            // infoWindow: InfoWindow(title: element['name']),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ));
        }
      });
      return Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: GoogleMap(
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
                target: LatLng(34.0522, -118.2437),
                zoom: 10),
            markers: markerList.toSet(),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          )
      );
    } else  {
      Location location = new Location();
      LocationData _locationData = await location.getLocation();
      var firestoredata = await _firestore.collection('plots').get();
      markerList.clear();
      receivedPlots.clear();
      firestoredata.docs.forEach((element) =>
          receivedPlots.add(element.data()));


      // Getting Favorites

      String username;
      if (_authFirebase.currentUser == null) {
        username = 'testUser1';
      } else {
        username = await returnUsername();
      }

      var resUsers = await _firestore.collection('users').doc(username).get();
      List currFavorites = resUsers.data()['favorites'];
      bool favorite = false;

      receivedPlots.forEach((element) {
        if (getDist(
            _locationData.latitude, _locationData.longitude, element['lat'],
            element['long'], getMiles(myRadiusMeters))) {
          if (element['approved']) {
            if (currFavorites.contains(element['name'])) {
              favorite = true;
            }
            markerList.add(Marker(
              onTap: () {
                GoLocation(element['lat'], element['long']);
                setState(() {
                  name = element['name'];
                  zipCode = element['zipCode'];
                  lat = element['lat'];
                  burntRating = element['burntRating'];
                  imgLink = element['imgLink'];
                  description = element['description'];
                  byText = element['by_text'];
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
              position: LatLng(element['lat'], element['long']),
              // infoWindow: InfoWindow(title: element['name']),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue,
              ),
            ));
          }
        }
      });
      markerList.add(myMarker(_locationData.latitude, _locationData.longitude));

      return Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: GoogleMap(
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
              target: LatLng(_locationData.latitude, _locationData.longitude),
              zoom: 12),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          circles: myCircle(
              _locationData.latitude, _locationData.longitude, myRadiusMeters),
          markers: markerList.toSet(),
        ),
      );
    }
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


