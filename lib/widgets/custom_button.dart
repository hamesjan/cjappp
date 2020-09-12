import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;

  const CustomButton({Key key, this.callback, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      shape: StadiumBorder(),
      minWidth: 150,
      height: 50,
      child: RaisedButton(
        color: Colors.white,
        elevation: 6,
        child: Text(
          text,
          style: TextStyle(fontSize: 15),
        ),
        onPressed: callback,
      ),
    );
  }
}

class SendButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback callback;

  const SendButton({Key key, this.icon, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: callback,
    );
  }
}
