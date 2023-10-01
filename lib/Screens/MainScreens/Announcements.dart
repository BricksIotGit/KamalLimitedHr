import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;
import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import '../../utils/Toast.dart';
import 'Home.dart';

class Announcements extends StatefulWidget {
  const Announcements({Key? key}) : super(key: key);

  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  String username = 'xxhrms';
  String password = 'xxhrms';
  String basicAuth = "";
  var itemsOfdept = ['Select'];

  //BOARD OF DIRECTORS
  List<Map<String, String?>> valuesList = [];

  String fromDropDownValue = 'Select';
  String toDropDownValue = 'Select';
  int toDptSelectedItemIndex = -1;
  int fromDptSelectedItemIndex = -1;
  TextEditingController annCont = TextEditingController();
  String? _errorAnn;

  void initState() {
    init();
    //getAllDept();
    // getAnnouncList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('The user tries to pop()');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Stack(
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
                          "Announcements",
                          style: TextStyle(color: Clrs.white, fontSize: 20),
                        )))
                  ],
                ),
              ),
              // Row(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              //       child: Text(
              //         "From Dept.  : ",
              //         style: TextStyle(color: Clrs.dark_Grey, fontSize: 16),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
              //       child: Container(
              //         width: 55 * SizeConfig.widthMultiplier,
              //         child: SizedBox(
              //           width: 30 * SizeConfig.widthMultiplier,
              //           child: DropdownButtonFormField(
              //             isExpanded: true,
              //             decoration: InputDecoration(
              //               contentPadding: EdgeInsets.only(
              //                   top: 5, bottom: 5, left: 10, right: 5),
              //               //this one
              //               focusedBorder: OutlineInputBorder(
              //                 borderSide:
              //                     BorderSide(color: Clrs.light_Grey, width: 1),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //               enabledBorder: OutlineInputBorder(
              //                 borderSide:
              //                     BorderSide(color: Clrs.light_Grey, width: 1),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //               border: OutlineInputBorder(
              //                 borderSide:
              //                     BorderSide(color: Clrs.light_Grey, width: 1),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //               filled: true,
              //               fillColor: Clrs.medium_Grey,
              //             ),
              //             dropdownColor: Clrs.light_Grey,
              //             // Initial Value
              //             value: fromDropDownValue,
              //             // Down Arrow Ico
              //             icon: const Icon(Icons.keyboard_arrow_down),
              //             // Array list of items
              //             items: itemsOfdept.map((String items) {
              //               return DropdownMenuItem(
              //                 value: items,
              //                 child: Text(items),
              //               );
              //             }).toList(),
              //             onTap: () {},
              //             onChanged: (String? newValue) {
              //               setState(() {
              //                 fromDropDownValue = newValue!;
              //
              //                 fromDptSelectedItemIndex =
              //                     itemsOfdept.indexOf(newValue!);
              //
              //                 print("selected dpt is: $fromDropDownValue");
              //                 if (fromDropDownValue == "Select") {
              //                   toast("Please select a department");
              //                   //reasign();
              //                 } else {
              //
              //                   print("Selected department: $fromDropDownValue");
              //                   print(
              //                       "Selected item index: $fromDptSelectedItemIndex");
              //
              //                   print(
              //                       "Selected dpt  id: ${valuesList[fromDptSelectedItemIndex - 1]['DEPT_ID']}");
              //                   // setResultsDropDept(dropdownvalueDepart);
              //                 }
              //               });
              //             },
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // Row(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              //       child: Text(
              //         "To Dept. : ", // 2nd
              //         style: TextStyle(color: Clrs.dark_Grey, fontSize: 16),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
              //       child: Container(
              //         width: 61 * SizeConfig.widthMultiplier,
              //         child: SizedBox(
              //           width: 30 * SizeConfig.widthMultiplier,
              //           child: DropdownButtonFormField(
              //             isExpanded: true,
              //             decoration: InputDecoration(
              //               contentPadding: EdgeInsets.only(
              //                   top: 5, bottom: 5, left: 10, right: 5),
              //               //this one
              //               focusedBorder: OutlineInputBorder(
              //                 borderSide:
              //                     BorderSide(color: Clrs.light_Grey, width: 1),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //               enabledBorder: OutlineInputBorder(
              //                 borderSide:
              //                     BorderSide(color: Clrs.light_Grey, width: 1),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //               border: OutlineInputBorder(
              //                 borderSide:
              //                     BorderSide(color: Clrs.light_Grey, width: 1),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //               filled: true,
              //               fillColor: Clrs.medium_Grey,
              //             ),
              //             dropdownColor: Clrs.light_Grey,
              //             // Initial Value
              //             value: toDropDownValue,
              //             // Down Arrow Ico
              //             icon: const Icon(Icons.keyboard_arrow_down),
              //             // Array list of items
              //             items: itemsOfdept.map((String items) {
              //               return DropdownMenuItem(
              //                 value: items,
              //                 child: Text(items),
              //               );
              //             }).toList(),
              //             onTap: () {},
              //             onChanged: (String? newValue) {
              //               setState(() {
              //                 toDropDownValue = newValue!;
              //
              //                 toDptSelectedItemIndex =
              //                     itemsOfdept.indexOf(newValue!);
              //
              //                 if (toDropDownValue == "Select") {
              //                   //reasign();
              //                   toast("Please select a department");
              //                 } else {
              //                   print("Selected department: $toDropDownValue");
              //                   print(
              //                       "Selected item index: $toDptSelectedItemIndex");
              //
              //                   // setResultsDropDept(dropdownvalueDepart);
              //                   print(
              //                       "Selected dpt  id: ${valuesList[toDptSelectedItemIndex - 1]['DEPT_ID']}");
              //                 }
              //               });
              //             },
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              //   child: TextFormField(
              //     controller: annCont,
              //     cursorColor: Colors.black,
              //     style: const TextStyle(color: Colors.black),
              //     decoration: InputDecoration(
              //         errorText: _errorAnn,
              //         isDense: true,
              //         focusedBorder: OutlineInputBorder(
              //           borderSide:
              //           BorderSide(color: Colors.black, width: 1.0),
              //           borderRadius: BorderRadius.all(Radius.circular(5.0)),
              //         ),
              //         enabledBorder: OutlineInputBorder(
              //           borderSide:
              //           BorderSide(color: Colors.black, width: 1.0),
              //           borderRadius: BorderRadius.all(Radius.circular(5.0)),
              //         ),
              //         errorBorder: OutlineInputBorder(
              //           borderSide:
              //           BorderSide(color: Colors.black, width: 1.0),
              //           borderRadius: BorderRadius.all(Radius.circular(5.0)),
              //         ),
              //         labelText: 'Announcement',
              //         labelStyle: TextStyle(color: Colors.grey)),
              //     maxLines: 5,
              //     minLines: 3,
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(20.0),
              //   child: ElevatedButton(
              //     onPressed: () {
              //
              //
              //       if (fromDropDownValue == "Select") {
              //         setState(() {
              //          toast("Select Department");
              //         });
              //       } else if (toDropDownValue == "Select") {
              //         setState(() {
              //           toast("Select Department");
              //         });
              //       }  else if (annCont.text == "") {
              //         setState(() {
              //           toast("Must type Announcement");
              //
              //         });
              //       }
              //       else {
              //         setState(() {
              //           _errorAnn=null;
              //         });
              //
              //
              //         submitHitApi();
              //
              //       }
              //     },
              //     child: Text('Submit',
              //         style: TextStyle(
              //           color: Colors.white,
              //         )),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Clrs.black,
              //       shape: StadiumBorder(),
              //       minimumSize: Size(250, 40),
              //     ),
              //   ),
              // )

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: SizeConfig.heightMultiplier*75,
                  width: SizeConfig.widthMultiplier*90,
                  child: FutureBuilder<List<Announcement>>(
                    future: getAnnouncList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final announcements = snapshot.data!;
                        return ListView.builder(
                          itemCount: announcements.length,
                          itemBuilder: (context, index) {
                            final announcement = announcements[index];
                            return Card(
                              color:  Colors.grey[200],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 2,
                              shadowColor: Colors.grey[600],
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text('Department: ${announcement.deptName}'),
                                    subtitle: Text('Date: ${announcement.announcementDate}'),
                                  ),
                                  SizedBox(
                                    width:SizeConfig.widthMultiplier*90,
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        'Message: ${announcement.message}',
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getAllDept() async {
    // http://202.125.141.170:8080/orawsv/XXHRMS/GET_EMP_DEPT
    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_DEPT">
   <soapenv:Header/>
   <soapenv:Body>
      <get:GET_EMP_DEPTInput>
         <get:P_OUTPUT-XMLTYPE-OUT/>
      </get:GET_EMP_DEPTInput>
   </soapenv:Body>
</soapenv:Envelope>''';

    var response = await post(
      Uri.parse('http://202.125.141.170:8080/orawsv/XXHRMS/GET_EMP_DEPT'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(response.body.toString());
      final rowsetElement = document.findAllElements('ROWSET').single;
      List<xml.XmlElement> rowElements =
          rowsetElement.findAllElements('ROW').toList();

      itemsOfdept.clear();
      valuesList.clear();
      itemsOfdept.add("Select");
      for (final rowElement in rowElements) {
        String? deptId = rowElement.getElement('DEPT_ID')?.text;
        String? empDepartment = rowElement.getElement('EMP_DEPARTMENT')?.text;

        print('DEPT_ID: $deptId');
        print('EMP_DEPARTMENT: $empDepartment');
        print('----------------------------------');
        itemsOfdept.add('$empDepartment');
        Map<String, String?> values = {
          'DEPT_ID': deptId,
          'EMP_DEPARTMENT': empDepartment,
        };

        valuesList.add(values);
      }
      setState(() {});
      print("itemsOfdept complete: $itemsOfdept");
      print("itemsOfdept  valuesList complete: $valuesList");
    }
  }

  init() {
    basicAuth = 'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);
  }

  Future<void> submitHitApi() async {
    print( "FromDpt $fromDropDownValue & Todpt: ${toDropDownValue} & announcement: ${annCont.text} ");

    print("ID: ${valuesList[toDptSelectedItemIndex - 1]['DEPT_ID']} and:  ${valuesList[fromDptSelectedItemIndex - 1]['DEPT_ID']}");
    //here
    var requestBody =
    '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:post="http://xmlns.oracle.com/orawsv/XXHRMS/POST_ANNOUNCEMENTS">
   <soapenv:Header/>
   <soapenv:Body>
      <post:POST_ANNOUNCEMENTSInput>
         <post:TO_DEPT_NAME-VARCHAR2-IN>$toDropDownValue</post:TO_DEPT_NAME-VARCHAR2-IN>
         <post:TO_DEPT_ID-NUMBER-IN>${valuesList[toDptSelectedItemIndex - 1]['DEPT_ID']}</post:TO_DEPT_ID-NUMBER-IN>
         <post:P_OUTPUT-VARCHAR2-OUT/>
         <post:MESSAGE-VARCHAR2-IN>${annCont.text}</post:MESSAGE-VARCHAR2-IN>
         <post:FROM_DEPT_NAME-VARCHAR2-IN>$fromDropDownValue</post:FROM_DEPT_NAME-VARCHAR2-IN>
         <post:FROM_DEPT_ID-NUMBER-IN>${valuesList[fromDptSelectedItemIndex - 1]['DEPT_ID']}</post:FROM_DEPT_ID-NUMBER-IN>
      </post:POST_ANNOUNCEMENTSInput>
   </soapenv:Body>
</soapenv:Envelope>''';
//
    var response = await post(
      Uri.parse(
          'http://202.125.141.170:8080/orawsv/XXHRMS/POST_ANNOUNCEMENTS'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth.toString()
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    print("Response body submit: ${response.body}");
//
    var xmlString = response.body;

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(xmlString);
      final outputElement = document.findAllElements('P_OUTPUT').single;

      final outputValue = outputElement.text;
      print(outputValue);

      if (outputValue == "Announcements Generated") {
        submitAlertCustom();
        // toast("Post successfully!");
      } // prints "OK"
      else {
        errorCustom(outputValue!);
        // toast("Post fail!");
      }
    }

  }
  void errorCustom(String msg) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),

      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 200,
              width: 200,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Lottie.network("https://assets10.lottiefiles.com/packages/lf20_O6BZqckTma.json")
              ),
            ),

            Padding(padding: EdgeInsets.only(top: 5.0)),
            Text("Reason: $msg"),
            TextButton(
                onPressed: () {
                  //  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                },
                child: Text(
                  'Close!',
                  style: TextStyle(color: Colors.red, fontSize: 16.0),
                ))
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  void submitAlertCustom() {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Lottie.network("https://assets10.lottiefiles.com/packages/lf20_8XY7J1RJeZ.json")
            ),

            Padding(padding: EdgeInsets.only(top: 5.0)),
            TextButton(
                onPressed: () {
                  //  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                },
                child: Text(
                  'Close!',
                  style: TextStyle(color: Colors.red, fontSize: 16.0),
                ))
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }



}


class Announcement {
  final String announcementDate;
  final int deptId;
  final String deptName;
  final String message;

  Announcement({
    required this.announcementDate,
    required this.deptId,
    required this.deptName,
    required this.message,
  });
}

Future<List<Announcement>> getAnnouncList() async {
  const String url = 'http://202.125.141.170:8080/orawsv/XXHRMS/GET_ANNOUNCEMENTS';
  const String auth = 'xxhrms';
  const String password = 'xxhrms';

  final response = await http.post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'text/xml; charset=utf-8',
      'Authorization': 'Basic ' + base64Encode(utf8.encode('$auth:$password')),
    },
    body: '''<?xml version="1.0" encoding="utf-8"?>
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_ANNOUNCEMENTS">
        <soapenv:Header/>
        <soapenv:Body>
          <get:GET_ANNOUNCEMENTSInput>
            <get:P_OUTPUT-XMLTYPE-OUT/>
          </get:GET_ANNOUNCEMENTSInput>
        </soapenv:Body>
      </soapenv:Envelope>''',
  );

  if (response.statusCode == 200) {
    final document = xml.XmlDocument.parse(response.body);
    final rows = document.findAllElements('ROW');
    final List<Announcement> announcements = [];

    for (var row in rows) {
      final announcement = Announcement(
        announcementDate: row.findElements('ANNOUNCEMENT_DATE').single.text,
        deptId: int.parse(row.findElements('DEPT_ID').single.text),
        deptName: row.findElements('DEPT_NAME').single.text,
        message: row.findElements('MESSAGE').single.text,
      );
      announcements.add(announcement);
    }

    return announcements;
  } else {
    throw Exception('Failed to fetch announcements');
  }
}

