import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PreferenceCategoryButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final String title;

  const PreferenceCategoryButton(
      {Key key, this.callback, this.text, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      padding: EdgeInsets.all(10),
      shape: StadiumBorder(),
      height: 25,
      child: RaisedButton(
        color: Colors.white,
        elevation: 6,
        child: Row(
          children: <Widget>[
            Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
            Icon(Icons.arrow_drop_down)
          ],
        ),
        onPressed: callback,
      ),

    );
  }
}
