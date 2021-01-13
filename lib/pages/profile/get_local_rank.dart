import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

getLocalRank(String name, int localScore, bool oG){
  if (oG){
   return Container(
     decoration: BoxDecoration(
         borderRadius: BorderRadius.all(Radius.circular(15)),
     ),
     padding: EdgeInsets.all(5),
     child: Text('Certified OG', style: TextStyle(
       shadows: <Shadow>[
         Shadow(
           offset: Offset(0, 3.2),
           blurRadius: 2.0,
           color: Colors.grey,
         ),
       ],
       fontWeight: FontWeight.bold,
       fontSize: 30,
       color: Colors.purpleAccent
     ),),
   );
  }
    if (localScore < 100) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        padding: EdgeInsets.all(5),
        child: Text('Rando', style: TextStyle(
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0, 3.2),
                blurRadius: 2.0,
                color: Colors.grey,
              ),
            ],
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.blue
        ),),
      );
    } else if (localScore < 1000) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        padding: EdgeInsets.all(5),
        child: Text('Gabba', style: TextStyle(
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0, 3.2),
                blurRadius: 2.0,
                color: Colors.grey,
              ),
            ],
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.green
        ),),
      );
    } else if (localScore < 10000) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        padding: EdgeInsets.all(5),
        child: Text('G', style: TextStyle(
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0, 3.2),
                blurRadius: 2.0,
                color: Colors.grey,
              ),
            ],
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.red
        ),),
      );
    } else if (localScore < 100000) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        padding: EdgeInsets.all(5),
        child: Text('Local', style: TextStyle(
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0, 3.2),
                blurRadius: 2.0,
                color: Colors.grey,
              ),
            ],
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.orange
        ),),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        padding: EdgeInsets.all(5),
        child: Text('Certified OG', style: TextStyle(
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0, 3.2),
                blurRadius: 2.0,
                color: Colors.grey,
              ),
            ],
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.purpleAccent
        ),),
      );
    }
}