import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cjapp/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:location/location.dart';

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
          // ZoomOut(),
          // ZoomIn(),
          _buildContainer(),
        ],
      ),
    );
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child:
        ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(
                  "https://www.traderjoes.com/Brandify/images/121-Torrance-Hawthorne-Blvd-storefront.jpg",
                  33.85226, -118.353,"Trader Joes", "Estimated Wait: 0 minutes"),
            ),
          ],
        ),

      ),
    );
  }

  Widget _boxes(String _image, double lat,double long,String restaurantName, String EWT) {
    return  GestureDetector(
      onTap: () {
        GoLocation(lat,long);
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
                    width: 180,
                    height: 200,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(_image),
                      ),
                    ),),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer1(restaurantName, EWT),
                    ),
                  ),
                ],)
          ),
        ),
      ),
    );
  }

  Widget ZoomIn() {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
          icon: Icon(Icons.zoom_out,color:Color(0xff6200ee)),
          onPressed: () {
            zoomVal--;
            _minus( zoomVal);
          }),
    );
  }
  Widget ZoomOut() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          icon: Icon(Icons.zoom_in,color:Color(0xff6200ee)),
          onPressed: () {
            zoomVal++;
            _plus(zoomVal);
          }),
    );
  }
  Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(33.8358, -118.3406), zoom: zoomVal)));
  }
  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(33.8358, -118.3406), zoom: zoomVal)));
  }

  Widget myDetailsContainer1(String restaurantName, String EWT) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(restaurantName,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              )),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            EWT, style: TextStyle(
              fontSize: 22,
              color: Colors.black
          ),
          ),
        ),
        SizedBox(height:5.0),
        Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    child: Text(
                      "3.7",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      ),
                    )),
                Container(
                  child: Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    Icons.star_half,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    Icons.star_border,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                    child: Text(
                      "(359)",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      ),
                    )),
              ],
            )),
        SizedBox(height:5.0),
        Container(
            child: Text(
              "Open \u00B7 8:00 A.M. - 9:00 P.M.",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            )),
      ],
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
          },
        markerId: MarkerId(element['name']),
      position: LatLng(element['lat'],element['long']),
      infoWindow: InfoWindow(title: element['name']),
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
      infoWindow: InfoWindow(title: 'You are Here'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueRed,
      ),
    );
  }

}


