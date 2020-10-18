import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PriceIconWidget extends StatelessWidget {
  final String price;

  const PriceIconWidget({Key key, this.price}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    //'Free', 'Cheapest', 'Moderate', 'Expensive'
    if(price == 'Free'){
      return Container(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Icon(Icons.money_off_rounded, color: Colors.green,),
          ],
        ),
      );
    } else if (price == 'Cheapest'){
      return Container(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Icon(Icons.attach_money, color: Colors.green,),
          ],
        ),
      );
    } else if (price == 'Moderate'){
  return Container(
      padding: EdgeInsets.all(5),
      child: Row(
      children: [
      Icon(Icons.attach_money, color: Colors.green,),
        Icon(Icons.attach_money, color: Colors.green,),

      ],
      ),
      );
    }else {
      return Container(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Icon(Icons.attach_money, color: Colors.green,),
            Icon(Icons.attach_money, color: Colors.green,),
            Icon(Icons.attach_money, color: Colors.green,),

          ],
        ),
      );
    }
  }
}

