import 'package:cjapp/widgets/thank_you.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cjapp/services/global_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/services/BaseAuth.dart';
import 'package:cjapp/services/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'package:intl/intl.dart';


class NewPlot extends StatefulWidget {
  @override
  _NewPlotState createState() => _NewPlotState();
}

class _NewPlotState extends State<NewPlot> {
  final _picker = ImagePicker();
  String price = 'Free';
  String category = 'Outdoors';
  String location;
  String private = 'Public';
  String errorMessage;
  String website;
  bool anon = false;
  String description = '';
  final _submitApplicationForm = GlobalKey<FormState>();
  final RoundedLoadingButtonController _submitButtonController = new RoundedLoadingButtonController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var _auth = Auth();
  String name;
  File _image;




  Future getImage()async{
    try {
      PickedFile image = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image.path);
      });
    } catch(e) {
      print(e.toString());
      setState(
            () {
          errorMessage = 'You need to enable image permissions.';
        },
      );
    }
  }

  void _startApplication() async {
    Timer(Duration(milliseconds: 300), () async{
      if (_submitApplicationForm.currentState.validate()) {
        uploadPlot();
      } else {
        _submitButtonController.reset();
        print(errorMessage);
      }
    });
  }

  Future<void> uploadPlot() async {
    try {
      String byText = 'Uploaded ${DateFormat('yMMMMd').format(DateTime.now())} by Anonymous';
      String username = await returnUsername();
      String timestamp = DateTime.now().toString();
      if (!anon) {
        byText = 'Uploaded ${DateFormat('yMMMMd').format(DateTime.now())} by $username';
      }
      var temp = false;
      if (private == 'Private'){
        temp = true;
      }
      auth.User _user = await _auth.getCurrentUser();
      await _firestore.collection('plots').doc(name).set({
        'name': name,
        'zipCode': 'To do',
        'location' : location,
        'timestamp': timestamp,
        'ratings': [],
        'ratingsNumbers': 0.0,
        'burntRating': 0.0,
        'website': website,
        'category': category,
        'private' : temp,
        'approved': false,
        'imgLink': '',
        'by_text': byText,
        'description': description.trim(),
        'lat': 0.0,
        'long': 0.0,
        'price': price,
        'by': _user.uid,
        'clicks': 0
      }).catchError((onError) => {print(onError.toString())});
      if (_image != null) {
        String filename = '$name.jpg';
        StorageReference firebaseStorageRef = FirebaseStorage.instance.ref()
            .child(filename);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      }
      // setState(() {
      //   print('uploaded successfully');
      //   Scaffold.of(givenContext).showSnackBar(SnackBar(content: Text('Uploaded'),));
      // });
      incrementLocalScore();

      // Updating user plots
      var sample1 = await _firestore.collection('users').doc(username).get();
      List currPlots = sample1.data()['plots'];
      currPlots.add(name);
      await _firestore.collection('users').doc(username).update({
        'plots': currPlots,
      }).catchError((onError) => {print(onError.toString())});



      _submitButtonController.success();
      Navigator.pop(context);
      Navigator.push(context,
      MaterialPageRoute(
        builder: (BuildContext context) => ThankYou()
      ));
    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      setState(
            () {
          errorMessage = e.toString();
        },
      );
    }
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
          : new Image.file(file, width: 200, height: 200, fit: BoxFit.fill,),
    );
  }

  String validateName(String value) {
    if (value == null || value.isEmpty) {
      return "Missing Name";
    }
    return null;
  }

  String validateLocation(String value) {
    if (value == null || value.isEmpty) {
      return "Missing Location";
    }
    return null;
  }


  String validateZip(String value) {
    if (value == null || value.isEmpty) {
      return "Missing Zip";
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit a plot.'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: (){
            Navigator.pop(context);
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
            Text('Photo permissions must be enabled.') ,
            RaisedButton(child: Text('Get Image'), onPressed:(){getImage();},elevation: 10, padding: EdgeInsets.all(5),),
            SizedBox(height: 10,),
            Divider(thickness: 2,),
            TextFormField(
                validator: (text) => validateName(text),
                onChanged: (value) => name = value,
                autocorrect: false,
                maxLines: null,
                toolbarOptions: ToolbarOptions(
                  copy: true,
                  paste: true,
                  selectAll: true,
                  cut: true,
                ),
                decoration: InputDecoration(
                    labelText: 'Plot Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    )
                )
            ),
            SizedBox(height: 10,),
            TextFormField(
                validator: (text) => validateLocation(text),
                onChanged: (value) => location = value,
                autocorrect: false,
                maxLines: null,
                toolbarOptions: ToolbarOptions(
                  copy: true,
                  paste: true,
                  selectAll: true,
                  cut: true,
                ),
                decoration: InputDecoration(
                    hintText: '1234 John Smith St. 90304',
                    labelText: 'Location',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    )
                )
            ),
            SizedBox(height: 10,),
            TextFormField(
                onChanged: (value) => description = value,
                autocorrect: false,
                maxLines: null,
                minLines: 3,
                toolbarOptions: ToolbarOptions(
                  copy: true,
                  paste: true,
                  selectAll: true,
                  cut: true,
                ),
                decoration: InputDecoration(
                    hintText: 'This place is lit!!!',
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    )
                )
            ),
            SizedBox(height: 10,),
            Divider(thickness: 2,),
            // TextFormField(
            //     onChanged: (value) => website = value,
            //     autocorrect: false,
            //     decoration: InputDecoration(
            //         icon: Icon(Icons.computer_sharp),
            //         hintText: 'Website',
            //         border: OutlineInputBorder(
            //             borderRadius: BorderRadius.all(Radius.circular(3))
            //         )
            //     )
            // ),
            // SizedBox(height: 10,),
            // TextFormField(
            //     validator: (text) => validateZip(text),
            //     onChanged: (value) => zipCode = value,
            //     autocorrect: false,
            //     decoration: InputDecoration(
            //         icon: Icon(Icons.location_city),
            //         hintText: 'Zip code',
            //         border: OutlineInputBorder(
            //             borderRadius: BorderRadius.all(Radius.circular(3))
            //         )
            //     )
            // ),
            // SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        MaterialColor(0xfff2a3f3, color),
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
                              color: MaterialColor(0xfff2a3f3, color),
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
                              color: MaterialColor(0xfff2a3f3, color),
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
                      Row(
                        children: [
                          Text('Discoverability', style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),),
                          SizedBox(width: 10,),
                          DropdownButton<String>(
                            value: private,
                            icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: MaterialColor(0xfff2a3f3, color),
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                private = newValue;
                              });
                            },
                            items: <String>['Public', 'Private']
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
              height: 10,
            ),
            private == 'Public' ?
            Row(children: [
              Expanded(child: Container(),),
              Text('Upload\nAnonymously',
                textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: 20
              ),),
              Checkbox(
                  value: anon,
                  activeColor: Colors.green,
                  onChanged:(bool newValue){
                    setState(() {
                      anon = newValue;
                    });
                  }),
              Expanded(child: Container(),),
            ],) : Container(),
            SizedBox(height: 5,),
            errorMessage != null
                ? Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            )
                : Container(),
            SizedBox(
              height: 20,
            ),
            RoundedLoadingButton(
              width: 200,
              errorColor: Colors.red,
              child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              controller: _submitButtonController,
              onPressed: _startApplication,
            ),
          ],
        ),
        ),
      ),
    );
  }
}
