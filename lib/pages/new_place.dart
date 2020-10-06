import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cjapp/widgets/custom_button.dart';
import 'package:cjapp/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/services/BaseAuth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class NewPlace extends StatefulWidget {
  @override
  _NewPlaceState createState() => _NewPlaceState();
}

class _NewPlaceState extends State<NewPlace> {
  String price = 'Moderate';
  String category = 'Outdoors';
  String location;
  String zipCode;
  String errorMessage;
  String website;
  final _submitApplicationForm = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var _auth = Auth();
  String name;
  File _image;


  Future getImage()async{
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<void> uploadPlot() async {
    try {
      auth.User _user = await _auth.getCurrentUser();
      await _firestore.collection('plots').doc(name).set({
        'name': name,
        'zipCode': zipCode,
        'location' : location,
        'radius' : null,
        'ratings': [],
        'ratingsNumbers': 0.0,
        'website': website,
        'category': category,
        'approved': false,
        'coords': null,
        'price': price,
        'by': _user.uid,
      }).catchError((onError) => {print(onError.toString())});

      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => Home()));
    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      setState(
            () {
          errorMessage = e.message;
        },
      );
    }
  }

  Future uploadImage(BuildContext context) async{
    String filename = '$name.jpg';
    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      print('uplaoded Succesfully');
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Uploaded'),));
    });
  }

  Widget displaySelectedFile(File file) {
    return new ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.0),
        topRight: Radius.circular(8.0),
      ),
      child: file == null
          ? new Image(image: AssetImage(
          'assets/images/no-image-available.png.jpeg'
      ),)
          : new Image.file(file, width: 300, height: 300, fit: BoxFit.fill,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit an Application'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: (){
            Navigator.pop(context);
            Navigator.push(context,
            MaterialPageRoute(
              builder: (BuildContext context) => Home()
            ));
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _submitApplicationForm,
    child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            displaySelectedFile(_image),
            TextFormField(
                onChanged: (value) => name = value,
                autocorrect: false,
                maxLines: null,
                decoration: InputDecoration(
                    icon: Icon(Icons.tag),
                    hintText: 'Plot Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    )
                )
            ),
            SizedBox(height: 10,),
            TextFormField(
                onChanged: (value) => location = value,
                autocorrect: false,
                maxLines: null,
                decoration: InputDecoration(
                    icon: Icon(Icons.map),
                    hintText: 'Location',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    )
                )
            ),
            SizedBox(height: 10,),
            TextFormField(
                onChanged: (value) => website = value,
                autocorrect: false,
                decoration: InputDecoration(
                    icon: Icon(Icons.computer_sharp),
                    hintText: 'Website',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    )
                )
            ),
            SizedBox(height: 10,),
            TextFormField(
                onChanged: (value) => zipCode = value,
                autocorrect: false,
                decoration: InputDecoration(
                    icon: Icon(Icons.location_city),
                    hintText: 'Zip code',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    )
                )
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.pinkAccent,
                        Colors.white10
                      ]
                  )
              ),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: [
                      Row(
                        children: [
                          Text('Category', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),),
                          SizedBox(width: 10,),
                          DropdownButton<String> (
                            value: category,
                            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black,
                            ),
                            underline: Container(
                              height: 2,
                              color: Colors.pinkAccent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                category = newValue;
                              });
                            },
                            items: <String>[ 'Outdoors', 'Indoors', 'Action', 'Urban', 'View', 'Other']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Price', style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),),
                          SizedBox(width: 10,),
                          DropdownButton<String>(
                            value: price,
                            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.pinkAccent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                price = newValue;
                              });
                            },
                            items: <String>['Free', 'Cheapest', 'Moderate', 'Expensive']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            CustomButton(
              text: 'Submit',
              callback: () {
                uploadPlot();

              },
            )
          ],
        ),
        ),
      ),
    );
  }
}
