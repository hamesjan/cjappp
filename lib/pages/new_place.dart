import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cjapp/widgets/custom_button.dart';
import 'package:cjapp/pages/home.dart';

class NewPlace extends StatefulWidget {
  @override
  _NewPlaceState createState() => _NewPlaceState();
}

class _NewPlaceState extends State<NewPlace> {
//  final FirebaseAuth _auth = FirebaseAuth.instance;
//  final Firestore _firestore = Firestore.instance;

  String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                onChanged: (value) => message = value,
                autocorrect: false,
                maxLines: null,
                decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))
                    )
                )
            ),
            SizedBox(
              height: 15,
            ),
            CustomButton(
              text: 'Post',
              callback: () {
                Navigator.pop(context);
                Navigator.push(context,
                MaterialPageRoute(
                  builder: (BuildContext context) => Home()
                ));
//                String temp;
//                FirebaseUser _user = await _auth.currentUser();
//
//                await _firestore.collection("users").getDocuments().then((querySnapshot) {
//                  querySnapshot.documents.forEach((result) {
//                    if (result['uid'] == _user.uid.toString()) {
//                      temp = result['username'];
//                    }
//                  });
//                });
//
//
//                await _firestore.collection('posts').add({
//                  'txt': message,
//                  'user' : temp
//                });
              },

            )
          ],
        ),
      ),
    );
  }
}
