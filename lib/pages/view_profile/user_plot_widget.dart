import 'package:cjapp/pages/profile/edit_plot.dart';
import 'package:cjapp/pages/profile/your_plots.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cjapp/services/global_functions.dart';

class UserPlotWidget extends StatelessWidget {
  final String description;
  final String name;
  final String category;
  final String imgLink;
  final String location;
  final String price;

  const UserPlotWidget({
    Key key,
    this.description,
    this.name,
    this.imgLink,
    this.category,
    this.location,
    this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => EditPlot(
                        name: name,
                        description: description,
                        imgLink: imgLink,
                        category: category,
                        location: location,
                        price: price,
                      )
                  ));
            },
            child: new Ink(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                child: Column(children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 100,
                      minHeight: 100,
                    ),
                    child:  OptimizedCacheImage(
                      imageUrl: imgLink,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      SizedBox(width: 10,),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Text(
                          name,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),

                    ],
                  )
                ]))));
  }
}
