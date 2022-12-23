import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kamal_limited/Screens/MainScreens/Announcements.dart';
import 'package:kamal_limited/Screens/MainScreens/AttendenceSummary.dart';
import 'package:kamal_limited/Screens/MainScreens/ComplainAndSuggestions.dart';
import 'package:kamal_limited/Screens/MainScreens/DepartmentStatus.dart';
import 'package:kamal_limited/Screens/MainScreens/EmployeDirectory.dart';
import 'package:kamal_limited/Screens/MainScreens/LeaveRequest.dart';
import 'package:kamal_limited/Screens/MainScreens/OutdoorDutyResquest.dart';
import 'package:kamal_limited/Screens/MainScreens/Profile.dart';
import 'package:kamal_limited/Screens/MainScreens/RequestApproval.dart';
import 'package:kamal_limited/authenticatons/AuthenticationRepo.dart';
import 'package:kamal_limited/styling/colors.dart';

import '../../styling/images.dart';
import '../../styling/size_config.dart';
import '../Starting/Login.dart';
import 'VisitorRequest.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String dropdownvalue = 'Employ Directory';

  // List of items in our dropdown menu
  var items = [
    'Employ Directory',
    'Leave Requests',
    'Request Approvals',
    'Attendance Summary',
    'Department Status',
    'Outdoor Duty Request',
    'Visitor Request',
    'Complain or Suggestions',
    'Announcements',
    'Contact Us',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Clrs.light_Grey,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Image(
                    //   height:50* SizeConfig.heightMultiplier,
                    width: 100 * SizeConfig.widthMultiplier,
                    image: AssetImage(Images.header_grey),
                  ),
                  Center(
                    child: Image(
                      height: 150,
                      image: AssetImage(Images.company_logo),
                    ),
                  ),
                  Positioned(
                    top: 12 * SizeConfig.heightMultiplier,
                    width: 100 * SizeConfig.widthMultiplier,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        //  color: Clrs.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          //Center Row contents horizontally,

                          children: [
                            Image(
                              //   height:50* SizeConfig.heightMultiplier,
                              width: 10 * SizeConfig.widthMultiplier,
                              image: AssetImage(Images.search_ic),
                            ),
                            Image(
                              //   height:50* SizeConfig.heightMultiplier,
                              width: 10 * SizeConfig.widthMultiplier,
                              image: AssetImage(Images.notification_ic),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 5),
                    //this one

                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Clrs.light_Grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Clrs.light_Grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Clrs.light_Grey, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Clrs.medium_Grey,
                  ),
                  dropdownColor: Clrs.light_Grey,
                  // Initial Value
                  value: dropdownvalue,

                  // Down Arrow Ico
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(
                  height: 65 * SizeConfig.heightMultiplier,
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    crossAxisCount: 2,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EmployeeDirectory()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          // color: Colors.teal[100],
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Clrs.white, Clrs.gradient_Grey],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Clrs.light_Grey,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                //   height:50* SizeConfig.heightMultiplier,
                                width: 30 * SizeConfig.widthMultiplier,
                                height: 30 * SizeConfig.widthMultiplier,
                                image: AssetImage(Images.employ_ic),
                              ),
                              Text('Employ Directory')
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LeaveRequest()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          // color: Colors.teal[100],
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Clrs.white, Clrs.gradient_Grey],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Clrs.light_Grey,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                //   height:50* SizeConfig.heightMultiplier,
                                width: 30 * SizeConfig.widthMultiplier,
                                height: 30 * SizeConfig.widthMultiplier,
                                image: AssetImage(Images.employ_ic),
                              ),
                              Text('Leave Requests')
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RequestApproval()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          // color: Colors.teal[100],
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Clrs.white, Clrs.gradient_Grey],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Clrs.light_Grey,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                //   height:50* SizeConfig.heightMultiplier,
                                width: 30 * SizeConfig.widthMultiplier,
                                height: 30 * SizeConfig.widthMultiplier,
                                image: AssetImage(Images.employ_ic),
                              ),
                              Text('Request Approvals')
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AttendanceSummary()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          // color: Colors.teal[100],
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Clrs.white, Clrs.gradient_Grey],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Clrs.light_Grey,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                //   height:50* SizeConfig.heightMultiplier,
                                width: 30 * SizeConfig.widthMultiplier,
                                height: 30 * SizeConfig.widthMultiplier,
                                image: AssetImage(Images.employ_ic),
                              ),
                              Text('Attendence Summary')
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DepartmentStatus()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          // color: Colors.teal[100],
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Clrs.white, Clrs.gradient_Grey],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Clrs.light_Grey,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                //   height:50* SizeConfig.heightMultiplier,
                                width: 30 * SizeConfig.widthMultiplier,
                                height: 30 * SizeConfig.widthMultiplier,
                                image: AssetImage(Images.employ_ic),
                              ),
                              Text('Department Status')
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OutdoorDutyRequest()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          // color: Colors.teal[100],
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Clrs.white, Clrs.gradient_Grey],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Clrs.light_Grey,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                //   height:50* SizeConfig.heightMultiplier,
                                width: 30 * SizeConfig.widthMultiplier,
                                height: 30 * SizeConfig.widthMultiplier,
                                image: AssetImage(Images.employ_ic),
                              ),
                              Text('Outdoor Duty Request')
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VisitorRequest()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          // color: Colors.teal[100],
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Clrs.white, Clrs.gradient_Grey],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Clrs.light_Grey,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                //   height:50* SizeConfig.heightMultiplier,
                                width: 30 * SizeConfig.widthMultiplier,
                                height: 30 * SizeConfig.widthMultiplier,
                                image: AssetImage(Images.employ_ic),
                              ),
                              Text('Visitor Request')
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ComplainAndSuggestions()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          // color: Colors.teal[100],
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Clrs.white, Clrs.gradient_Grey],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Clrs.light_Grey,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                //   height:50* SizeConfig.heightMultiplier,
                                width: 30 * SizeConfig.widthMultiplier,
                                height: 30 * SizeConfig.widthMultiplier,
                                image: AssetImage(Images.employ_ic),
                              ),
                              const Text(
                                'Complain or Suggestions',
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Announcements()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          // color: Colors.teal[100],
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Clrs.white, Clrs.gradient_Grey],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Clrs.light_Grey,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                //   height:50* SizeConfig.heightMultiplier,
                                width: 30 * SizeConfig.widthMultiplier,
                                height: 30 * SizeConfig.widthMultiplier,
                                image: AssetImage(Images.employ_ic),
                              ),
                              Text('Announcements')
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ComplainAndSuggestions()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          // color: Colors.teal[100],
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Clrs.white, Clrs.gradient_Grey],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Clrs.light_Grey,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                //   height:50* SizeConfig.heightMultiplier,
                                width: 30 * SizeConfig.widthMultiplier,
                                height: 30 * SizeConfig.widthMultiplier,
                                image: AssetImage(Images.employ_ic),
                              ),
                              Text('Contact Us')
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile()));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          // color: Colors.teal[100],
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Clrs.white, Clrs.gradient_Grey],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Clrs.light_Grey,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                //   height:50* SizeConfig.heightMultiplier,
                                width: 30 * SizeConfig.widthMultiplier,
                                height: 30 * SizeConfig.widthMultiplier,
                                image: AssetImage(Images.employ_ic),
                              ),
                              Text('Profile')
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          //signout
                          _signOut();

                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          // color: Colors.teal[100],
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Clrs.white, Clrs.gradient_Grey],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Clrs.light_Grey,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                //   height:50* SizeConfig.heightMultiplier,
                                width: 30 * SizeConfig.widthMultiplier,
                                height: 30 * SizeConfig.widthMultiplier,
                                image: AssetImage(Images.employ_ic),
                              ),
                              Text('Sign Out')
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    //await FirebaseAuth.instance.signOut();

    AuthenticationRepo.instance.logout();

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Login()));
  }
}
