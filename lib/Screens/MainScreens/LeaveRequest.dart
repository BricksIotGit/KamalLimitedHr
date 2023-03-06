import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import 'Home.dart';

class LeaveRequest extends StatefulWidget {
  const LeaveRequest({Key? key}) : super(key: key);

  @override
  _LeaveRequestState createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<LeaveRequest> {
  bool valueSickCheck = false;
  bool valueCasualCheck = false;
  bool valueAnnualCheck = false;
  bool valueCPLCheck = false;
  TextEditingController dateFromInput = TextEditingController();
  TextEditingController dateToInput = TextEditingController();
  TextEditingController daysInNumCont = TextEditingController();
  String? postLeaveID;
  String? postSessionID;

  List<Map<String, String>> employeesLeave = [];
  bool fetchOrNot = false;

  String? sickBal, annualBal, casualBal, cplBal;
  String? sickDue, annualDue, casualDue, cplDue;
  String? sickFA, annualFA, casualFA, cplFA;
  String? sickHA, annualHA, casualHA, cplHA;
  String? sickID, annualID, casualID, cplID;
  String? sickSession, annualSession, casualSession, cplSession;

  // final RestorableDateTime _selectedDate =
  //     RestorableDateTime(DateTime(2023, 7, 25));
  // late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
  //     RestorableRouteFuture<DateTime?>(
  //   onComplete: _selectDate,
  //   onPresent: (NavigatorState navigator, Object? arguments) {
  //     return navigator.restorablePush(
  //       _datePickerRoute,
  //       arguments: _selectedDate.value.millisecondsSinceEpoch,
  //     );
  //   },
  // );

  // void _selectDate(DateTime? newSelectedDate) {
  //   if (newSelectedDate != null) {
  //     setState(() {
  //       _selectedDate.value = newSelectedDate;
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text(
  //             'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
  //       ));
  //     });
  //   }
  // }

  // static Route<DateTime> _datePickerRoute(
  //   BuildContext context,
  //   Object? arguments,
  // ) {
  //   return DialogRoute<DateTime>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return DatePickerDialog(
  //         restorationId: 'date_picker_dialog',
  //         initialEntryMode: DatePickerEntryMode.calendarOnly,
  //         initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
  //         firstDate: DateTime(2023),
  //         lastDate: DateTime(2099),
  //       );
  //     },
  //   );
  // }

  hitApi() async {
    final prefs = await SharedPreferences.getInstance();
    final String? empIDSp = prefs.getString('empID');

    String username = 'xxhrms';
    String password = 'xxhrms';
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);

    // 70500195 188700001 70500145 70500274
    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_LEAVES">
   <soapenv:Header/>
   <soapenv:Body>
      <get:GET_EMP_LEAVESInput>
         <get:P_OUTPUT-XMLTYPE-OUT/>
         <get:P_EMP_ID-VARCHAR2-IN>$empIDSp</get:P_EMP_ID-VARCHAR2-IN>
      </get:GET_EMP_LEAVESInput>
   </soapenv:Body>
</soapenv:Envelope>''';

    var response = await post(
      Uri.parse('http://202.125.141.170:8080/orawsv/XXHRMS/GET_EMP_LEAVES'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        fetchOrNot = true;
      });
    }
    // Parse XML data
    var xmlSP = response.body.toString();

    final document = xml.XmlDocument.parse(xmlSP);
    print("Response document: ${document}");
    print(
        "Response document length: ${document.findAllElements('ROWSET').length}");

    final rowset = document.findAllElements('ROWSET').first;
    var rowElements = document.findAllElements('ROW');
    print("Response employeesNode: ${rowset}");

    for (var row in rowset.findAllElements('ROW')) {
      print("row loop $row");
      final empId = row.findElements('EMP_ID').single.text;

      final lvType = row.findElements('LV_TYPE').single.text;
      final lvId = row.findElements('LV_ID').single.text;
      final lvBal = row.findElements('LV_BAL').single.text;
      final sessionId = row.findElements('SESSION_ID').single.text;
      final lvDue = row.findElements('LV_DUE').single.text;
      final fullAvail = row.findElements('FULL_AVAIL').single.text;
      final halfAvail = row.findElements('HALF_AVAIL').single.text;

      employeesLeave.add({
        'empId': empId,
        'lvBal': lvBal,
        'lvId': lvId,
        'sessionId': sessionId,
        'lvDue': lvDue,
        'fullAvail': fullAvail,
        'halfAvail': halfAvail,
        'lvType': lvType,
      });

      //  print("Response employees leave loop: ${employeesLeave[0]["LV_TYPE"]}");

    }

    // print("Response employees leave: ${employeesLeave[0]["LV_TYPE"]}");
    print("Response employees: $employeesLeave");

    for (var i = 0; i < employeesLeave.length; i++) {
      print("Response employees i loop: ${employeesLeave[i]}");

      if (employeesLeave[i]["lvType"] == "SICK LEAVE") {
        sickBal = employeesLeave[i]["lvBal"];
        sickDue = employeesLeave[i]["lvDue"];
        sickID = employeesLeave[i]["lvId"];
        sickSession = employeesLeave[i]["sessionId"];
        sickFA = employeesLeave[i]["fullAvail"];
        sickHA = employeesLeave[i]["halfAvail"];

        print("sick leave $sickSession $sickID $sickDue $sickBal");
      } else if (employeesLeave[i]["lvType"] == "ANUAL LEAVE") {
        annualBal = employeesLeave[i]["lvBal"];
        annualDue = employeesLeave[i]["lvDue"];
        annualID = employeesLeave[i]["lvId"];
        annualSession = employeesLeave[i]["sessionId"];
        annualFA = employeesLeave[i]["fullAvail"];
        annualHA = employeesLeave[i]["halfAvail"];

        print("anual leave $annualID $annualSession $annualDue $annualBal");
      } else if (employeesLeave[i]["lvType"] == "CPL LEAVE") {
        cplBal = employeesLeave[i]["lvBal"];
        cplDue = employeesLeave[i]["lvDue"];
        cplID = employeesLeave[i]["lvId"];
        cplSession = employeesLeave[i]["sessionId"];
        cplFA = employeesLeave[i]["fullAvail"];
        cplHA = employeesLeave[i]["halfAvail"];
        print("cpl leave $cplID $cplSession $cplDue $cplBal");
      } else if (employeesLeave[i]["lvType"] == "CASUAL LEAVE") {
        casualBal = employeesLeave[i]["lvBal"];
        casualDue = employeesLeave[i]["lvDue"];
        casualID = employeesLeave[i]["lvId"];
        casualSession = employeesLeave[i]["sessionId"];
        casualFA = employeesLeave[i]["fullAvail"];
        casualHA = employeesLeave[i]["halfAvail"];
        print("casual leave $casualID $casualSession $casualDue $casualBal");
      }
    }
    // for (var row in rowElements) {
    //   var empId = row.getElement('EMP_ID')?.text;
    //   var lvId = row.getElement('LV_ID')?.text;
    //   var lvType = row.getElement('LV_TYPE')?.text;
    //   var lvBal = row.getElement('LV_BAL')?.text;
    //
    //   print('Emp ID: $empId');
    //   print('LV ID: $lvId');
    //   print('LV Type: $lvType');
    //   print('LV Balance: $lvBal');
    // }
  }

  @override
  initState() {
    // ignore: avoid_print
    dateFromInput.text = ""; //set the initial value of text field
    dateToInput.text = ""; //set the initial value of text field
    daysInNumCont.text = ""; //set the initial value of text field

    print("initState Called leave");
    hitApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        "Leave Request",
                        style: TextStyle(color: Clrs.white, fontSize: 20),
                      )))
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Leave Type",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            "Sick",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "Casual",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "Annual",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "CPL",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Due",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "$sickDue",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "$casualDue",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "$annualDue",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "$cplDue",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Full Avail",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            "$sickFA",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "$casualFA",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "$annualFA",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "$cplFA",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Half Avail",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            "$sickHA",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "$casualHA",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "$annualHA",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "$cplHA",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Bal",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            "$sickBal",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "$casualBal",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "$annualBal",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "$cplBal",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 150,
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //
                    //     children: [
                    //       Text(
                    //         "Tick",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold, fontSize: 15),
                    //       ),
                    //       SizedBox(
                    //         width: 20,
                    //         height: 20,
                    //         child: Checkbox(
                    //           checkColor: Colors.white,
                    //           activeColor: Colors.grey,
                    //           value: this.valuefirst,
                    //           onChanged: (bool? value) {
                    //             setState(() {
                    //               this.valuefirst = value!;
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: 20,
                    //         height: 20,
                    //         child: Checkbox(
                    //           checkColor: Colors.white,
                    //           activeColor: Colors.grey,
                    //           value: this.valuefirst,
                    //           onChanged: (bool? value) {
                    //             setState(() {
                    //               this.valuefirst = value!;
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //
                    //       SizedBox(
                    //         width: 20,
                    //         height: 20,
                    //         child: Checkbox(
                    //           checkColor: Colors.white,
                    //           activeColor: Colors.grey,
                    //           value: this.valuefirst,
                    //           onChanged: (bool? value) {
                    //             setState(() {
                    //               this.valuefirst = value!;
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: 20,
                    //         height: 20,
                    //         child: Checkbox(
                    //           checkColor: Colors.white,
                    //           activeColor: Colors.grey,
                    //           value: this.valuefirst,
                    //           onChanged: (bool? value) {
                    //             setState(() {
                    //               this.valuefirst = value!;
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
              //   child: Row(
              //     children: [
              //       Text("Select from date: ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
              //        Text("Click  ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.blue),),
              //       // Icon(Icons.calendar_month_outlined,color: Colors.blue,)
              //
              //
              //     ],
              //   ),
              // ),
              //
              // OutlinedButton(
              //   onPressed: () {
              //     _restorableDatePickerRouteFuture.present();
              //   },
              //   child: const Text('Open Date Picker'),
              // ),

              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    height: MediaQuery.of(context).size.width / 7,
                    child: Center(
                        child: TextField(
                      controller: dateFromInput,
                      //editing controller of this TextField
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.indigo, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0), //<-- SEE HERE
                          ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(width: 3, color: Colors.greenAccent), //<-- SEE HERE
                          // ),
                          icon: Icon(Icons.calendar_today),
                          //icon of text field
                          labelText: "Enter from Date" //label text of field
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
                            dateFromInput.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {}
                      },
                    ))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    height: MediaQuery.of(context).size.width / 7,
                    child: Center(
                        child: TextField(
                      controller: dateToInput,
                      //editing controller of this TextField
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.indigo, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1.0), //<-- SEE HERE
                          ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(width: 3, color: Colors.greenAccent), //<-- SEE HERE
                          // ),
                          icon: Icon(Icons.calendar_today),
                          //icon of text field
                          labelText: "Enter to Date" //label text of field
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
                            dateToInput.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {}
                      },
                    ))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                child: Row(
                  children: [
                    Text(
                      "Select Days in Number: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 150,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        height: MediaQuery.of(context).size.width / 6,
                        child: TextField(
                          controller: daysInNumCont,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.black,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              labelText: 'Numbers',
                              labelStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Column(
                          children: [
                            Text("Sick leave"),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                checkColor: Colors.white,
                                activeColor: Colors.grey,
                                value: valueSickCheck,
                                onChanged: (bool? value) {
                                  setState(() {
                                    valueSickCheck = value!;

                                    valueCPLCheck = false;
                                    valueAnnualCheck = false;
                                    valueCasualCheck = false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Column(
                            children: [
                              Text("Casual leave"),
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: Colors.grey,
                                  value: valueCasualCheck,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      valueCasualCheck = value!;

                                      valueCPLCheck = false;
                                      valueAnnualCheck = false;
                                      valueSickCheck = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("Annual leave"),
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                checkColor: Colors.white,
                                activeColor: Colors.grey,
                                value: valueAnnualCheck,
                                onChanged: (bool? value) {
                                  setState(() {
                                    valueAnnualCheck = value!;

                                    valueCPLCheck = false;
                                    valueSickCheck = false;
                                    valueCasualCheck = false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Column(
                            children: [
                              Text("CPL leave"),
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: Colors.grey,
                                  value: valueCPLCheck,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      valueCPLCheck = value!;

                                      valueSickCheck = false;
                                      valueAnnualCheck = false;
                                      valueCasualCheck = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () async {
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => Home()));

                  //  print("$sickID $casualID $annualID $cplID");
                    final prefs = await SharedPreferences.getInstance();
                    final String? empIDSp = prefs.getString('empID');

                    if(valueSickCheck){
                      postLeaveID=sickID;
                      postSessionID=sickSession;
                    }
                    else if(valueCasualCheck){postLeaveID=casualID; postSessionID=casualSession;}
                    else if(valueAnnualCheck){postLeaveID=annualID; postSessionID=annualSession;}
                    else if(valueCPLCheck){postLeaveID=cplID; postSessionID=cplSession;}

                    print(
                        "sesionID: ${postSessionID} empID: ${empIDSp} To Date: ${dateToInput.text} & From Date: ${dateFromInput.text} & Days in Num: ${daysInNumCont.text} & Leave_ID: ${postLeaveID}");
                  },
                  child: Text('Submit',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Clrs.white,
                    shape: StadiumBorder(),
                    minimumSize: Size(250, 40),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
