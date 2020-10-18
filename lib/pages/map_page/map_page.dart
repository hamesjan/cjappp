import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/widgets/rating_stars.dart';
import 'package:location/location.dart';
import 'package:cjapp/pages/feed/chosen_event.dart';

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
  double lat;
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
                  price),
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


  Widget _boxes( name, zipCode, plotLocation, ratingsNumbers, ratings, website, category, by, price) {
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
                                zipCode: zipCode,
                                location: plotLocation,
                                ratingsNumbers: ratingsNumbers,
                                ratings: ratings,
                                website: website,
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
                  FutureBuilder(
                    future: _getImage(context, '$name.jpg'),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done)
                        return Container(
                          constraints: BoxConstraints(
                            maxHeight: 200,
                            minHeight: 200,
                          ),
                          child: ClipRRect(
                            borderRadius: new BorderRadius.circular(25.0),
                            child: snapshot.data,
                          ),
                        );
                      else if (snapshot.connectionState == ConnectionState.waiting)
                        return Container(
                          padding: EdgeInsets.all(16),
                          height: 200,
                          width: 200,
                          child: CircularProgressIndicator(),
                        );
                      else
                        return Container(
                          padding: EdgeInsets.all(16),
                          height: 200,
                          width: 200,
                          child: Text(
                              'The picture could not be found...\nCheck again later!'),
                        );
                    },
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
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              category,textAlign: TextAlign.center, style: TextStyle(
                              fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.blue
                            ),
                            ),
                          ),
                          SizedBox(height:5.0),
                          Row(children: [
                            Expanded(child: Container(),),
                            RatingStars(rating: ratingsNumbers,),
                            Expanded(child: Container(),),
                          ],),
                          SizedBox(height:5.0),
                          Text('${ratingsNumbers.toString()} / 5.0', textAlign: TextAlign.center,)

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
    receivedPlots.forEach((element) {
      if (element['approved']){
        markerList.add(Marker(
          onTap: (){
            GoLocation(element['lat'], element['long']);
            setState(() {
              name = element['name'];
              zipCode = element['zipCode'];
              lat = element['lat'];
              long = element['long'];
              plotLocation = element['location'];
              ratingsNumbers = element['ratingsNumbers'];
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


