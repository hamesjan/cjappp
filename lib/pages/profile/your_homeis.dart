import 'package:cjapp/pages/search/search_homies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/services/global_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/widgets/plotserror.dart';

class HomiesList extends StatefulWidget {
  final List homies;

  const HomiesList({Key key, this.homies}) : super(key: key);
  @override
  _HomiesListState createState() => _HomiesListState();
}

class _HomiesListState extends State<HomiesList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List receivedHomies = [];
  List homieNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Homies'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              showSearch(
                  context: context,
                  delegate: SearchHomies(
                      homieNames, receivedHomies));
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: _firestore.collection('users').get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              receivedHomies.clear();
              homieNames.clear();
              snapshot.data.docs.forEach((element) => receivedHomies.add(element.data()));
              receivedHomies.forEach((element) {
                homieNames.add(element['username']);
              });

              return widget.homies.length == null || widget.homies.length == 0 ?
                      Container(
                          padding: EdgeInsets.all(16),
                          child: Text('You have no Homies.')
                      ) :
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.homies.length,
                          itemBuilder: (BuildContext context, int index) {
                            final item = widget.homies[index];
                            return Dismissible(
                              key: Key(item),
                              child:  Container(
                                width: MediaQuery.of(context).size.width,
                                child: Row(children: [
                                  Container(child: Text(widget.homies[index], style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                  ),), padding: EdgeInsets.only(left: 16),),
                                  Expanded(child: Container(),),
                                  IconButton(
                                      icon: Icon(Icons.link_off,color: Colors.red,),
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:Text('Are you sure you want to unlink with ${widget.homies[index]}?'),
                                                actions: <Widget>[
                                                  IconButton(
                                                    icon: Icon(Icons.link_off, color: Colors.red,),
                                                    onPressed: ()async {
                                                      try {
                                                        String myUsername = await returnUsername();
                                                        var resUsers = await _firestore
                                                            .collection('users')
                                                            .doc(myUsername)
                                                            .get();
                                                        var theirHomies = await _firestore
                                                            .collection('users')
                                                            .doc(widget
                                                            .homies[index])
                                                            .get();
                                                        List currHomies = resUsers
                                                            .data()['homies'];
                                                        List theirHomies1 = theirHomies
                                                            .data()['homies'];
                                                        currHomies.remove(widget
                                                            .homies[index]);
                                                        theirHomies1.remove(
                                                            myUsername);
                                                        await _firestore
                                                            .collection('users')
                                                            .doc(myUsername)
                                                            .update({
                                                          'homies': currHomies
                                                        })
                                                            .catchError((
                                                            onError) =>
                                                        {
                                                          print(onError
                                                              .toString())
                                                        });
                                                        await _firestore
                                                            .collection('users')
                                                            .doc(widget
                                                            .homies[index])
                                                            .update({
                                                          'homies': theirHomies1,
                                                        })
                                                            .catchError((
                                                            onError) =>
                                                        {
                                                          print(onError
                                                              .toString())
                                                        });
                                                        setState(() {
                                                          widget.homies
                                                              .removeAt(index);
                                                        });
                                                        Navigator.pop(context);
                                                      } catch (e) {
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.close),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                      }
                                  ),
                                ],),
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                              ),
                            );
                          });
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Container(width: 200, height:200,child: CircularProgressIndicator()));
            } else if (snapshot.connectionState == ConnectionState.none){
              return Center(
                child: Text(
                  'There are connectivity issues.\nPlease retry later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              );
            }else {
              return PlotsError();

            }
          }),
    );
  }
}
