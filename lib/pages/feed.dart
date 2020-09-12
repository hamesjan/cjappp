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
                  EntertainmentCategoryButton(),
                  EntertainmentCategoryButton(),
                  EntertainmentCategoryButton(),
                  EntertainmentCategoryButton(),
                  EntertainmentCategoryButton(),
                  EntertainmentCategoryButton(),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              PreferenceCategoryButton(
                text: 'Ratings',
                title: 'Sort By',
                callback: () {},
              ),
              PreferenceCategoryButton(
                  text: 'Radius', title: 'Location', callback: () {}),
              PreferenceCategoryButton(
                  text: 'Moderate', title: 'Price', callback: () {}),
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
