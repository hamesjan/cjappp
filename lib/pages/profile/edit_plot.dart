import 'package:cjapp/widgets/thank_you.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:cjapp/services/app_colors.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:flutter/services.dart';
import 'package:cjapp/services/global_functions.dart';


class EditPlot extends StatefulWidget {
  final String description;
  final bool approval;
  final String name;
  final String category;
  final String imgLink;
  final bool private;
  final String location;
  final String price;

  const EditPlot({
    Key key,
    this.description,
    this.approval,
    this.name,
    this.imgLink,
    this.private,
    this.category,
    this.location,
    this.price,
  }) : super(key: key);

  @override
  _EditPlotState createState() => _EditPlotState();
}

class _EditPlotState extends State<EditPlot> {
  final _editPlotForm = GlobalKey<FormState>();
  final RoundedLoadingButtonController _changeUsernameButtonController = new RoundedLoadingButtonController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String newName;
  String newLocation;
  String newDescription = '';
  String errorMessage;
  String newDiscoverability = 'Public';
  String newPrice;
  String newCategory;

  @override
  void initState() {
    super.initState();
    setState(() {
      newDiscoverability = widget.private ? 'Private' : 'Public';
      newName = widget.name;
      newLocation = widget.location;
      newDescription = widget.description;
      newPrice = widget.price;
      newCategory = widget.category;
    });
  }



  Future<void> changeName() async {
    showDialog(context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Save Edit?'),
            actions: <Widget>[
              IconButton(
                onPressed: () async {
                  try {
                    bool taken = false;
                    var takenNames = await _firestore.collection('plots').get();
                    takenNames.docs.forEach((element) {
                      if (element.data()['name'] == newName && newName != widget.name){
                        taken = true;
                      }
                    });
                    if(taken){
                      _changeUsernameButtonController.reset();
                      setState(
                            () {
                          errorMessage = 'Sorry, that name is taken.';
                        },
                      );
                    } else {
                      var temp = false;
                      if (newDiscoverability == 'Private'){
                        temp = true;
                      }

                      await _firestore.collection('plots').doc(widget.name).update({
                        'name': newName,
                        'description': newDescription,
                        'category': newCategory,
                        'price': newPrice,
                        'private' : temp,
                        'location': newLocation,
                      });
                      var resUsers = await _firestore.collection('plots').doc(widget.name).get();
                      Map<String,dynamic> holder = resUsers.data();
                      await _firestore.collection('plots').doc(newName).set(holder);
                      if(newName != widget.name){
                        await _firestore.collection('plots').doc(widget.name).delete();
                      }
                      // Updating user plots
                      var username = await returnUsername();
                      var sample1 = await _firestore.collection('users').doc(username).get();
                      List currPlots = sample1.data()['plots'];
                      currPlots.remove(widget.name);
                      currPlots.add(newName);
                      await _firestore.collection('users').doc(username).update({
                        'plots': currPlots,
                      }).catchError((onError) => {print(onError.toString())});

                      _changeUsernameButtonController.success();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ThankYou()
                      ));
                    }
                  } on PlatformException catch (e) {
                    print(e);
                  } catch (e) {
                    _changeUsernameButtonController.reset();
                    setState(
                          () {
                        errorMessage = e.message;
                      },
                    );
                  }
                },
                icon: Icon(Icons.edit, color: Colors.green,),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: (){
                  _changeUsernameButtonController.reset();
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );

  }

  void _startLogin() async {
    Timer(Duration(milliseconds: 300), () async{
      if (_editPlotForm.currentState.validate()) {
        changeName();
      } else {
        _changeUsernameButtonController.reset();
      }
    });
  }

  String validateUsername(String value) {
    if (value == null || value.isEmpty) {
      return "Name is invalid.";
    }
    return null;
  }


  String validateLocation(String value) {
    if (value == null || value.isEmpty) {
      return "Location is invalid.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit ${widget.name}'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: (){
              Navigator.pop(context);

            },
          ),
        ),
        body: SingleChildScrollView(
    child: Column(
      children: [
    widget.approval ?  Container(
          constraints: BoxConstraints(
            maxHeight: 250,
            minHeight: 250,
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
          )
        ):Container(padding:EdgeInsets.all(16),
    child: Text('Waiting for approval.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),),
        Container(
          padding: EdgeInsets.all(16),
          child:Form(
            key: _editPlotForm,
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Text('Name', style: TextStyle(
                    fontSize: 22
                ),),
                TextFormField(
                    maxLines: null,
                    toolbarOptions: ToolbarOptions(
                      copy: true,
                      paste: true,
                      selectAll: true,
                      cut: true,
                    ),
                    initialValue: widget.name,
                    validator: (text) => validateUsername(text),
                    onChanged: (value) => newName = value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                    )),
                Text('Description', style: TextStyle(
                    fontSize: 22
                ),),
                TextFormField(
                    toolbarOptions: ToolbarOptions(
                      copy: true,
                      paste: true,
                      selectAll: true,
                      cut: true,
                    ),
                    maxLines: null,
                    minLines: 3,
                    initialValue: widget.description,
                    onChanged: (value) => newDescription = value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                    )),
                Text('Location', style: TextStyle(
                    fontSize: 22
                ),),
                TextFormField(
                    toolbarOptions: ToolbarOptions(
                      copy: true,
                      paste: true,
                      selectAll: true,
                      cut: true,
                    ),
                    maxLines: null,
                    initialValue: widget.location,
                    validator: (text) => validateLocation(text),
                    onChanged: (value) => newLocation = value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                    )),
                SizedBox(height: 10,),
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
                                value: newCategory,
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
                                    newCategory = newValue;
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
                                value: newPrice,
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
                                    newPrice = newValue;
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
                                value: newDiscoverability,
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
                                    newDiscoverability = newValue;
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
                errorMessage != null
                    ? Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                RoundedLoadingButton(
                  width: 200,
                  errorColor: Colors.red,
                  child: Text('Save Edit', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  controller: _changeUsernameButtonController,
                  onPressed: _startLogin,
                ),
              ],
            ),
          ),
        ),

      ],
          )
        )
    );
  }
}
