import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cjapp/pages/login/registration.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:cjapp/pages/home.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:cjapp/services/BaseAuth.dart';
import 'package:cjapp/widgets/custom_button.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email;
  String password;
  String token;
  String errorMessage;
  final _loginFormKey = GlobalKey<FormState>();

  var _auth = Auth();

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      testDevices: null,
      nonPersonalizedAds: true,
      keywords: <String>['Entertainment', 'Convenience', 'Fun']
  );

  BannerAd bannerAd;
  // InterstitialAd interstitialAd;

  BannerAd createBannerAd(){
    return BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          print('BannerAd $event');
        }
    );
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
    bannerAd = createBannerAd()..load()..show();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bannerAd.dispose();
    super.dispose();
  }


  signInUser() async {
    try {
      String userId = await _auth.signIn(email, password);
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => Home()));
    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      setState(
        () {
          errorMessage = e.message;
          _loginFormKey.currentState.reset();
          email = null;
          password = null;
        },
      );
    }
  }

  String validateEmail(String value) {
    if (value == null || value.isEmpty) {
      return "Missing Email";
    }
    return null;
  }

  String validatePassword(String value) {
    if (value == null || value.isEmpty) {
      return "Missing Password";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          Container(
          constraints: BoxConstraints(
            maxHeight: 200,
            minHeight: 200,
          ),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(25.0),
            child: Image(image: AssetImage('assets/images/loginlogo.png'),),
          ),
        ),


              TextFormField(
                  onChanged: (value) => email = value,
                  validator: (text) => validateEmail(text),
                  decoration: InputDecoration(
                      icon: Icon(Icons.mail),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      hintText: 'Email',)),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  onChanged: (value) => password = value,
                  obscureText: true,
                  validator: (text) => validatePassword(text),
                  autocorrect: false,
                  decoration: InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))))),
              SizedBox(
                height: 10,
              ),
              errorMessage != null
                  ? Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              CustomButton(
                text: 'Login',
                callback: () {
                  if (_loginFormKey.currentState.validate()) {
                    signInUser();
                  } else {
                    print(errorMessage);
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              CustomButton(
                text: 'Sign Up',
                callback: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Registration()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
