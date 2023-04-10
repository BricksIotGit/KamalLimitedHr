import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:kamal_limited/utils/Toast.dart';
import 'package:lottie/lottie.dart';
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
  bool valueHalfSickCheck = false;
  bool valueCasualCheck = false;
  bool valueHalfCasualCheck = false;
  bool valueAnnualCheck = false;

  // bool valueAnnualCheck2 = false;
  bool valueCPLCheck = false;

  DateTime? _firstDate;
  DateTime? _secondDate;
  double difference = 0;

  TextEditingController dateFromInput = TextEditingController();
  TextEditingController dateToInput = TextEditingController();

  TextEditingController textReason = TextEditingController();
  String? postLeaveID;
  String? postSessionID;

  List<Map<String, String>> employeesLeave = [];
  bool fetchOrNot = false;
  var checkAnnualDual = false;

  String? _errorTextReason;
  String? _errorTextEFD;
  String? _errorTextETD;
  String? sickBal, annualBal, annualBal2, casualBal, cplBal;
  String? sickDue, annualDue, annualDue2, casualDue, cplDue;
  String? sickFA, annualFA, annualFA2, casualFA, cplFA;
  String? sickHA, annualHA, annualHA2, casualHA, cplHA;
  String? sickID, annualID, annualID2, casualID, cplID;
  String? sickSession, annualSession, annualSession2, casualSession, cplSession;

  int? dualBal, dualDue, dualFa, dualHa;

  late int defaultChoiceIndex;
  List<String> _choicesList = [
    'Sick',
    'Annual',
    'Half Sick',
    'Casual',
    'CPL',
    'Half Casual'
  ];

  hitApi() async {
    final prefs = await SharedPreferences.getInstance();
    final String? empIDSp = prefs.getString('empID');

    String username = 'xxhrms';
    String password = 'xxhrms';
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);

    // 70500195 188700001 70500145 70500274 // $empIDSp 50500006
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
// Iterate over the ROW elements and extract the data

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
        if (checkAnnualDual == false) {
          annualBal = employeesLeave[i]["lvBal"];
          annualDue = employeesLeave[i]["lvDue"];
          annualID = employeesLeave[i]["lvId"];
          annualSession = employeesLeave[i]["sessionId"];
          annualFA = employeesLeave[i]["fullAvail"];
          annualHA = employeesLeave[i]["halfAvail"];

          //checkAnnualSession(annualSession!,annualBal!,"first");
          //checkAnnualSession("0");
          checkAnnualDual = true;
        } else {
          annualBal2 = employeesLeave[i]["lvBal"];
          annualDue2 = employeesLeave[i]["lvDue"];
          annualID2 = employeesLeave[i]["lvId"];
          annualSession2 = employeesLeave[i]["sessionId"];
          annualFA2 = employeesLeave[i]["fullAvail"];
          annualHA2 = employeesLeave[i]["halfAvail"];
          print(
              "annual dual check $checkAnnualDual , $annualBal2 , $annualBal");
          // checkAnnualSession(annualSession2!,annualBal2!,"second");

          if (annualBal2 != "null") {
            dualBal = int.parse(annualBal!) + int.parse(annualBal2!);
            dualDue = int.parse(annualDue!) + int.parse(annualDue2!);
            dualFa = int.parse(annualFA!) + int.parse(annualFA2!);
            dualHa = int.parse(annualHA!) + int.parse(annualHA2!);

            // annualBal=(annualBal!+annualBal2!)!;
            print(
                "annual dual if:  , $dualBal , $dualDue , $dualFa , $dualHa ");
            // checkAnnualSession("3");
          }
        }
        print("annual leave $annualDue $annualFA $annualHA $annualBal");
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
    super.initState();
    // ignore: avoid_print
    dateFromInput.text = ""; //set the initial value of text field
    dateToInput.text = ""; //set the initial value of text field
    // daysInNumCont.text = ""; //set the initial value of text field
    defaultChoiceIndex = 10;
    print("initState Called leave");
    hitApi();
  }

  double? _calculateDifference() {
    if (_firstDate != null && _secondDate != null) {
      double? a = _secondDate?.difference(_firstDate!).inDays.toDouble();

      print("cal 1: $a");
      if (a == 0 &&
          (valueHalfCasualCheck == true || valueHalfSickCheck == true)) {
        a = 0.5;
        print("cal 2: $a");

        return a;
      } else if (a == 0) {
        a = 1.0;
        print("cal 3: $a");

        return a;
      } else {
        print("cal 4: $a");

        a=1.0 + a!;
        print("cal 4: $a");

        // a=(a + 1.0);
        return a;
      }
    }
    return 0;
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
                            // Padding(
                            //     padding: EdgeInsets.all(0),
                            //     child: (annualBal2!="null")
                            //         ? Text(
                            //             "Annual ($annualSession2)",
                            //             style: TextStyle(fontSize: 15),
                            //           )
                            //         : SizedBox.shrink()),
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
                              child: (dualDue != null)
                                  ? Text(
                                      "$dualDue",
                                      style: TextStyle(fontSize: 15),
                                    )
                                  : Text(
                                      "$annualDue",
                                      style: TextStyle(fontSize: 15),
                                    ),
                            ),
                            // Padding(
                            //     padding: EdgeInsets.all(0),
                            //     child: checkAnnualDual
                            //         ? Text(
                            //             "$annualDue2",
                            //             style: TextStyle(fontSize: 15),
                            //           )
                            //         : SizedBox.shrink()),
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
                            Padding(
                                padding: const EdgeInsets.all(0),
                                child: (dualFa != null)
                                    ? Text(
                                        "$dualFa",
                                        style: TextStyle(fontSize: 15),
                                      )
                                    : Text(
                                        "$annualFA",
                                        style: TextStyle(fontSize: 15),
                                      )),
                            // Padding(
                            //     padding: EdgeInsets.all(0),
                            //     child: checkAnnualDual
                            //         ? Text(
                            //             "$annualFA2",
                            //             style: TextStyle(fontSize: 15),
                            //           )
                            //         : SizedBox.shrink()),
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
                            // Text(
                            //   "$annualHA",
                            //   style: TextStyle(fontSize: 15),
                            // ),
                            Padding(
                                padding: EdgeInsets.all(0),
                                child: (dualHa != null)
                                    ? Text(
                                        "$dualHa",
                                        style: TextStyle(fontSize: 15),
                                      )
                                    : Text(
                                        "$annualHA",
                                        style: TextStyle(fontSize: 15),
                                      )),
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
                            // Text(
                            //   "$annualBal",
                            //   style: TextStyle(fontSize: 15),
                            // ),
                            Padding(
                                padding: EdgeInsets.all(0),
                                child: (dualBal != null)
                                    ? Text(
                                        "$dualBal",
                                        style: TextStyle(fontSize: 15),
                                      )
                                    : Text(
                                        "$annualBal",
                                        style: TextStyle(fontSize: 15),
                                      )),
                            Text(
                              "$cplBal",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 20, 5),
                    child: Text(
                      "Select leave type: ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Wrap(
                      spacing: 5,
                      children: List.generate(_choicesList.length, (index) {
                        return ChoiceChip(
                          labelPadding: EdgeInsets.all(1.0),
                          label: Text(
                            _choicesList[index],
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.black, fontSize: 14),
                          ),
                          selected: defaultChoiceIndex == index,
                          selectedColor: Colors.grey,

                          backgroundColor: Colors.white,
                          onSelected: (value) {
                            setState(() {
                              defaultChoiceIndex =
                                  value ? index : defaultChoiceIndex;
                              print(
                                  "chip choice is: $defaultChoiceIndex value: $value and index: $index");

                              if (index == 0) {
                                valueSickCheck = value;

                                valueHalfSickCheck = false;
                                valueHalfCasualCheck = false;
                                valueCPLCheck = false;
                                // valueAnnualCheck2 = false;
                                valueAnnualCheck = false;
                                valueCasualCheck = false;
                                difference = _calculateDifference()!;
                                setState(() {});
                              } else if (index == 1) {
                                valueAnnualCheck = value;


                                  valueHalfSickCheck = false;
                                  valueHalfCasualCheck = false;
                                  valueCPLCheck = false;
                                  // valueAnnualCheck2 = false;
                                  valueSickCheck = false;
                                  valueCasualCheck = false;
                                  difference = _calculateDifference()!;
                                setState(() {  });
                              } else if (index == 2) {
                                valueHalfSickCheck = value;


                                  valueSickCheck = false;
                                  valueHalfCasualCheck = false;
                                  valueCPLCheck = false;
                                  // valueAnnualCheck2 = false;
                                  valueAnnualCheck = false;
                                  valueCasualCheck = false;
                                  difference = _calculateDifference()!;
                                setState(() {  });
                              } else if (index == 3) {
                                valueCasualCheck = value;
                                valueHalfSickCheck = false;
                                valueHalfCasualCheck = false;
                                valueCPLCheck = false;
                                // valueAnnualCheck2 = false;
                                valueAnnualCheck = false;
                                valueSickCheck = false;
                                difference = _calculateDifference()!;

                                setState(() {});
                              } else if (index == 4) {
                                valueCPLCheck = value;
                                valueHalfSickCheck = false;
                                valueHalfCasualCheck = false;
                                valueSickCheck = false;
                                valueAnnualCheck = false;
                                // valueAnnualCheck2 = false;
                                valueCasualCheck = false;
                                difference = _calculateDifference()!;

                                setState(() {});
                              } else if (index == 5) {
                                valueHalfCasualCheck = value;
                                valueHalfSickCheck = false;
                                valueCasualCheck = false;
                                valueCPLCheck = false;
                                // valueAnnualCheck2 = false;
                                valueAnnualCheck = false;
                                valueSickCheck = false;
                                difference = _calculateDifference()!;

                                setState(() {});
                              }
                            });
                          },
                          // backgroundColor: color,
                          elevation: 1,
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.widthMultiplier * 4),
                        );
                      }),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
                  child: Container(
                    height: MediaQuery.of(context).size.width / 5,
                    child: TextField(
                      maxLines: 5,
                      minLines: 3,
                      controller: textReason,
                      //keyboardType: TextInputType.number,
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
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      height: MediaQuery.of(context).size.width / 7,
                      child: Center(
                          child: TextField(
                        controller: dateFromInput,
                        //editing controller of this TextField
                        decoration: InputDecoration(
                            errorText: _errorTextEFD,
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
                            labelText: "Enter from Date"
                            //label text of field
                            ,
                            labelStyle: TextStyle(color: Colors.grey)),

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
                              difference = _calculateDifference()!;
                              print(
                                  "date pickedDate is: $difference"); //formatted date output using intl package =>  2021-03-16

                              dateFromInput.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                      ))),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      height: MediaQuery.of(context).size.width / 7,
                      child: Center(
                          child: TextField(
                        controller: dateToInput,
                        //editing controller of this TextField
                        decoration: InputDecoration(
                            errorText: _errorTextETD,
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
                            labelText: "Enter to Date",
                            labelStyle: TextStyle(
                                color: Colors.grey) //label text of field
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
                            _secondDate = pickedDate;
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate = DateFormat('dd-MMM-yyyy')
                                .format(pickedDate)
                                .toUpperCase();
                            // DateFormat('yyyy-MM-dd').format(pickedDate);
                            print(
                                "date formate is: $formattedDate"); //formatted date output using intl package =>  2021-03-16
                            setState(() {
                              difference = _calculateDifference()!;
                              print(
                                  "date pickedDate is: $difference"); //formatted date output using intl package =>  2021-03-16

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
                        "Days in number is: ${difference}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            textReason.text = "";
                            dateToInput.text = "";
                            dateFromInput.text = "";
                            _errorTextReason = null;
                            _errorTextEFD = null;
                            _errorTextETD = null;
                            defaultChoiceIndex = 10;
                          });
                        },
                        child: const Text('Clear',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Clrs.white,
                          shape: StadiumBorder(),
                          minimumSize: Size(150, 40),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Navigator.pushReplacement(context,
                          //     MaterialPageRoute(builder: (context) => Home()));

                          //  print("$sickID $casualID $annualID $cplID");
                          final prefs = await SharedPreferences.getInstance();
                          final String? empIDSp = prefs.getString('empID');

                          if (valueSickCheck || valueHalfSickCheck) {
                            postLeaveID = sickID;
                            postSessionID = sickSession;
                          } else if (valueCasualCheck || valueHalfCasualCheck) {
                            postLeaveID = casualID;
                            postSessionID = casualSession;
                          } else if (valueAnnualCheck) {
                            postLeaveID = annualID;
                            // postSessionID = annualSession;
                            postSessionID = checkAnnualSession();
                            print("check annual: $postSessionID ");
                          }

                          // else if (valueAnnualCheck2) {
                          //   postLeaveID = annualID2;
                          //   postSessionID = annualSession2;
                          // }

                          else if (valueCPLCheck) {
                            postLeaveID = cplID;
                            postSessionID = cplSession;
                          } else {
                            postLeaveID = '';
                            postSessionID = '';
                          }

                          bool checkLeaves = false;

                          if (postLeaveID == '12') {
                            //sick

                            var parseBln = double.parse(sickBal!);
                            print(
                                "sick postLeaveID bal: $parseBln and $difference");

                            if (parseBln >= difference) {
                              print("sick leave can post");
                              checkLeaves = true;
                            } else {
                              checkLeaves = false;
                             // toast("Cannot submit selected Leave type!");

                              print("sick leave can't post");
                            }
                          } else if (postLeaveID == '13') {
                            //anual

                            var parseBln = double.parse(annualBal!);
                            print(
                                "anual postLeaveID bal: $parseBln and $difference");

                            if (parseBln >= difference) {
                              print("anual leave can post");
                              checkLeaves = true;
                            } else {
                              checkLeaves = false;
                              //toast("Cannot submit selected Leave type!");

                              print("anual leave can't post");
                            }
                          } else if (postLeaveID == '11') {
                            //casual

                            var parseBln = double.parse(casualBal!);
                            print(
                                "casual postLeaveID bal: $parseBln and $difference");

                            if (parseBln >= difference) {
                              print("casual leave can post");
                              checkLeaves = true;
                            } else {
                              checkLeaves = false;
                              //toast("Cannot submit selected Leave type!");

                              print("casual leave can't post");
                            }
                          } else if (postLeaveID == '14') {
                            //cpl

                            var parseBln = double.parse(cplBal!);
                            print(
                                "cpl postLeaveID bal: $parseBln and $difference");

                            if (parseBln >= difference) {
                              print("cpl leave can post");
                              checkLeaves = true;
                            } else {
                              checkLeaves = false;
                            //  toast("Cannot submit selected Leave type!");

                              print("cpl leave can't post");
                            }
                          }

                          if (postSessionID == null || postSessionID == "") {
                            toast("Must select leave type!");
                            print("postsessionId is null");
                          } else if (empIDSp == null || empIDSp == "") {
                            print("empIDSp is null");
                          } else if (dateToInput.text == "") {
                            setState(() {
                              _errorTextETD = 'Required';
                            });
                            print("dateToInput.text is null");
                          } else if (dateFromInput.text == "") {
                            print("dateFromInput.text is null");
                            setState(() {
                              _errorTextEFD = 'Required';
                            });
                          } else if (textReason.text == "") {
                            print("daysInNumCont.text is null");
                            setState(() {
                              _errorTextReason = 'Required';
                            });
                          } else if (postLeaveID == null || postLeaveID == "") {
                            print("postLeaveID is null");
                          } else if (!checkLeaves) {
                            errorCustom("Cannot submit selected type!");

                           // toast("No due leave available!");
                            //toast("Cant submit request on this leave type!");
                          }
                          else if(difference <=  0.0){
                            errorCustom("Select correct dates!");

                          }
                          else {
                            setState(() {
                              _errorTextReason = null;
                              _errorTextEFD = null;
                              _errorTextETD = null;
                            });

                            //toast("Submitted");
                            print(
                                "postsesionID: ${postSessionID}  & Leave_ID: ${postLeaveID} & empID: ${empIDSp} To Date: ${dateToInput.text} & From Date: ${dateFromInput.text} & Days in Num: ${difference}");


                            submitApiHit(
                                postSessionID!,
                                empIDSp,
                                dateToInput.text,
                                dateFromInput.text,
                                difference.toString(),
                                postLeaveID!);
                          }
                        },
                        child: const Text('Submit',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Clrs.black,
                          shape: StadiumBorder(),
                          minimumSize: Size(150, 40),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitApiHit(
      String postSessionID,
      String empIDSp,
      String dateToInput,
      String dateFromInput,
      String daysInNumCont,
      String postLeaveID) async {
    // print("step in submit hit api");
    String username = 'xxhrms';
    String password = 'xxhrms';
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);

    // 70500195 188700001 70500145 70500274

    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sub="http://xmlns.oracle.com/orawsv/XXHRMS/SUBMIT_EMP_LEAVES">
   <soapenv:Header/>
   <soapenv:Body>
      <sub:SUBMIT_EMP_LEAVESInput>
         <sub:P_TO_DATE-DATE-IN>$dateToInput</sub:P_TO_DATE-DATE-IN>
         <sub:P_SESSION_ID-NUMBER-IN>$postSessionID</sub:P_SESSION_ID-NUMBER-IN>
         <sub:P_OUTPUT-VARCHAR2-OUT/>
         <sub:P_L_DAY-NUMBER-IN>$daysInNumCont</sub:P_L_DAY-NUMBER-IN>
         <sub:P_LV_ID-NUMBER-IN>$postLeaveID</sub:P_LV_ID-NUMBER-IN>
         <sub:P_FM_DATE-DATE-IN>$dateFromInput</sub:P_FM_DATE-DATE-IN>
         <sub:P_EMP_ID-VARCHAR2-IN>$empIDSp</sub:P_EMP_ID-VARCHAR2-IN>
         <sub:P_CPL_DATE-DATE-IN></sub:P_CPL_DATE-DATE-IN>
      </sub:SUBMIT_EMP_LEAVESInput>
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
      //toast("Submited successfuly!");
      // setState(() {});
      // Output: OK
      final document = xml.XmlDocument.parse(xmlString);
      final outputElement = document
          .getElement('soap:Envelope')
          ?.getElement('soap:Body')
          ?.getElement('SUBMIT_EMP_LEAVESOutput')
          ?.getElement('P_OUTPUT');

      final outputValue = outputElement?.text;
      print(outputValue);

      if (outputValue == "OK") {
        submitAlertCustom();
      //  toast("Submitted successfully!");
      } // prints "OK"
      else {
        errorCustom("$outputValue");
        toast("Submitted fail!");
      }
    }
  }

  String? checkAnnualSession() {
    print("checkAnnualSession enter $annualBal $annualBal2");
    print("checkAnnualSession session $annualSession $annualSession2"); //6 7 // 4 3
//here
    if (annualBal == "0") {
      print("checkAnnualSession if $annualSession");

      setState(() {
        annualSession = annualSession2;
        // annualSession = "3";
      });
      print("checkAnnualSession if $annualSession");
      return annualSession;
    }
    else if (annualBal2 == "0") {
      print("checkAnnualSession else $annualSession");

      setState(() {
        annualSession = annualSession;
        // annualSession = "4";
      });
      print("checkAnnualSession else $annualSession");

      return annualSession;
    }else {
      return annualSession;
    }
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
        context: context, builder: (BuildContext context) => doneDialog);
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

}
