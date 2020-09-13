import 'package:cjapp/widgets/preference_category_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/widgets/hotspot.dart';
import 'package:cjapp/widgets/entertainment_category_button.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final ScrollController _scrollController = ScrollController();
  String chosen = 'none';
  String sortBy = 'Popular';
  String price = 'Moderate';
  String radius = '10 miles';


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  EntertainmentCategoryButton(callback: (){
                    setState(() {
                      chosen = 'Outdoors';
                    });
                  }, text: 'Outdoors', chosen: chosen, icon: Icon(Icons.nature_people,),),
                  EntertainmentCategoryButton(callback: (){
                    setState(() {
                      chosen = 'Indoors';
                    });
                  }, text: 'Indoors',chosen: chosen, icon: Icon(Icons.weekend),),
                  EntertainmentCategoryButton(callback: (){
                    setState(() {
                      chosen = 'Action';
                    });
                  }, text: 'Action',chosen: chosen, icon: Icon(Icons.directions_bike),),
                  EntertainmentCategoryButton(callback: (){
                    setState(() {
                      chosen = 'Urban';
                    });
                  }, text: 'Urban',chosen: chosen, icon: Icon(Icons.location_city),),
                  EntertainmentCategoryButton(callback: (){
                    setState(() {
                      chosen = 'View';
                    });
                  }, text: 'View',chosen: chosen, icon: Icon(Icons.landscape),),

                ],
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              DropdownButton<String>(
                value: sortBy,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.pink),
                underline: Container(
                  height: 2,
                  color: Colors.pinkAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    sortBy = newValue;
                  });
                },
                items: <String>['Popular', 'Best Rated', 'Newest', 'Rising']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButton<String>(
                value: price,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.pink),
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
              ),
              DropdownButton<String>(
                value: radius,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.pink),
                underline: Container(
                  height: 2,
                  color: Colors.pinkAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    radius = newValue;
                  });
                },
                items: <String>['5 miles', '10 miles', '50 miles', '100 miles']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

            ],
          ),
          SizedBox(
            height: 15,
          ),
          Divider(
            thickness: 3,
            color: Colors.pinkAccent,
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Column(
              children: <Widget>[
                HotSpot(),
                SizedBox(
                  height: 10,
                ),
                HotSpot(),
                SizedBox(
                  height: 10,
                ),
                HotSpot(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
