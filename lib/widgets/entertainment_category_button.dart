import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class EntertainmentCategoryButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final Icon icon;
  final String chosen;


  const EntertainmentCategoryButton(
      {Key key, this.callback, this.text, this.icon, this.chosen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 16), child: InkWell(
      borderRadius: BorderRadius.all(Radius.circular(50)),
            onTap: callback,
            child: Ink(
          decoration: BoxDecoration(
              color: chosen == text ? Colors.green : Colors.pink,
              borderRadius: BorderRadius.all(Radius.circular(50))),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: icon,
                padding: EdgeInsets.all(5),
              ),
              Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )));
  }
}
