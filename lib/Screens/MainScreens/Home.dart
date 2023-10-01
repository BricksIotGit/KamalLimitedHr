import 'dart:convert';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kamal_limited/Screens/MainScreens/Announcements.dart';
import 'package:kamal_limited/Screens/MainScreens/AttendenceSummary.dart';
import 'package:kamal_limited/Screens/MainScreens/ComplainAndSuggestions.dart';
import 'package:kamal_limited/Screens/MainScreens/DepartmentStatus.dart';
import 'package:kamal_limited/Screens/MainScreens/EmployeDirectory.dart';
import 'package:kamal_limited/Screens/MainScreens/GeoLocation.dart';
import 'package:kamal_limited/Screens/MainScreens/LeaveRequest.dart';
import 'package:kamal_limited/Screens/MainScreens/OutdoorDutyResquest.dart';
import 'package:kamal_limited/Screens/MainScreens/Profile.dart';
import 'package:kamal_limited/Screens/MainScreens/RequestApproval.dart';
import 'package:kamal_limited/Screens/Setting/UpdateProfile.dart';
import 'package:kamal_limited/styling/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import '../Setting/google_map.dart';
import '../Starting/Login.dart';
import 'VisitorRequest.dart';
import 'datediffernce.dart';
import 'package:xml/xml.dart' as xml;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String dropdownvalue = 'Employ Directory';
  TextEditingController textController = new TextEditingController();

  // List of items in our dropdown menu
  List<String> results = [];

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
  void initState() {
    getPFNO();
    getApprovalIdForNotifiation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void setResults(String query) {
      setState(() {
        //createPDF();
        print('row is ${items}');
        print('row  ${query}');

        results = items
            .where((elem) =>
                elem.toString().toLowerCase().contains(query.toLowerCase()))
            .toList();
        print("resul ${results}");

        items = results;
      });
      // createPDF();
    }

    return Scaffold(
      backgroundColor: Clrs.light_Grey,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: Image(
                        height: 100,
                        width: 200,
                        image: AssetImage(Images.company_logo),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: 12 * SizeConfig.heightMultiplier,
                  //   width: 100 * SizeConfig.widthMultiplier,
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(15.0),
                  //     child: Container(
                  //       //  color: Clrs.white,
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         //Center Row contents horizontally,
                  //
                  //         children: [
                  //           SizedBox(
                  //             height: 45,
                  //             child: AnimSearchBar(
                  //               width: 75 * SizeConfig.widthMultiplier,
                  //               textController: textController,
                  //               onSuffixTap: () {
                  //                 setState(() {
                  //                   textController.clear();
                  //                 });
                  //               },
                  //               onSubmitted: (String) {
                  //                 //setResults(String);
                  //               },
                  //             ),
                  //           ),
                  //           Image(
                  //             //   height:50* SizeConfig.heightMultiplier,
                  //             width: 10 * SizeConfig.widthMultiplier,
                  //             image: AssetImage(Images.notification_ic),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: SizedBox(
                    height: 71 * SizeConfig.heightMultiplier,
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
                                  height: 27 * SizeConfig.widthMultiplier,
                                  image: AssetImage(Images.employ_ic),
                                ),
                                Text('Employee Directory',
                                  textAlign: TextAlign.center,)
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GeoLocation()));
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Image(
                                    //   height:50* SizeConfig.heightMultiplier,
                                    width: 30 * SizeConfig.widthMultiplier,
                                    height: 20 * SizeConfig.widthMultiplier,
                                    image: AssetImage(Images.mark_attendance),
                                  ),
                                ),
                                const Text('Mark Attendance',
                                  textAlign: TextAlign.center,)
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    // builder: (context) => MyApp()));

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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Image(
                                    //   height:50* SizeConfig.heightMultiplier,
                                    width: 30 * SizeConfig.widthMultiplier,
                                    height: 20 * SizeConfig.widthMultiplier,
                                    image: AssetImage(Images.leave_request_ic),
                                  ),
                                ),
                                Text('Leave Requests',
                                  textAlign: TextAlign.center,)
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Image(
                                    //   height:50* SizeConfig.heightMultiplier,
                                    width: 30 * SizeConfig.widthMultiplier,
                                    height: 20 * SizeConfig.widthMultiplier,
                                    image:
                                        AssetImage(Images.request_approval_ic),
                                  ),
                                ),
                                Text('Request Approvals',
                                  textAlign: TextAlign.center,)
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Image(
                                    //   height:50* SizeConfig.heightMultiplier,
                                    width: 30 * SizeConfig.widthMultiplier,
                                    height: 20 * SizeConfig.widthMultiplier,
                                    image: AssetImage(Images.summary_ic),
                                  ),
                                ),
                                Text('Attendence Summary',
                                  textAlign: TextAlign.center,)
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Image(
                                    //   height:50* SizeConfig.heightMultiplier,
                                    width: 30 * SizeConfig.widthMultiplier,
                                    height: 20 * SizeConfig.widthMultiplier,
                                    image:
                                        AssetImage(Images.department_status_ic),
                                  ),
                                ),
                                Text('Department Status',
                                  textAlign: TextAlign.center,)
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
                                        OutdoorDutyRequest()));
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Image(
                                    //   height:50* SizeConfig.heightMultiplier,
                                    width: 30 * SizeConfig.widthMultiplier,
                                    height: 20 * SizeConfig.widthMultiplier,
                                    image: AssetImage(Images.leave_request_ic),
                                  ),
                                ),
                                Text('Outdoor Duty Request',
                                  textAlign: TextAlign.center,)
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Image(
                                    //   height:50* SizeConfig.heightMultiplier,
                                    width: 30 * SizeConfig.widthMultiplier,
                                    height: 20 * SizeConfig.widthMultiplier,
                                    image: AssetImage(Images.leave_request_ic),
                                  ),
                                ),
                                Text('Visitor Request',
                                  textAlign: TextAlign.center,)
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Image(
                                    //   height:50* SizeConfig.heightMultiplier,
                                    width: 30 * SizeConfig.widthMultiplier,
                                    height: 20 * SizeConfig.widthMultiplier,
                                    image: AssetImage(
                                        Images.complainNsuggestion_ic),
                                  ),
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
                                  height: 27 * SizeConfig.widthMultiplier,
                                  image: AssetImage(Images.employ_ic),
                                ),
                                Text('Announcements',
                                  textAlign: TextAlign.center,)
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    // builder: (context) => DateDifference()));
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
                                  height: 27 * SizeConfig.widthMultiplier,
                                  image: AssetImage(Images.employ_ic),
                                ),
                                Text('Profile')
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();

                            final String? empIDSp = prefs.getString('empID');
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateProfile(empIDSp!)));
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Image(
                                    //   height:50* SizeConfig.heightMultiplier,
                                    width: 30 * SizeConfig.widthMultiplier,
                                    height: 20 * SizeConfig.widthMultiplier,
                                    image: AssetImage(Images.setting_ic),
                                  ),
                                ),
                                Text('Settings')
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
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Image(
                                    //   height:50* SizeConfig.heightMultiplier,
                                    width: 30 * SizeConfig.widthMultiplier,
                                    height: 20 * SizeConfig.widthMultiplier,
                                    image: AssetImage(Images.signOut_ic),
                                  ),
                                ),
                                Text('Sign Out')
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    //await FirebaseAuth.instance.signOut();

    //AuthenticationRepo.instance.logout();
    final prefs = await SharedPreferences.getInstance();
    final String? empIDSp = prefs.getString('empID');
    await FirebaseMessaging.instance
        .unsubscribeFromTopic(empIDSp!);
    await prefs.remove('password');
    await prefs.remove('empID');
    await prefs.remove('approvalId');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  Future<void> getPFNO() async {
    final prefs = await SharedPreferences.getInstance();
    final String? empIDSp = prefs.getString('empID');
    final String? pfNo = prefs.getString('pf_no');

    if (pfNo == null || pfNo.isEmpty) {
      String username = 'xxhrms';
      String password = 'xxhrms';
      String basicAuth =
          'Basic ' + base64.encode(utf8.encode('$username:$password'));
      print(basicAuth);

      // 70500195 188700001 70500145 70500274
      var requestBody =
          '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_DIRECTORY">
   <soapenv:Header/>
   <soapenv:Body>
      <get:GET_EMP_DIRECTORYInput>
         <get:P_OUTPUT-XMLTYPE-OUT/>
         <get:P_ENAME-VARCHAR2-IN>null</get:P_ENAME-VARCHAR2-IN>
         <get:P_EMP_ID-VARCHAR2-IN>$empIDSp</get:P_EMP_ID-VARCHAR2-IN>
         <get:P_EMP_DESIGNATION-VARCHAR2-IN>null</get:P_EMP_DESIGNATION-VARCHAR2-IN>
         <get:P_EMP_DEPARTMENT-VARCHAR2-IN>null</get:P_EMP_DEPARTMENT-VARCHAR2-IN>
      </get:GET_EMP_DIRECTORYInput>
   </soapenv:Body>
</soapenv:Envelope>''';

      var response = await post(
        Uri.parse(
            'http://XXHRMS:XXHRMS@202.125.141.170:8080/orawsv/XXHRMS/GET_EMP_DIRECTORY'),
        headers: {
          'content-type': 'text/xml; charset=utf-8',
          'authorization': basicAuth
        },
        body: utf8.encode(requestBody),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        // setState(() {
        //
        // });
        var document = xml.XmlDocument.parse(response.body);
        var row = document.findAllElements('ROW').single;

        var pfNo = row.findElements('PF_NO').single.text;
        print('PF_NO: $pfNo');

        // Store the PF_NO in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('pf_no', pfNo);
      }
    } else {
      print("pfNo is not empty:  $pfNo");
    }
  }

  Future<void> getApprovalIdForNotifiation() async {
    final prefs = await SharedPreferences.getInstance();
    final String? empIDSp = prefs.getString('empID');
    final String? approvalId = prefs.getString('approvalId');
    print('empIDSp: $empIDSp');
    // await FirebaseMessaging.instance.subscribeToTopic(empIDSp ?? "");
    if (approvalId == null || approvalId.isEmpty) {
      String username = 'xxhrms';
      String password = 'xxhrms';
      String basicAuth =
          'Basic ' + base64.encode(utf8.encode('$username:$password'));
      print(basicAuth);

      // 70500195 188700001 70500145 70500274
      var requestBody =
          '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_APPROVAL">
   <soapenv:Header/>
   <soapenv:Body>
      <get:GET_EMP_APPROVALInput>
         <get:P_OUTPUT-XMLTYPE-OUT/>
         <get:P_EMP_ID-VARCHAR2-IN>$empIDSp</get:P_EMP_ID-VARCHAR2-IN>
      </get:GET_EMP_APPROVALInput>
   </soapenv:Body>
</soapenv:Envelope>''';

      var response = await post(
        Uri.parse(
            'http://XXHRMS:XXHRMS@202.125.141.170:8080/orawsv/XXHRMS/GET_EMP_APPROVAL'),
        headers: {
          'content-type': 'text/xml; charset=utf-8',
          'authorization': basicAuth
        },
        body: utf8.encode(requestBody),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        // setState(() {
        //
        // });
        var document = xml.XmlDocument.parse(response.body);

        var empIdElement = document.findAllElements('EMP_ID').single;
        var approvalIdElement = document.findAllElements('APPROVAL_ID').single;

        var empId = empIdElement.text;
        var approvalId = approvalIdElement.text;

        print('EMP_ID: $empId');
        print('APPROVAL_ID: $approvalId');

        // Store the PF_NO in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('approvalId', approvalId);
      }
    } else {
      print("approvalId is not empty:  $approvalId");
    }
  }
}
