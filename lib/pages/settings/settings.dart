import 'package:cjapp/pages/settings/about_plots.dart';
import 'package:cjapp/pages/settings/privacy_policy_plots.dart';
import 'package:cjapp/pages/settings/select_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cjapp/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cjapp/pages/login/login.dart';
import 'package:cjapp/pages/settings/your_account.dart';
import 'package:firebase_admob/firebase_admob.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      testDevices: null,
      nonPersonalizedAds: true,
      keywords: <String>['Entertainment', 'Convenience', 'Fun']);

  BannerAd bannerAd;

  // InterstitialAd interstitialAd;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: 'ca-app-pub-1671319682516251/1543231558',
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print('BannerAd $event');
        });
  }

  // InterstitialAd createInterstitialAd (){
  //   return InterstitialAd(
  //       adUnitId: 'ca-app-pub-1671319682516251/1543231558',
  //       targetingInfo: targetingInfo,
  //       listener: (MobileAdEvent event){
  //         print('Interstitial Ad $event');
  //       }
  //   );
  // }
  //

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: BannerAd.testAdUnitId);
    bannerAd = createBannerAd()
      ..load()
      ..show();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bannerAd.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Home()
                ));
          },
        ),
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Divider(thickness: 2,),
            SelectIconSetting(
              icon: Icon(Icons.security),
              text: 'Privacy',
              callback: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) => PrivacyPolicy()));
              },
            ),
            SelectIconSetting(
              icon: Icon(Icons.person),
              text: 'Your Account',
              callback: (){
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) => YourAccount()));
              },
            ),
            // SelectIconSetting(
            //   icon: Icon(Icons.payment),
            //   text: 'Payment Method',
            //   callback: (){},
            // ),
            SelectIconSetting(
              icon: Icon(Icons.info),
              text: 'About',
              callback: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) => AboutPlots()));
              },
            ),
            Divider(thickness: 2,),
            SelectTextSetting(
              text: 'Log Out',
              callback: (){
                showDialog(context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Are you sure you want to log out?'),
                        actions: <Widget>[
                          IconButton(
                            onPressed: (){
                              _auth.signOut();
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => Login()));
                            },
                            icon: Icon(Icons.logout, color: Colors.red,),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          )
                        ],
                      );
                    }
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
