import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart';
import 'package:xml/xml.dart' as xml;

import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';

import 'Home.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  List<Map<String, String>> employeesProfile = [];
 bool fetchOrNot = false;

  @override

  initState() {
    // ignore: avoid_print
    print("initState Called");
    hitApi();
  }


  hitApi() async {
    // var requestBody ='''<?xml version="1.0" encoding="utf-8"?>
    // <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    //   <soap:Body>
    //     <Add xmlns="http://tempuri.org/">
    //       <intA>2</intA>
    //       <intB>6</intB>
    //     </Add>
    //   </soap:Body>
    // </soap:Envelope>''';
    //
    //
    // var response = await post(
    //   Uri.parse('http://www.dneonline.com/calculator.asmx'),
    //   headers: {
    //     'content-type': 'text/xml; charset=utf-8',
    //     'SOAPAction': 'http://tempuri.org/Add',
    //     'Host': 'www.dneonline.com',
    //   },
    //   body: utf8.encode(requestBody),
    //
    // );

    // print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");
    //
    // // Parse XML data
    // var xmlSP = response.body.toString();
    // // final document = xml.parse(response.body);
    // final document = xml.XmlDocument.parse(xmlSP);
    // final employeesNode = document.findAllElements('AddResult');
    // //  final employees = employeesNode.findElements('AddResult').first.text;
    //
    // print("Response employeesNode: ${employeesNode}");
    // print("Response document: ${document}");
    // // print("Response employees: ${employees}");
    // if (employeesNode.isNotEmpty) {
    //   final value = employeesNode.first.text;
    //   print("value is :" + value); // Output: 8
    // } else {
    //   print("value is empty"); // Output: 8
    //
    // }
//------------------------------------------------------------------------------- above demo working
    final prefs = await SharedPreferences.getInstance();
    final String? empIDSp = prefs.getString('empID');


    String username = 'xxhrms';
    String password = 'xxhrms';
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);

    // 70500195 188700001 70500145 70500274
    var requestBody = '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_DIRECTORY">
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

    if(response.statusCode==200){
      setState(() {
        fetchOrNot=true;

      });
    }
    // Parse XML data
    var xmlSP = response.body.toString();

    final document = xml.XmlDocument.parse(xmlSP);
    print("Response document: ${document}");
    print("Response document length: ${document.findAllElements('ROWSET').length}");

    final rowset = document.findAllElements('ROWSET').last;

    print("Response employeesNode: ${rowset}");

    for (var row in rowset.findAllElements('ROW')) {



      final empId = row.findElements('EMP_ID').single.text;
      final ename = row.findElements('ENAME').single.text;
      final fname = row.findElements('FNAME').single.text;
      final gndr = row.findElements('GNDR').single.text;
      final empDpt = row.findElements('EMP_DEPARTMENT').single.text;
      final empDesig = row.findElements('EMP_DESIGNATION').single.text;
      final doj = row.findElements('DOJ').single.text;
      final doc = (row.findElements('DOC').isNotEmpty)? row.findElements('DOC').single.text: "" ;
      final empType = row.findElements('EMP_TYPE').single.text;
      final empShift = row.findElements('EMP_SHIFT').single.text;
      final empSection = row.findElements('EMP_SECTION').single.text;
      final empEmail = row.findElements('EMAIL').single.text;
      final empMob = row.findElements('MOBILE').single.text;
      final empProf = row.findElements('PROFILE_URL').single.text;
      print("Response employees doj: ${doj}");


      employeesProfile.add({
        'empId': empId,
        'ename': ename,
        'fname': fname,
        'gndr': gndr,
        'empDpt': empDpt,
        'empDesig': empDesig,
        'doj': doj,
         'doc': doc,
        'empType': empType,
        'empShift': empShift,
        'empSection': empSection,
        'empEmail': empEmail,
        'empMob': empMob,
        'empProf': empProf,
      });


      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('empName', ename);
    }

    print("Response employees: ${employeesProfile[0]["empProf"]}");


  }

  @override
  Widget build(BuildContext context) {
    if(fetchOrNot) {
      return WillPopScope(
        onWillPop: () async  {
          print('The user tries to pop()');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Home()));
          return false;
        },
        child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image(
                      width: 100 * SizeConfig.widthMultiplier,
                      image: AssetImage(Images.header_other_screens),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.pop(context);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: Image(
                          width: 10 * SizeConfig.widthMultiplier,
                          image: AssetImage(Images.back_arrow_ic),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 40,
                        width: 100 * SizeConfig.widthMultiplier,
                        child: Center(
                            child: Text(
                          "Profile",
                          style: TextStyle(color: Clrs.white, fontSize: 20),
                        )))
                  ],
                ),
                 Image(image: AssetImage(Images.profile_ic)),
                // Padding(
                //   padding: const EdgeInsets.all(20.0),
                //   child: SizedBox(
                //     width: 150,
                //     height: 150,
                //     child: CachedNetworkImage(
                //       imageUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?cs=srgb&dl=pexels-mohamed-abdelghaffar-771742.jpg&fm=jpg",
                //       placeholder: (context, url) => new CircularProgressIndicator(),
                //       errorWidget: (context, url, error) => new Icon(Icons.error),
                //     ),
                //   ),
                // ),

                Wrap(direction: Axis.vertical,
                    //  spacing: 1,
                    children: [
                      Container(
                        //  width: 80 * SizeConfig.widthMultiplier,
                        //padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Clrs.medium_Grey),
                          borderRadius: BorderRadius.circular(20),
                          color: Clrs.light_Grey,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      //  text: 'Hello ',
                                      //style: DefaultTextStyle.of(context).,
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Name:',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                        TextSpan(
                                            text:' ${employeesProfile[0]["ename"]}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 200,
                                    child: RichText(
                                      text: TextSpan(
                                        //  text: 'Hello ',
                                        //style: DefaultTextStyle.of(context).,
                                        children:   <TextSpan>[
                                          TextSpan(
                                              text: 'Department:',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey)),
                                          TextSpan(
                                              text: ' ${employeesProfile[0]["empDpt"]}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      //  text: 'Hello ',
                                      //style: DefaultTextStyle.of(context).,
                                      children:   <TextSpan>[
                                        TextSpan(
                                            text: 'Designation:',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                        TextSpan(
                                            text: ' ${employeesProfile[0]["empDesig"]}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      //  text: 'Hello ',
                                      //style: DefaultTextStyle.of(context).,
                                      children: const <TextSpan>[
                                        TextSpan(
                                            text: 'Salary:',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                        TextSpan(
                                            text: ' 00000',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      //  text: 'Hello ',
                                      //style: DefaultTextStyle.of(context).,
                                      children:   <TextSpan>[
                                        TextSpan(
                                            text: 'Joining Date:',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                        TextSpan(
                                          text: ' ${employeesProfile[0]["doj"]}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      //  text: 'Hello ',
                                      //style: DefaultTextStyle.of(context).,
                                      children:  <TextSpan>[
                                        TextSpan(
                                            text: 'Confirmation Date:',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                        TextSpan(
                                            text: ' ${employeesProfile[0]["doc"]}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 200,
                                    child: RichText(
                                      text: TextSpan(
                                        //  text: 'Hello ',
                                        //style: DefaultTextStyle.of(context).,
                                        children:   <TextSpan>[
                                          TextSpan(
                                              text: 'Section:',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey)),
                                          TextSpan(
                                              text: ' ${employeesProfile[0]["empSection"]}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),


                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      //  text: 'Hello ',
                                      //style: DefaultTextStyle.of(context).,
                                      children:   <TextSpan>[
                                        TextSpan(
                                            text: 'Type:',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                        TextSpan(
                                            text: ' ${employeesProfile[0]["empType"]}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      //  text: 'Hello ',
                                      //style: DefaultTextStyle.of(context).,
                                      children:   <TextSpan>[
                                        TextSpan(
                                            text: 'Gender:',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                        TextSpan(
                                            text: ' ${employeesProfile[0]["gndr"]}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      //  text: 'Hello ',
                                      //style: DefaultTextStyle.of(context).,
                                      children:   <TextSpan>[
                                        TextSpan(
                                            text: 'Shift:',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                        TextSpan(
                                            text: ' ${employeesProfile[0]["empShift"]}',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      //  text: 'Hello ',
                                      //style: DefaultTextStyle.of(context).,
                                      children: const <TextSpan>[
                                        TextSpan(
                                            text: 'Qualification:',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                        TextSpan(
                                            text: '  ',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      //  text: 'Hello ',
                                      //style: DefaultTextStyle.of(context).,
                                      children: const <TextSpan>[
                                        TextSpan(
                                            text: '',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                        TextSpan(
                                            text: '  ',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      //  text: 'Hello ',
                                      //style: DefaultTextStyle.of(context).,
                                      children: const <TextSpan>[
                                        TextSpan(
                                            text: '',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                        TextSpan(
                                            text: '  ',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                      //  text: 'Hello ',
                                      //style: DefaultTextStyle.of(context).,
                                      children: const <TextSpan>[
                                        TextSpan(
                                            text: '',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey)),
                                        TextSpan(
                                            text: '  ',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 20, 20, 40),
                    child: Wrap(direction: Axis.vertical,
                        //  spacing: 1,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // ApiHit();
                              // hitApi();
                            },
                            child: Container(
                              //  width: 80 * SizeConfig.widthMultiplier,
                              //padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Clrs.medium_Grey),
                                borderRadius: BorderRadius.circular(20),
                                color: Clrs.light_Grey,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Contact Info",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            //  text: 'Hello ',
                                            //style: DefaultTextStyle.of(context).,
                                            children: const <TextSpan>[
                                              TextSpan(
                                                  text: 'Extension:',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey)),
                                              TextSpan(
                                                  text: ' +92',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            //  text: 'Hello ',
                                            //style: DefaultTextStyle.of(context).,
                                            children:   <TextSpan>[
                                              TextSpan(
                                                  text: 'Mobile:',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey)),
                                              TextSpan(
                                                  text: ' ${employeesProfile[0]["empMob"]}',

                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            //  text: 'Hello ',
                                            //style: DefaultTextStyle.of(context).,
                                            children: const <TextSpan>[
                                              TextSpan(
                                                  text: 'Phone:',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey)),
                                              TextSpan(
                                                  text: ' 00000',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            //  text: 'Hello ',
                                            //style: DefaultTextStyle.of(context).,
                                            children:  <TextSpan>[
                                              TextSpan(
                                                  text: 'Email:',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey)),
                                              TextSpan(
                                                  text: ' ${employeesProfile[0]["empEmail"]}',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                )
              ],
            ),
          ),
        ),
    ),
      );
    } else {
      return (Scaffold(
        body: SafeArea(
           child: Container(
             child: Column(
                children: [
                  Stack(
                    children: [
                      Image(
                        width: 100 * SizeConfig.widthMultiplier,
                        image: AssetImage(Images.header_other_screens),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.pop(context);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => Home()));
                          },
                          child: Image(
                            width: 10 * SizeConfig.widthMultiplier,
                            image: AssetImage(Images.back_arrow_ic),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 40,
                          width: 100 * SizeConfig.widthMultiplier,
                          child: Center(
                              child: Text(
                                "Profile",
                                style: TextStyle(color: Clrs.white, fontSize: 20),
                              )))
                    ],
                  ),

                  Center(child: Padding(
                    padding: const EdgeInsets.all(100.0),
                    child: CircularProgressIndicator(color: Colors.grey,),
                  )),
                ],
             ),
           ),
        ),
      ));
    }
  }
}
