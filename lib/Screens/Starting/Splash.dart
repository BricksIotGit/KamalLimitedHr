import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kamal_limited/Screens/Setting/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import '../MainScreens/Home.dart';
import 'Login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () => checkLogin());
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final String? passwordSP = prefs.getString('password');

    print("splash $passwordSP password");
    if (passwordSP == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  // const NotificationScreen()
                  const Home()));
    }
    print("sharedPreff and password $passwordSP");
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        //SystemChrome.setPreferredOrientations(
        // [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          // systemNavigationBarColor: Colors.blue, // navigation bar color
          statusBarColor: Colors.black, // status bar color
        ));
        return Scaffold(
          backgroundColor: Clrs.black,
          body: SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 300.0,
                height: 236.0,
                child: Image(
                  height: 20,
                  image: AssetImage(Images.company_logo),
                ),
              ),
            ),
          ),
        );
      });
    });
  }
}
