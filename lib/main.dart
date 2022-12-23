import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kamal_limited/authenticatons/AuthenticationRepo.dart';
import 'package:kamal_limited/firebase_options.dart';

import 'Screens/Starting/Splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepo()));
  runApp(GetMaterialApp(home: SplashScreen()));
}
