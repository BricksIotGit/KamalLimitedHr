import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:kamal_limited/utils/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import 'Home.dart';

class ComplainAndSuggestions extends StatefulWidget {
  const ComplainAndSuggestions({Key? key}) : super(key: key);

  @override
  _ComplainAndSuggestionsState createState() => _ComplainAndSuggestionsState();
}

class _ComplainAndSuggestionsState extends State<ComplainAndSuggestions> {
  bool complainType = false;
  bool suggestionType = false;
  TextEditingController subjectControl = TextEditingController();
  TextEditingController bodyControl = TextEditingController();
  var empID = "";

  @override
  void initState() {
    setId();
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
          child: SingleChildScrollView(
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
                          "Complain And Suggestions",
                          style: TextStyle(color: Clrs.white, fontSize: 20),
                        )))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "Fill the form",
                    style: TextStyle(fontSize: 16, color: Clrs.dark_Grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Type:"),
                      Row(
                        children: [
                          Text("Complain"),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.grey,
                            value: complainType,
                            onChanged: (bool? value) {
                              setState(() {
                                complainType = value!;
                                suggestionType = false;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Suggestion"),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.grey,
                            value: suggestionType,
                            onChanged: (bool? value) {
                              setState(() {
                                suggestionType = value!;
                                complainType = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text("Host ID: $empID")),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: TextFormField(
                    controller: subjectControl,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        labelText: 'Subject',
                        labelStyle: TextStyle(color: Colors.black)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: TextFormField(
                    controller: bodyControl,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        isDense: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        labelText: 'Body',
                        labelStyle: TextStyle(color: Colors.black)),
                    maxLines: 5,
                    minLines: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      var type = "";
                      if (complainType) {
                        print("complain type: $complainType");
                        type = "Complain";
                      } else if (suggestionType) {
                        print("suggestion type: $suggestionType");
                        type = "Suggestion";
                      } else if (complainType == false &&
                          suggestionType == false) {
                        toast("Type must be selected");

                      }
                      else if(subjectControl.text.isEmpty){
                        toast("Subject must not empty!");
                                              }
                      else if(bodyControl.text.isEmpty){
                        toast("Body must not empty!");
                                              }

                      else {
                        print("sumit api subject text: ${subjectControl.text}");
                        print("sumit api body text: ${bodyControl.text}");

                        // submitApi(type);
                        // Navigator.pushReplacement(
                        //     context, MaterialPageRoute(builder: (context) => Home()));
                      }
                    },
                    child: Text('Submit',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Clrs.black,
                      shape: StadiumBorder(),
                      minimumSize: Size(250, 40),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitApi(String type) async {

    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    String formattedDate = DateFormat('dd-MMM-yyyy')
        .format(date)
        .toUpperCase();
    print("date is $formattedDate");


    String username = 'xxhrms';
    String password = 'xxhrms';
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);

    // 70500195 188700001 70500145 70500274

    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:post="http://xmlns.oracle.com/orawsv/XXHRMS/POST_EMP_FEEBACK">
   <soapenv:Header/>
   <soapenv:Body>
      <post:POST_EMP_FEEBACKInput>
         <post:P_OUTPUT-VARCHAR2-OUT/>
         <post:P_FEEDBACK_TYPE-VARCHAR2-IN>$type</post:P_FEEDBACK_TYPE-VARCHAR2-IN>
         <post:P_FEEDBACK_SUBJECT-VARCHAR2-IN>${subjectControl.text}</post:P_FEEDBACK_SUBJECT-VARCHAR2-IN>
         <post:P_FEEDBACK_DATE-DATE-IN>$formattedDate</post:P_FEEDBACK_DATE-DATE-IN>
         <post:P_FEEDBACK_BODY-VARCHAR2-IN>${bodyControl.text}</post:P_FEEDBACK_BODY-VARCHAR2-IN>
         <post:P_EMP_ID-VARCHAR2-IN>$empID</post:P_EMP_ID-VARCHAR2-IN>
      </post:POST_EMP_FEEBACKInput>
   </soapenv:Body>
</soapenv:Envelope>''';

    var response = await post(
      Uri.parse(
          'http://XXHRMS:XXHRMS@202.125.141.170:8080/orawsv/XXHRMS/SUBMIT_EMP_LEAVES'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    print("Response body submit: ${response.body}");

    var xmlString = response.body;

    if (response.statusCode == 200) {
      print("Api hit");
    }
  }

  Future<void> setId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? empIDSp = prefs.getString('empID');
    empID = empIDSp!;
    setState(() {});
  }
}
