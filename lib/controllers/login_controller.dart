import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../authenticatons/AuthenticationRepo.dart';

class LoginUpController extends GetxController {

  static LoginUpController get instance => Get.find();

  //TextField Controllers to get data from TextFields
  final empID = TextEditingController();
  final password = TextEditingController();

//Call this Function from Design & it will do the rest
  void loginUser(String email, String password) {
    AuthenticationRepo.instance.loginUserWithEmailAndPassword(email, password);
  }
}