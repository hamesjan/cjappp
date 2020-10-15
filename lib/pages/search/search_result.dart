import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SearchResults extends StatelessWidget {
  final String name;
  final String zipCode;
  final String location;
  final double ratingsNumbers;
  final List ratings;
  final String website;
  final String category;
  final String by;
  final String price;

  const SearchResults(
      {Key key,
        this.name,
        this.zipCode,
        this.location,
        this.by,
        this.ratingsNumbers,
        this.ratings,
        this.website,
        this.category,
        this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

      ],
    );
  }
}
