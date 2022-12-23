import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:kamal_limited/authenticatons/AuthenticationRepo.dart';

class SignUpController extends GetxController {

  static SignUpController get instance => Get.find();

  //TextField Controllers to get data from TextFields
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final phoneNo = TextEditingController();
//Call this Function from Design & it will do the rest
  void registerUser(String email, String password) {
    AuthenticationRepo.instance.createUserWithEmailAndPassword(email, password);
  }
}