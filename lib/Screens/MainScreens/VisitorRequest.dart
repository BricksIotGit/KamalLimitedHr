import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import '../../utils/Toast.dart';
import 'Home.dart';

class VisitorRequest extends StatefulWidget {
  const VisitorRequest({Key? key}) : super(key: key);

  @override
  _VisitorRequestState createState() => _VisitorRequestState();
}

class _VisitorRequestState extends State<VisitorRequest> {
  bool valueMealTypeSpecial = false;
  bool valueMealTypeStandard = false;
  bool valueMealTypeTea = false;
  bool valueMealTypeNone = false;


  String meal="";
  String type="";
  bool valueVisitorTypePer = false;
  bool valueVisitorTypeCom = false;
  bool isLoading = false;

  String? formattedTimeTo;
  String? formattedTimeFrom;
  DateTime? timeTo;
  DateTime? timeFrom;

  String? empID;
  String? empName;
  bool checkName=false;
  TextEditingController dateInputCont = TextEditingController();
  TextEditingController purposeCont = TextEditingController();
  TextEditingController visitorNameCont = TextEditingController();
  TextEditingController visitorNoCont = TextEditingController();
  String? _errorTextVN;
  String? _errorTextNo;
  String? _errorTextDate;
  String? _errorPurpose;

  Future<void> setEmp() async {
    final prefs = await SharedPreferences.getInstance();
    final String? empIDSp = prefs.getString('empID');
    final String? empNameSp = prefs.getString('empName');
    setState(() {
      empID = empIDSp;
      empName = empNameSp;
      if(empName!=null && empName!="" && empName?.length!=0){checkName=true;}
    });
  }

