import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/services/global_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LinkRequests extends StatefulWidget {
  final List linkRequests;

  const LinkRequests({Key key, this.linkRequests}) : super(key: key);
  @override
  _LinkRequestsState createState() => _LinkRequestsState();
}

class _LinkRequestsState extends State<LinkRequests> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Link Requests'),
      ),
      body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text('Once you link with a new Homie, they can view all of your private plots.'),
            ),
            Divider(thickness: 2,),
            widget.linkRequests.length == null || widget.linkRequests.length == 0 ?
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text('You have no requests.')
                ) :
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.linkRequests.length,
              itemBuilder: (BuildContext context, int index) {
                final item = widget.linkRequests[index];
                return Dismissible(
                key: Key(item),
                child:  Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(children: [
                    Container(child: Text(widget.linkRequests[index], style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),), padding: EdgeInsets.only(left: 16),),
                    Expanded(child: Container(),),
                    IconButton(
                        icon: Icon(Icons.check,color: Colors.green,),
                        onPressed: () async {
                          try {
                            String myUsername = await returnUsername();
                            var resUsers = await _firestore.collection('users').doc(myUsername).get();
                            var theirHomies = await _firestore.collection('users').doc(widget.linkRequests[index]).get();
                            List currRequests = resUsers.data()['link_requests'];
                            List currHomies = resUsers.data()['homies'];
                            List theirHomies1 = theirHomies.data()['homies'];
                            currRequests.remove(widget.linkRequests[index]);
                            currHomies.add(widget.linkRequests[index]);
                            theirHomies1.add(myUsername);
                            await _firestore.collection('users').doc(myUsername).update({
                              'link_requests': currRequests,
                              'homies' : currHomies
                            }).catchError((onError) => {print(onError.toString())});
                            await _firestore.collection('users').doc(widget.linkRequests[index]).update({
                              'homies' : theirHomies1,
                            }).catchError((onError) => {print(onError.toString())});
                            setState(() {
                              widget.linkRequests.removeAt(index);
                            });
                          } catch (e) {
                            Navigator.pop(context);
                          }

                        }
                    ),
                    IconButton(
                        icon: Icon(Icons.close, color: Colors.red,),
                        onPressed: ()async{
                          String myUsername = await returnUsername();
                          var resUsers = await _firestore.collection('users').doc(myUsername).get();
                          List currRequests = resUsers.data()['link_requests'];
                          currRequests.remove(widget.linkRequests[index]);
                          await _firestore.collection('users').doc(myUsername).update({
                            'link_requests': currRequests,
                          }).catchError((onError) => {print(onError.toString())});
                          setState(() {
                            widget.linkRequests.removeAt(index);
                          });
                        }
                    ),
                  ],),
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                ),
              );
    })
          ],
        ),
    );
  }
}
