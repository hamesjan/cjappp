import 'package:cjapp/pages/profile/plot_widget.dart';
import 'package:cjapp/widgets/plotserror.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YourPlots extends StatefulWidget {
  final List plots;

  const YourPlots({Key key, this.plots}) : super(key: key);

  @override
  _YourPlotsState createState() => _YourPlotsState();
}

class _YourPlotsState extends State<YourPlots> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future getInformation() async {
    List info = [];

    var receivedPlots = await _firestore.collection('plots').get();
    receivedPlots.docs.forEach((element) {
      if (widget.plots.contains(element.data()['name'])) {
        info.add(element.data());
      }
    });
    return info;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Plots'),
      ),
      body: FutureBuilder(
          future: getInformation(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0){
                return Center(
                  child: Text('No plots found.', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22
                  ),),
                );
              }else {
                return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PlotWidget(
                        approved: snapshot.data[index]['approved'],
                        name: snapshot.data[index]['name'],
                        description: snapshot.data[index]['description'],
                        category: snapshot.data[index]['category'],
                        location: snapshot.data[index]['location'],
                        private: snapshot.data[index]['private'],
                        imgLink: snapshot.data[index]['imgLink'],
                        price: snapshot.data[index]['price'],
                      );
                    });
              }

            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Container(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator()));
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Center(
                child: Text(
                  'There are connectivity issues.\nPlease retry later.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return PlotsError();
            }
          }),
    );
  }
}