  @override
  void initState() {
    visitorNameCont.text == "";
    visitorNoCont.text == "";
    dateInputCont.text == "";
    purposeCont.text == "";

    setEmp();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async  {
        print('The user tries to pop()');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Home()));
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
                          "Visitor Request",
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
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child:checkName? Text("Host Name: $empName"):Text("Host ID: $empID")),
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                //   child: TextFormField(
                //
                //     cursorColor: Colors.black,
                //     style: const TextStyle(color: Colors.black),
                //     decoration: const InputDecoration(
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
                //         labelText: 'Host',
                //         labelStyle: TextStyle(color: Colors.black)),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: TextFormField(
                    controller: visitorNameCont,
                    cursorColor: Colors.grey,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        errorText: _errorTextVN,
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
                        labelText: 'Visitor Name',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: TextFormField(
                    controller: visitorNoCont,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        errorText: _errorTextNo,
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
                        labelText: 'No. of Visitors',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      height: MediaQuery.of(context).size.width / 7,
                      child: Center(
                          child: TextField(
                        controller: dateInputCont,
                        //editing controller of this TextField
                        decoration: InputDecoration(
                            errorText: _errorTextDate,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.indigo, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1.0),
                            ),
                            icon: Icon(Icons.calendar_today),
                            //icon of text field
                            labelText: "Enter Date" //label text of field
                            ),
                        readOnly: true,
                        //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023),
                              //DateTime.now() - not to a llow to choose before today.
                              lastDate: DateTime(2100));

                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate = DateFormat('dd-MMM-yyyy')
                                .format(pickedDate)
                                .toUpperCase();
                            // DateFormat('yyyy-MM-dd').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            setState(() {
                              dateInputCont.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                      ))),
                ),
                Padding(
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

                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Meal"),
                      Row(
                        children: [
                          Text("Special"),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.grey,
                            value: valueMealTypeSpecial,
                            onChanged: (bool? value) {
                              setState(() {
                                meal = "Special";
                                valueMealTypeSpecial = value!;
                                valueMealTypeStandard = false;
                                valueMealTypeTea=false; valueMealTypeNone=false;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Standard"),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.grey,
                            value: valueMealTypeStandard,
                            onChanged: (bool? value) {
                              setState(() {
                                meal = "Standard";

                                valueMealTypeStandard = value!;
                                valueMealTypeSpecial = false;
                                valueMealTypeTea=false; valueMealTypeNone=false;

                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text('         '),
                      Row(
                        children: [
                          Text("Tea"),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.grey,
                            value: valueMealTypeTea,
                            onChanged: (bool? value) {
                              setState(() {
                                meal = "Tea";

                                valueMealTypeTea=value!;
                                valueMealTypeNone=false;

                                valueMealTypeSpecial = false;
                                valueMealTypeStandard = false;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("None"),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.grey,
                            value: valueMealTypeNone,
                            onChanged: (bool? value) {
                              setState(() {
                                meal = "None";
                                valueMealTypeTea=false; valueMealTypeNone= value!;

                                valueMealTypeStandard =false;

                                valueMealTypeSpecial = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Padding(
                //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text("Type"),
                //       Row(
                //         children: [
                //           Text("Personal"),
                //           Checkbox(
                //             checkColor: Colors.white,
                //             activeColor: Colors.grey,
                //             value: valueVisitorTypePer,
                //             onChanged: (bool? value) {
                //               setState(() {
                //                 type = "Personal";
                //                 valueVisitorTypePer = value!;
                //                 valueVisitorTypeCom = false;
                //               });
                //             },
                //           ),
                //         ],
                //       ),
                //       Row(
                //         children: [
                //           Text("Company"),
                //           Checkbox(
                //             checkColor: Colors.white,
                //             activeColor: Colors.grey,
                //             value: valueVisitorTypeCom,
                //             onChanged: (bool? value) {
                //               setState(() {
                //                 type = "Company";
                //
                //                 valueVisitorTypeCom = value!;
                //                 valueVisitorTypePer = false;
                //               });
                //             },
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: TextFormField(
                    controller: purposeCont,
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        errorText: _errorPurpose,
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
                        labelText: 'Purpose',
                        labelStyle: TextStyle(color: Colors.grey)),
                    maxLines: 5,
                    minLines: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: () {


                      if (visitorNameCont.text == "") {
                        setState(() {
                          _errorTextVN = "Must required";
                        });
                      } else if (visitorNoCont.text == "") {
                        setState(() {
                          _errorTextNo = "Must Required";
                        });
                      } else if (dateInputCont.text == "") {
                        setState(() {
                          _errorTextDate = "Must Required";
                        });
                      } else if (purposeCont.text == "") {
                        setState(() {
                          _errorPurpose = "Must Required";
                        });
                      } else if (!valueMealTypeStandard &&
                          !valueMealTypeSpecial && !valueMealTypeNone && !valueMealTypeTea) {
                        toast("Select meal type!");
                      }
                      // else if (!valueVisitorTypePer && !valueVisitorTypeCom) {
                      //   toast("Select type of visitore!");
                      // }
                      else {
                        setState(() {
                          isLoading = true;
                          _errorTextDate = null;
                          _errorTextNo = null;
                          _errorTextVN = null;
                          _errorPurpose = null;
                        });

                        print(
                            "empID $empID & visitor name: ${visitorNameCont
                                .text} visit No: ${visitorNoCont
                                .text} & purpose: ${purposeCont.text} & $meal");
                        // here
                        submitHitApi(
                            empID!,
                            visitorNameCont.text,
                            visitorNoCont.text,
                            purposeCont.text,
                            dateInputCont.text,
                            meal,
                            type);

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

  Future<void> submitHitApi(String empID, String visitorName, String visitorNo,
      String purpose, String dateInput, String meal, String type) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MMM-yyyy').format(now).toUpperCase();
    print(formattedDate);
    print("step in submit hit api");
    String username = 'xxhrms';
    String password = 'xxhrms';
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);

    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:post="http://xmlns.oracle.com/orawsv/XXHRMS/POST_EMP_VISITOR_REQUEST">
   <soapenv:Header/>
   <soapenv:Body>
      <post:POST_EMP_VISITOR_REQUESTInput>
         <post:P_VISIT_PURPOSE-VARCHAR2-IN>$purpose</post:P_VISIT_PURPOSE-VARCHAR2-IN>
         <post:P_VISIT_DATE-DATE-IN>$dateInput</post:P_VISIT_DATE-DATE-IN>
         <post:P_VISITOR_NAME-VARCHAR2-IN>$visitorName</post:P_VISITOR_NAME-VARCHAR2-IN>
          <post:P_TIME_TO-VARCHAR2-IN>$formattedTimeTo</post:P_TIME_TO-VARCHAR2-IN>
         <post:P_TIME_FM-VARCHAR2-IN>$formattedTimeFrom</post:P_TIME_FM-VARCHAR2-IN>
         <post:P_REQUEST_DATE-DATE-IN>$formattedDate</post:P_REQUEST_DATE-DATE-IN>
         <post:P_REQUESTED_EMP_ID-VARCHAR2-IN>$empID</post:P_REQUESTED_EMP_ID-VARCHAR2-IN>
         <post:P_OUTPUT-VARCHAR2-OUT/>
         <post:P_NO_OF_VISITORS-NUMBER-IN>$visitorNo</post:P_NO_OF_VISITORS-NUMBER-IN>
         <post:P_MEAL_TYPE-VARCHAR2-IN>$meal</post:P_MEAL_TYPE-VARCHAR2-IN>
         <post:P_HOST_EMP_ID-VARCHAR2-IN>$empID</post:P_HOST_EMP_ID-VARCHAR2-IN>
      </post:POST_EMP_VISITOR_REQUESTInput>
   </soapenv:Body>
</soapenv:Envelope>''';

    var response = await post(
      Uri.parse(
          'http://202.125.141.170:8080/orawsv/XXHRMS/POST_EMP_VISITOR_REQUEST'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
     // toast("Submit successfuly!");
      setState(() {
        submitAlertCustom();
        isLoading = false;
        visitorNameCont.text = "";
        visitorNoCont.text = "";
        dateInputCont.text = "";
        purposeCont.text = "";
        valueMealTypeSpecial=false;
        valueMealTypeStandard=false;
        valueVisitorTypeCom=false;
        valueVisitorTypePer=false;
      });
    }
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
        // valueFirstHalf=true;
        timeFrom=selectedDateTime;
        formattedTimeFrom = DateFormat('hh:mm  a').format(
            selectedDateTime);
        print(formattedTimeFrom);

        Duration? difference = timeTo?.difference(timeFrom!);
        print(difference);

      });
      // Replace with your desired logic
    }
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
        // valueSecondHalf=true;
        timeTo=selectedDateTime;
        formattedTimeTo = DateFormat('hh:mm a').format(
            selectedDateTime);
        print(formattedTimeTo);

        Duration? difference = timeTo?.difference(timeFrom!);
        print(difference);

        bool startsWithNegativeNumber = RegExp(r'^-\d').hasMatch(difference.toString());
        if(startsWithNegativeNumber){
          setState(() {
            // valueSecondHalf=false;
            toast("Please select correct time!");
          });
        }
      });

      // Replace with your desired logic
    }
  }

}
