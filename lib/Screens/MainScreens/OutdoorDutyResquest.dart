import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kamal_limited/utils/Toast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart';
import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import '../../utils/sentNotification.dart';
import 'Home.dart';

class OutdoorDutyRequest extends StatefulWidget {
  const OutdoorDutyRequest({Key? key}) : super(key: key);

  @override
  _OutdoorDutyRequestState createState() => _OutdoorDutyRequestState();
}

class _OutdoorDutyRequestState extends State<OutdoorDutyRequest> {
  TextEditingController dateFromInput = TextEditingController();
  TextEditingController dateToInput = TextEditingController();
  TextEditingController textReason = TextEditingController();
  TextEditingController textLocation= TextEditingController();

  String? _errorTextReason;
  String? _errorTextLocation;
  String? _errorTextEFD;
  String? _errorTextETD;

  DateTime? _firstDate;
  DateTime? _secondDate;

  DateTime? timeTo;
  DateTime? timeFrom;

  String? formattedTimeTo;
  String? formattedTimeFrom;

  String? firstDate;
  // String? secondDate;

  int? leaveID;

  dynamic leaveInterval;

  // double difference = 0;

  bool valueLeaveTypeFoH = false;
  bool valueLeaveTypeHalfOD = false;

  // String meal="";
  //String type="";
  bool valueFirstHalf = false;
  bool valueSecondHalf = false;
  String? empIDSp;

  @override
  void initState() {
    getEmpId();
    super.initState();
  }

