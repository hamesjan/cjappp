import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:cjapp/services/BaseAuth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

Future<void> incrementLocalScore () async {
  final auth.FirebaseAuth _authFirebase = auth.FirebaseAuth.instance;
  if (_authFirebase.currentUser == null) {
    return;
  } else {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var _auth = Auth();
    String username;
    auth.User _user = await _auth.getCurrentUser();
    var allUsers = await _firestore.collection('users').get();
    allUsers.docs.forEach((element) {
      if (element.data()['uid'] == _user.uid) {
        username = element.data()['username'];
      }
    });
    try {
      var resPlots = await _firestore.collection('users').doc(username).get();
      var currNum = resPlots.data()['local_score'];
      await _firestore.collection('users').doc(username).update({
        'local_score': currNum + 1,
      }).catchError((onError) => {print(onError.toString())});
    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
  }
}

