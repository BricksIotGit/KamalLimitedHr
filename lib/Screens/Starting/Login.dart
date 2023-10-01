import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:kamal_limited/Screens/Setting/UpdateProfile.dart';
import 'package:kamal_limited/utils/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/login_controller.dart';
import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../MainScreens/Home.dart';
import 'Signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final controller = Get.put(LoginUpController());
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Clrs.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 80,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 178.0,
                      height: 156.0,
                      child: Image(
                        height: 20,
                        image: AssetImage(Images.company_logo),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70, left: 30),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Welcome',
                      style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 30,
                          color: Color(0xffffffff)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: controller.empID,
                    cursorColor: Clrs.white,
                    style: const TextStyle(color: Colors.white54),
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white54, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white54, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white54, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        labelText: 'Employee ID',
                        labelStyle: TextStyle(color: Colors.white54)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
                  child: TextFormField(
                    controller: controller.password,
                    cursorColor: Clrs.white,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white54),
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white54, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white54, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white54, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white54)),
                  ),
                ),
                // TextButton(
                //     onPressed: () {},
                //     child: Text(
                //       "Forget Password?",
                //       style: TextStyle(
                //         color: Colors.white,
                //       ),
                //     )),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 70, 0, 10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });

                        getLogins(controller.empID.text.trim(),
                            controller.password.text.trim());

                        //   LoginUpController.instance.loginUser(
                        //       controller.email.text.trim(),
                        //       controller.password.text.trim());
                      }
                      // Navigator.pushReplacement(
                      //     context, MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: Text('Login',
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Clrs.white,
                      shape: StadiumBorder(),
                      minimumSize: Size(250, 40),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //Center Row contents horizontally,
                    children: [
                      Text("Want to create new account?",
                          style: TextStyle(
                            color: Colors.white54,
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signup()));
                          },
                          child: Text(
                            "Signp",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getLogins(String empID, String password) async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    final ref = database.ref();

    final snapshot = await ref.child('usersLogin/$empID').get();

    if (snapshot.exists) {
      setState(() {
        isLoading = false;
      });
      print("Login is v: ${snapshot.value}");
      print("Login is K: ${snapshot.key}");

      for (var a in snapshot.children) {
        if (a.key == 'password') {
          var passIs = a.value;
          print("a Login is ${passIs}");
          if (passIs.toString() == password) {
            // toast("Password Match",print: true);

            if (password == '123456') {
              await FirebaseMessaging.instance
                  .subscribeToTopic(controller.empID.text);
              print("subscribed : ${controller.empID.text}");
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UpdateProfile(controller.empID.text.trim())));
            } else {
              storeLogin(controller.empID.text, controller.password.text);
              await FirebaseMessaging.instance
                  .subscribeToTopic(controller.empID.text);
              print("subscribed : ${controller.empID.text}");
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            }
            // storeLogin( controller.empID.text.trim(),
            //     controller.password.text.trim());
          } else
            toast("Wrong password!", print: true);
        }
        if (a.key == 'userId') {
          print("a Login is ${a.value}");
        }
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print('No data available.');
      toast("No account exist");
    }
  }

  Future<void> storeLogin(String empId, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('empID', empId);
    await prefs.setString('password', password);

    final String? empIDSp = prefs.getString('empID');
    final String? passwordSP = prefs.getString('password');

    print("sharedPreff empID: $empIDSp and password $passwordSP");
  }
}