  getEmpId() async {
    final prefs = await SharedPreferences.getInstance();
    empIDSp = prefs.getString('empID');
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
                              "Outdoor Duty Request",
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
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                  child: Row(
                    children: [
                      Text(
                        "Select Date and Time",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      height: MediaQuery
                          .of(context)
                          .size
                          .width / 7,
                      child: Center(
                          child: TextField(
                            controller: dateFromInput,
                            //editing controller of this TextField
                            decoration: InputDecoration(
                                errorText: _errorTextEFD,
                                errorBorder: const OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.indigo, width: 1.0),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1.0), //<-- SEE
                                ),
                                // enabledBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(width: 3, color: Colors.greenAccent), //<-- SEE
                                // ),
                                icon: Icon(Icons.calendar_today),
                                //icon of text field
                                labelText: "Enter Date"
                                //label text of field
                                ,
                                labelStyle: TextStyle(color: Colors.grey)),

                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              _errorTextEFD = null;
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2023),
                                  //DateTime.now() - not to a llow to choose before today.
                                  lastDate: DateTime(2100));

                              if (pickedDate != null) {
                                _firstDate = pickedDate;
                                print(
                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                String formattedDate = DateFormat('dd-MMM-yyyy')
                                    .format(pickedDate)
                                    .toUpperCase();
                                // DateFormat('yyyy-MM-dd').format(pickedDate);
                                print(
                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                setState(() {
                                  // difference = _calculateDifference()!;
                                  // print(
                                  //     "date pickedDate is: $difference"); //formatted date output using intl package =>  2021-03-16

                                  firstDate = formattedDate;
                                  dateFromInput.text =
                                      formattedDate; //set output date to TextField value.
                                });
                              } else {}
                            },
                          ))),
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                //   child: Container(
                //       padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                //       height: MediaQuery
                //           .of(context)
                //           .size
                //           .width / 7,
                //       child: Center(
                //           child: TextField(
                //             controller: dateToInput,
                //             //editing controller of this TextField
                //             decoration: InputDecoration(
                //                 errorText: _errorTextETD,
                //                 errorBorder: const OutlineInputBorder(
                //                   borderSide:
                //                   BorderSide(color: Colors.red, width: 1.0),
                //                   borderRadius:
                //                   BorderRadius.all(Radius.circular(5.0)),
                //                 ),
                //                 focusedBorder: OutlineInputBorder(
                //                   borderSide:
                //                   BorderSide(color: Colors.indigo, width: 1.0),
                //                   borderRadius:
                //                   BorderRadius.all(Radius.circular(5.0)),
                //                 ),
                //                 border: OutlineInputBorder(
                //                   borderSide: BorderSide(width: 1.0), //<-- SEE
                //                 ),
                //                 // enabledBorder: OutlineInputBorder(
                //                 //   borderSide: BorderSide(width: 3, color: Colors.greenAccent), //<-- SEE
                //                 // ),
                //                 icon: Icon(Icons.calendar_today),
                //                 //icon of text field
                //                 labelText: "Enter to Date",
                //                 labelStyle: TextStyle(
                //                     color: Colors.grey) //label text of field
                //             ),
                //             readOnly: true,
                //             //set it true, so that user will not able to edit text
                //             onTap: () async {
                //               _errorTextETD = null;
                //               DateTime? pickedDate = await showDatePicker(
                //                   context: context,
                //                   initialDate: DateTime.now(),
                //                   firstDate: DateTime(2023),
                //                   //DateTime.now() - not to a llow to choose before today.
                //                   lastDate: DateTime(2100));
                //
                //               if (pickedDate != null) {
                //                 _secondDate = pickedDate;
                //                 print(
                //                     pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                //                 String formattedDate = DateFormat('dd-MMM-yyyy')
                //                     .format(pickedDate)
                //                     .toUpperCase();
                //                 print("date formate is: $formattedDate");
                //
                //
                //                 //formatted date output using intl package =>  2021-03-16
                //                 setState(() {
                //                   difference = _calculateDifference()!;
                //                   print(
                //                       "date pickedDate is: $difference"); //formatted date output using intl package =>  2021-03-16
                //
                //                   secondDate = formattedDate;
                //                   dateToInput.text =
                //                       formattedDate; //set output date to TextField value.
                //                 });
                //               } else {}
                //             },
                //           ))),
                // ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                //   child: Row(
                //     children: [
                //       Text(
                //         "Days in number is: ${difference}",
                //         style: TextStyle(
                //             fontSize: 16, fontWeight: FontWeight.bold),
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .width / 5,
                    child: TextField(
                      maxLines: 5,
                      minLines: 3,
                      controller: textReason,
                      //keyboardType: TextInputType.number,
                      onTap: () {
                        _errorTextReason = null;
                      },
                      cursorColor: Colors.grey,
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                          errorText: _errorTextReason,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.red, width: 1.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                          ),
                          labelText: 'Reason',
                          labelStyle: TextStyle(color: Colors.grey)),
                    ),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .width / 5,
                    child: TextField(
                      maxLines: 3,
                      minLines:1,
                      controller: textLocation,
                      //keyboardType: TextInputType.number,
                      onTap: () {
                        _errorTextLocation = null;
                      },
                      cursorColor: Colors.grey,
                      style: TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                          errorText: _errorTextLocation,
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.red, width: 1.0),
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                          ),
                          labelText: 'Location',
                          labelStyle: TextStyle(color: Colors.grey)),
                    ),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Type"),
                      Row(
                        children: [
                          Text("Full Outdoor"),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.grey,
                            value: valueLeaveTypeFoH,
                            onChanged: (bool? value) {
                              setState(() {
                                // here

                                leaveID = 16;
                                leaveInterval = 1;
                                valueLeaveTypeFoH = value!;
                                valueLeaveTypeHalfOD = false;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Half Outdoor"),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.grey,
                            value: valueLeaveTypeHalfOD,
                            onChanged: (bool? value) {
                              setState(() {
                                leaveID = 19;
                                leaveInterval = 0.5;
                                valueLeaveTypeHalfOD = value!;
                                valueLeaveTypeFoH = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Visibility(

                  visible: valueLeaveTypeHalfOD,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Time"),
                        TextButton(
                          onPressed: () {
                            _selectTimeFrom(context);
                          },
                          child: Text(
                            timeFrom == null
                                ? 'Time From'
                                : formattedTimeFrom.toString(),
                          ),
                        ),
                        TextButton(
                          onPressed:  () {
                            _selectTimeTo(context);
                          },
                          child: Text(
                            timeTo == null
                                ? 'Time To'
                                : formattedTimeTo.toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      submitApi();
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

  Future<void> _selectTimeTo(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final DateTime now = DateTime.now();
      final DateTime selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      setState(() {
        valueSecondHalf=true;
        timeTo=selectedDateTime;
        formattedTimeTo = DateFormat('hh:mm a').format(
            selectedDateTime);
        print(formattedTimeTo);

        Duration? difference = timeTo?.difference(timeFrom!);
        print(difference);

        bool startsWithNegativeNumber = RegExp(r'^-\d').hasMatch(difference.toString());
        if(startsWithNegativeNumber){
          setState(() {
            valueSecondHalf=false;
            toast("Please select correct time!");
          });
        }
      });

     // Replace with your desired logic
    }
  }

  Future<void> _selectTimeFrom(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final DateTime now = DateTime.now();
      final DateTime selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      setState(() {
        valueFirstHalf=true;
        timeFrom=selectedDateTime;
        formattedTimeFrom = DateFormat('hh:mm a').format(
            selectedDateTime);
        print(formattedTimeFrom);

        Duration? difference = timeTo?.difference(timeFrom!);
        print(difference);

      });
     // Replace with your desired logic
    }
  }

  // double? _calculateDifference() {
  //   if (_firstDate != null && _secondDate != null) {
  //     double? a = _secondDate
  //         ?.difference(_firstDate!)
  //         .inDays
  //         .toDouble();
  //     return (a! + 1.0);
  //   }
  //   return 1.0;
  // }

  Future<void> submitApi() async {



    //var now = DateTime.now();
  //  var formatter = DateFormat('dd-MMM-yyyy');
  //  String formattedDate = formatter.format(now).toUpperCase();


    if (dateFromInput.text == "") {
      _errorTextEFD = "Required";
    }
    // else if (dateToInput.text == "") {
    //   _errorTextETD = "Required";
    // }
    // else if (difference.truncate() < 1.0) {
    //   toast("Select correct date!");
    // }
    else if (textReason.text == "") {
      _errorTextReason = 'Required';
    }   else if (textLocation.text == "") {
      _errorTextLocation = 'Required';
    } else if (valueLeaveTypeFoH == false && valueLeaveTypeHalfOD == false) {
      toast("Type must be Selected");
    }
    else if (valueLeaveTypeHalfOD == true &&
        (valueFirstHalf == false || valueSecondHalf == false)) {
      toast("Time must be Selected");
    }
    else {
      String username = 'xxhrms';
      String password = 'xxhrms';
      String basicAuth =
          'Basic ' + base64.encode(utf8.encode('$username:$password'));
      print(basicAuth);

      var concatTimeTo=firstDate;
      // var concatTimeFrom=secondDate;
      var concatTimeFrom=firstDate;
      if(valueLeaveTypeHalfOD){

        concatTimeTo="$firstDate $formattedTimeTo";
        concatTimeFrom="$firstDate $formattedTimeFrom";
        // concatTimeFrom="$secondDate $formattedTimeFrom";

      }

      print("concatTimeTo $concatTimeTo");
     print("concatTimeFrom $concatTimeFrom"); //| diffrence: ${difference.truncate()}
      print("summit outdoor $empIDSp | firstDate: $firstDate  | LeaveID: $leaveID  | leaveInterval:$leaveInterval | Reason: ${textReason.text} |Location: ${textLocation.text}");
      // print("formattedDate: $formattedDate");

      var requestBody ='''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sub="http://xmlns.oracle.com/orawsv/XXHRMS/SUBMIT_EMP_OUTDOOR">
   <soapenv:Header/>
   <soapenv:Body>
      <sub:SUBMIT_EMP_OUTDOORInput>
         <sub:P_TIME_TO-VARCHAR2-IN>$concatTimeTo</sub:P_TIME_TO-VARCHAR2-IN>
         <sub:P_TIME_FM-VARCHAR2-IN>$concatTimeFrom</sub:P_TIME_FM-VARCHAR2-IN>
         <sub:P_REASON-VARCHAR2-IN>${textReason.text}</sub:P_REASON-VARCHAR2-IN>
         <sub:P_OUTPUT-VARCHAR2-OUT/>
         <sub:P_L_DAY-NUMBER-IN>$leaveInterval</sub:P_L_DAY-NUMBER-IN>
         <sub:P_LV_ID-NUMBER-IN>$leaveID</sub:P_LV_ID-NUMBER-IN>
         <sub:P_LOCATION-VARCHAR2-IN>${textLocation.text}</sub:P_LOCATION-VARCHAR2-IN>
         <sub:P_EMP_ID-VARCHAR2-IN>$empIDSp</sub:P_EMP_ID-VARCHAR2-IN>
         <sub:P_DATE-DATE-IN>$firstDate</sub:P_DATE-DATE-IN>
      </sub:SUBMIT_EMP_OUTDOORInput>
   </soapenv:Body>
</soapenv:Envelope>''';

      var response = await post(        Uri.parse(
            'http://202.125.141.170:8080/orawsv/XXHRMS/SUBMIT_EMP_OUTDOOR'),
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
        //toast("Submited successfuly!");
        // setState(() {});
        // Output: OK
        final document = xml.XmlDocument.parse(xmlString);
        final outputElement = document
            .getElement('soap:Envelope')
            ?.getElement('soap:Body')
            ?.getElement('SUBMIT_EMP_OUTDOOROutput')
            ?.getElement('P_OUTPUT');

        final outputValue = outputElement?.text;
        print(outputValue);

        if (outputValue == "OutDoor Submitted") {
          final prefs = await SharedPreferences.getInstance();
          final String? approvalId = prefs.getString('approvalId');
          if(approvalId!.isNotEmpty){
            String notificationId = DateTime.now().toString();

            await sendTopicMessage(approvalId ?? "",'Outdoor Duty Request','New Outdoor Duty Request for approval',notificationId);
          }

          submitAlertCustom();
          //  toast("Submitted successfully!");
        } // prints "OK"
        else {
          errorCustom("$outputValue");
          toast("Submitted fail!");
        }
      }
    }

    setState(() {

    });
  }

  void submitAlertCustom() {
    Dialog doneDialog = Dialog(
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
                child: Lottie.network(
                    "https://assets10.lottiefiles.com/packages/lf20_8XY7J1RJeZ.json")),
            Padding(padding: EdgeInsets.only(top: 5.0)),
            TextButton(
                onPressed: () {
                  //  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                },
                child: Text(
                  'Close!',
                  style: TextStyle(color: Colors.green, fontSize: 16.0),
                ))
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => doneDialog);
  }

  void errorCustom(String msg) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
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
                  child: Lottie.network(
                      "https://assets10.lottiefiles.com/packages/lf20_O6BZqckTma.json")
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

}
