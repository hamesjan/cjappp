import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SelectIconSetting extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final Icon icon;

  const SelectIconSetting({Key key, this.callback, this.text, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: new Ink(
          child:Container(
              color: Colors.white30,
              padding: EdgeInsets.all(5),
              child:Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(width: 10,),
                      icon,
                      SizedBox(width: 15,),
                      Text(
                        text,style: TextStyle(
                          fontSize: 22,
                          color: Colors.black
                      ),
                      ),
                      Expanded(child: Container(),),
                      Icon(Icons.arrow_right),

                    ],
                  ),
                ],
              )
          )
      ),
    );
  }
}

class SelectTextSetting extends StatelessWidget {
  final VoidCallback callback;
  final String text;

  const SelectTextSetting({Key key, this.callback, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: new Ink(
        child:Container(
          color: Colors.white30,
          padding: EdgeInsets.all(3),
          child:Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 15,),
                  Text(
                    text,style: TextStyle(
                      fontSize: 22,
                      color: Colors.red
                  ),
                  )
                ],
              ),
            ],
          )
        )
      ),
    );
  }
}

