import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

Future<Widget> noConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return Container();
   }
   } on SocketException catch (_) {
    return Container(
      child: Text('No Connection'),
    );
  }
}