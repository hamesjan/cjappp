import 'package:cjapp/pages/profile/new_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cjapp/pages/profile/display_review.dart';
import 'package:cjapp/widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blueAccent,
                    Colors.white10
                  ]
                ),

              ),
              child: Row(
                children: [
                  Icon(Icons.person, color: Colors.blueAccent, size: 100,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('James Han', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40
                      ),),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,

                          borderRadius: BorderRadius.all(Radius.circular(25))
                        ),
                        child:Text('Joined June 2020',textAlign: TextAlign.center, style: TextStyle(
                            fontSize: 15
                        ),), 
                      ),

                    ],
                  )
                ],
              ),
            ),
            Divider(thickness: 2,),
            CustomButton(text: 'View Favorites', callback: (){},),
            SizedBox(height: 10,),
            CustomButton(text: 'View All Reviews', callback: (){},),
            SizedBox(height: 10,),
            CustomButton(text: 'Add a new Plot!', callback: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => NewPlace()
                )
              );
            },),

          ],
        ),
      ),
    );
  }
}
