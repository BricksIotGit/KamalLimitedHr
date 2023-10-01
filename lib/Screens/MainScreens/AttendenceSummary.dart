import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import 'Home.dart';

class AttendanceSummary extends StatefulWidget {
  const AttendanceSummary({Key? key}) : super(key: key);

  @override
  _AttendanceSummaryState createState() => _AttendanceSummaryState();
}

enum SingingCharacter { lafayette, jefferson }

class _AttendanceSummaryState extends State<AttendanceSummary> {
  bool fetchOrNot = false;
  bool fetchOrNotOverall = false;
  List<Map<String, String>> attendanceSummaryList = [];
  List<Map<String, String>> monthlySummaryList = [];
  List<Map<String, String>> yearSummaryList = [];
  List<Map<String, String>> overallSummaryList = [];

  double pMonthPer = 0.0,
      aMonthPer = 0.0,
      lMonthPer = 0.0,
      gMonthPer = 0.0,
      tMonthPer = 100.0;

  double pYearPer = 0.0,
      aYearPer = 0.0,
      lYearPer = 0.0,
      gYearPer = 0.0,
      tYearPer = 100.0;

      double pOAPer = 0.0,
      aOAPer = 0.0,
      lOAPer = 0.0,
      gOAPer = 0.0,
      tOAPer = 100.0;

  String? empIDSp;
  String username = 'xxhrms';
  String password = 'xxhrms';
  String? basicAuth;

  @override
  void initState() {
    init();

    super.initState();
  }

  init() async {
    basicAuth = 'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);
    final prefs = await SharedPreferences.getInstance();
    empIDSp = prefs.getString('empID');
    hitApi();

    hitMonthApi();
    hitYearApi();
    hitOverallApi();

    Future.delayed(Duration(seconds: 4), () {
      if (fetchOrNotOverall) {
        calculatePercentage();
      }
    });
    setState(() {});
  }

  hitApi() async {
    fetchOrNot = true;
    // 70500195 188700001 70500145 70500274
    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_ATTENDANCE">
           <soapenv:Header/>
            <soapenv:Body>
            <get:GET_EMP_ATTENDANCEInput>
             <get:P_OUTPUT-XMLTYPE-OUT/>
               <get:P_EMP_ID-VARCHAR2-IN>'$empIDSp'</get:P_EMP_ID-VARCHAR2-IN>
             </get:GET_EMP_ATTENDANCEInput>
            </soapenv:Body>
            </soapenv:Envelope>''';

    var response = await post(
      Uri.parse('http://202.125.141.170:8080/orawsv/XXHRMS/GET_EMP_ATTENDANCE'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth.toString()
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        //fetchOrNot = true;
      });
    }
    // Parse XML data
    var xmlSP = response.body.toString();

    final document = xml.XmlDocument.parse(xmlSP);

    final elements = document.findAllElements('ROW');

    elements.forEach((node) {
      Map<String, String> map = {
        'EMP_ID': node.findElements('EMP_ID').single.text,
        'ATTND_DATE': node.findElements('ATTND_DATE').single.text,
        'TIME_IN': (node.findElements('TIME_IN').isNotEmpty)
            ? node.findElements('TIME_IN').single.text
            : "null",
        'TIME_OUT': (node.findElements('TIME_OUT').isNotEmpty)
            ? node.findElements('TIME_OUT').single.text
            : "null",
        'DUTY': node.findElements('DUTY').single.text,
        'STATUS': node.findElements('STATUS').single.text,
      };
      attendanceSummaryList.add(map);
      setState(() {
        fetchOrNot = false;
      });
    });

    print("");
    print("list of deptStatusList: $attendanceSummaryList");
  }

  hitMonthApi() async {
    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_ATTND_STATUS_MONTH">
   <soapenv:Header/>
   <soapenv:Body>
      <get:GET_ATTND_STATUS_MONTHInput>
         <get:P_OUTPUT-XMLTYPE-OUT/>
         <get:P_EMP_ID-VARCHAR2-IN>$empIDSp</get:P_EMP_ID-VARCHAR2-IN>
      </get:GET_ATTND_STATUS_MONTHInput>
   </soapenv:Body>
</soapenv:Envelope>''';

    var response = await post(
      Uri.parse(
          'http://202.125.141.170:8080/orawsv/XXHRMS/GET_ATTND_STATUS_MONTH'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth.toString()
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        var xmlSP = response.body.toString();

        final document = xml.XmlDocument.parse(xmlSP);

        // Find the elements using their tags
        final empId = document.findAllElements('EMP_ID').single.text;
        final pEmp = document.findAllElements('P_EMP').single.text;
        final aEmp = document.findAllElements('A_EMP').single.text;
        final lEmp = document.findAllElements('L_EMP').single.text;
        final gztEmp = document.findAllElements('GZT_EMP').single.text;
        final total = document.findAllElements('TOTAL').single.text;

        setState(() {
          monthlySummaryList.add({
            'empId': empId,
            'pEmp': pEmp,
            'aEmp': aEmp,
            'lEmp': lEmp,
            'gztEmp': gztEmp,
            'total': total,
          });
        });
      });
    }
  }

  hitYearApi() async {
    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_ATTND_STATUS_YEAR">
   <soapenv:Header/>
   <soapenv:Body>
      <get:GET_ATTND_STATUS_YEARInput>
         <get:P_OUTPUT-XMLTYPE-OUT/>
         <get:P_EMP_ID-VARCHAR2-IN>$empIDSp</get:P_EMP_ID-VARCHAR2-IN>
      </get:GET_ATTND_STATUS_YEARInput>
   </soapenv:Body>
</soapenv:Envelope>''';

    var response = await post(
      Uri.parse(
          'http://202.125.141.170:8080/orawsv/XXHRMS/GET_ATTND_STATUS_YEAR'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth.toString()
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        var xmlSP = response.body.toString();

        final document = xml.XmlDocument.parse(xmlSP);

        // Find the elements using their tags
        final empId = document.findAllElements('EMP_ID').single.text;
        final pEmp = document.findAllElements('P_EMP').single.text;
        final aEmp = document.findAllElements('A_EMP').single.text;
        final lEmp = document.findAllElements('L_EMP').single.text;
        final gztEmp = document.findAllElements('GZT_EMP').single.text;
        final total = document.findAllElements('TOTAL').single.text;

        setState(() {
          yearSummaryList.add({
            'empId': empId,
            'pEmp': pEmp,
            'aEmp': aEmp,
            'lEmp': lEmp,
            'gztEmp': gztEmp,
            'total': total,
          });
        });
      });
    }
  }

  hitOverallApi() async {
    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_ATTND_STATUS_OVERALL">
   <soapenv:Header/>
   <soapenv:Body>
      <get:GET_ATTND_STATUS_OVERALLInput>
         <get:P_OUTPUT-XMLTYPE-OUT/>
         <get:P_EMP_ID-VARCHAR2-IN>$empIDSp</get:P_EMP_ID-VARCHAR2-IN>
      </get:GET_ATTND_STATUS_OVERALLInput>
   </soapenv:Body>
</soapenv:Envelope>''';

    var response = await post(
      Uri.parse(
          'http://202.125.141.170:8080/orawsv/XXHRMS/GET_ATTND_STATUS_OVERALL'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth.toString()
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        var xmlSP = response.body.toString();

        final document = xml.XmlDocument.parse(xmlSP);

        // Find the elements using their tags
        final empId = document.findAllElements('EMP_ID').single.text;
        final pEmp = document.findAllElements('P_EMP').single.text;
        final aEmp = document.findAllElements('A_EMP').single.text;
        final lEmp = document.findAllElements('L_EMP').single.text;
        final gztEmp = document.findAllElements('GZT_EMP').single.text;
        final total = document.findAllElements('TOTAL').single.text;

        setState(() {
          fetchOrNotOverall = true;

          overallSummaryList.add({
            'empId': empId,
            'pEmp': pEmp,
            'aEmp': aEmp,
            'lEmp': lEmp,
            'gztEmp': gztEmp,
            'total': total,
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SingingCharacter? _character = SingingCharacter.jefferson;

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
                          "Attendance Summary",
                          style: TextStyle(color: Clrs.white, fontSize: 20),
                        )))
                  ],
                ),
                SizedBox(
                  width: SizeConfig.widthMultiplier * 90,
                  height: SizeConfig.heightMultiplier * 95,
                  child: Column(children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  infoAlertCustom();
                                },
                                child: Icon(
                                  Icons.info,
                                  color: Colors.grey, // Customize the icon color here
                                  size: 24, // Customize the icon size here
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Text("Month to Date"),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Table(
                                  defaultColumnWidth: FixedColumnWidth(45.0),
                                  children: [
                                    TableRow(children: [
                                      // Column(children: [Text('L')]),
                                      Column(children: [Text('P')]),
                                      Column(children: [Text('A')]),
                                      Column(children: [Text('L')]),
                                      Column(children: [Text('G')]),
                                      Column(children: [Text('T')]),
                                    ]),
                                  ],
                                ),
                              ),
                              fetchOrNotOverall
                                  ? Table(
                                      defaultColumnWidth:
                                          FixedColumnWidth(45.0),
                                      border: TableBorder.all(
                                          color: Clrs.dark_Grey,
                                          style: BorderStyle.solid,
                                          width: 1),
                                      children: [
                                        TableRow(children: [
                                          // Column(children: [Text('2')]),
                                          Column(children: [
                                            Text(
                                                '${monthlySummaryList[0]['pEmp']}')
                                          ]),
                                          Column(children: [
                                            Text(
                                                '${monthlySummaryList[0]['aEmp']}')
                                          ]),
                                          Column(children: [
                                            Text(
                                                '${monthlySummaryList[0]['lEmp']}')
                                          ]),
                                          Column(children: [
                                            Text(
                                                '${monthlySummaryList[0]['gztEmp']}')
                                          ]),
                                          Column(children: [
                                            Text(
                                                '${monthlySummaryList[0]['total']}')
                                          ]),
                                        ]),
                                        TableRow(children: [
                                          Column(children: [
                                            Text(
                                              '${pMonthPer.toInt()} %',
                                              style: (TextStyle(fontSize: 11)),
                                            )
                                          ]),
                                          Column(
                                              children: [Text(
                                                '${aMonthPer.toInt()} %',
                                                style: (TextStyle(fontSize: 11)),
                                              )]),
                                          Column(
                                              children: [Text(
                                                '${lMonthPer.toInt()} %',
                                                style: (TextStyle(fontSize: 11)),
                                              )]),
                                          Column(
                                              children: [Text(
                                                '${gMonthPer.toInt()} %',
                                                style: (TextStyle(fontSize: 11)),
                                              )]),
                                          Column(
                                              children: [Text(
                                                '${tMonthPer.toInt()} %',
                                                style: (TextStyle(fontSize: 11)),
                                              )]),
                                        ]),
                                      ],
                                    )
                                  : CircularProgressIndicator(
                                      color: Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text("Year to Date"),
                          ),
                          Column(
                            children: [
                              fetchOrNotOverall
                                  ? Table(
                                      defaultColumnWidth:
                                          FixedColumnWidth(45.0),
                                      border: TableBorder.all(
                                          color: Clrs.dark_Grey,
                                          style: BorderStyle.solid,
                                          width: 1),
                                      children: [
                                        TableRow(children: [
                                          //  Column(children: [Text('2')]),
                                          Column(children: [
                                            Text(
                                                '${yearSummaryList[0]['pEmp']}')
                                          ]),
                                          Column(children: [
                                            Text(
                                                '${yearSummaryList[0]['aEmp']}')
                                          ]),
                                          Column(children: [
                                            Text(
                                                '${yearSummaryList[0]['lEmp']}')
                                          ]),
                                          Column(children: [
                                            Text(
                                                '${yearSummaryList[0]['gztEmp']}')
                                          ]),
                                          Column(children: [
                                            Text(
                                                '${yearSummaryList[0]['total']}')
                                          ]),
                                        ]),
                                        TableRow(children: [
                                          Column(children: [
                                            Text(
                                              '${pYearPer.toInt()} %',
                                              style: (TextStyle(fontSize: 11)),
                                            )
                                          ]),
                                          Column(
                                              children: [Text(
                                                '${aYearPer.toInt()} %',
                                                style: (TextStyle(fontSize: 11)),
                                              )]),
                                          Column(
                                              children: [Text(
                                                '${lYearPer.toInt()} %',
                                                style: (TextStyle(fontSize: 11)),
                                              )]),
                                          Column(
                                              children: [Text(
                                                '${gYearPer.toInt()} %',
                                                style: (TextStyle(fontSize: 11)),
                                              )]),
                                          Column(
                                              children: [Text(
                                                '${tYearPer.toInt()} %',
                                                style: (TextStyle(fontSize: 11)),
                                              )]),
                                        ]),
                                      ],
                                    )
                                  : CircularProgressIndicator(
                                      color: Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text("Overall"),
                          ),
                          Column(
                            children: [
                              fetchOrNotOverall
                                  ? Table(
                                      defaultColumnWidth:
                                          FixedColumnWidth(45.0),
                                      border: TableBorder.all(
                                          color: Clrs.dark_Grey,
                                          style: BorderStyle.solid,
                                          width: 1),
                                      children: [
                                        TableRow(children: [
                                          // Column(children: [Text('2')]),
                                          Column(children: [
                                            Text(
                                                '${overallSummaryList[0]['pEmp']}',     style: (TextStyle(fontSize: 12)))
                                          ]),
                                          Column(children: [
                                            Text(
                                                '${overallSummaryList[0]['aEmp']}',     style: (TextStyle(fontSize: 12)))
                                          ]),
                                          Column(children: [
                                            Text(
                                                '${overallSummaryList[0]['lEmp']}',     style: (TextStyle(fontSize: 12)))
                                          ]),
                                          Column(children: [
                                            Text(
                                                '${overallSummaryList[0]['gztEmp']}',     style: (TextStyle(fontSize: 12)))
                                          ]),
                                          Column(children: [
                                            Text(
                                                '${overallSummaryList[0]['total']}',     style: (TextStyle(fontSize: 12)),)
                                          ]),
                                        ]),
                                        TableRow(children: [
                                          Column(children: [
                                            Text(
                                              '${pOAPer.toInt()} %',
                                              style: (TextStyle(fontSize: 11)),
                                            )
                                          ]),
                                          Column(
                                              children: [Text(
                                                '${aOAPer.toInt()} %',
                                                style: (TextStyle(fontSize: 11)),
                                              )]),
                                          Column(
                                              children: [Text(
                                                '${lOAPer.toInt()} %',
                                                style: (TextStyle(fontSize: 11)),
                                              )]),
                                          Column(
                                              children: [Text(
                                                '${gOAPer.toInt()} %',
                                                style: (TextStyle(fontSize: 11)),
                                              )]),
                                          Column(
                                              children: [Text(
                                                '${tOAPer.toInt()} %',
                                                style: (TextStyle(fontSize: 11)),
                                              )]),
                                        ]),
                                      ],
                                    )
                                  : CircularProgressIndicator(
                                      color: Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Container(
                        // margin: const EdgeInsets.all(15.0),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0)),
                          color: Colors.black87,
                          border: Border.all(
                            color: Colors.black26,
                            //                   <--- border color
                            width: 1.0,
                          ),
                        ),
                        // color: Colors.black87,
                        child: SizedBox(
                            width: SizeConfig.widthMultiplier * 90,
                            child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text("Previous 30 days",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                                ))),
                      ),
                    ),
                    Container(
                      //  margin: const EdgeInsets.all(15.0),
                      // padding: const EdgeInsets.all(3.0),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black26,
                          //                   <--- border color
                          width: 1.0,
                        ),
                      ),

                      child: SizedBox(
                          width: SizeConfig.widthMultiplier * 90,
                          child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Center(
                                          child: Text("Date",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54)),
                                        ),
                                        flex: 1),
                                    Expanded(
                                        child: Center(
                                          child: Text("In",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54)),
                                        ),
                                        flex: 1),
                                    Expanded(
                                        child: Center(
                                          child: Text("Out",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54)),
                                        ),
                                        flex: 1),
                                    Expanded(
                                        child: Center(
                                          child: Text("Duty Time",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54)),
                                        ),
                                        flex: 1),
                                    Expanded(
                                        child: Center(
                                          child: Text("Status",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54)),
                                        ),
                                        flex: 1),
                                    // Text("Query",
                                    //     style: TextStyle(
                                    //         fontSize: 13, color: Colors.black54))
                                  ],
                                ),
                              ))),
                    ),
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: fetchOrNot
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: Colors.grey,
                              ),
                            )
                          : SizedBox(),
                    ),
                    SizedBox(
                      height: 50 * SizeConfig.heightMultiplier,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0)),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black26,
                            //                   <--- border color
                            width: 1.0,
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: attendanceSummaryList.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              //width: SizeConfig.widthMultiplier * 40,
                              child: Container(
                                // color: Colors.cyanAccent,
                                // decoration: BoxDecoration(
                                //   border: Border.all(color: Clrs.medium_Grey),
                                //   borderRadius: BorderRadius.circular(10),
                                //   color: Clrs.white,
                                // ),
                                child: ListTile(
                                  title: Column(
                                    children: [
                                      Row(

                                        children: [
                                          Expanded(
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    attendanceSummaryList[index]
                                                        ['ATTND_DATE']!,
                                                    style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Clrs.dark_Grey),
                                                  ),
                                                ),
                                              ),
                                              flex: 1),
                                          Expanded(
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    attendanceSummaryList[index]
                                                        ['TIME_IN']!,
                                                    style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Clrs.dark_Grey),
                                                  ),
                                                ),
                                              ),
                                              flex: 1),
                                          Expanded(
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    attendanceSummaryList[index]
                                                        ['TIME_OUT']!,
                                                    style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Clrs.dark_Grey),
                                                  ),
                                                ),
                                              ),
                                              flex: 1),
                                          Expanded(
                                              child: Center(
                                                child: Text(
                                                  attendanceSummaryList[index]
                                                      ['DUTY']!,
                                                  style: TextStyle(
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Clrs.dark_Grey),
                                                ),
                                              ),
                                              flex: 1),
                                          Expanded(
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    attendanceSummaryList[index]
                                                        ['STATUS']!,
                                                    style: TextStyle(
                                                        //  fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                        color: Clrs.dark_Grey),
                                                  ),
                                                ),
                                              ),
                                              flex: 1),

                                        ],
                                      ),
                                      Divider(),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculatePercentage() {
    pMonthPer = _percentage(
        monthlySummaryList[0]['pEmp'], monthlySummaryList[0]['total']);
    aMonthPer = _percentage(
        monthlySummaryList[0]['aEmp'], monthlySummaryList[0]['total']);
    lMonthPer = _percentage(
        monthlySummaryList[0]['lEmp'], monthlySummaryList[0]['total']);
    gMonthPer = _percentage(
        monthlySummaryList[0]['gztEmp'], monthlySummaryList[0]['total']);

    pYearPer = _percentage(
        yearSummaryList[0]['pEmp'], yearSummaryList[0]['total']);
    aYearPer = _percentage(
        yearSummaryList[0]['aEmp'], yearSummaryList[0]['total']);
    lYearPer = _percentage(
        yearSummaryList[0]['lEmp'], yearSummaryList[0]['total']);
    gYearPer = _percentage(
        yearSummaryList[0]['gztEmp'], yearSummaryList[0]['total']);


    pOAPer = _percentage(
        overallSummaryList[0]['pEmp'], overallSummaryList[0]['total']);
    aOAPer = _percentage(
        overallSummaryList[0]['aEmp'], overallSummaryList[0]['total']);
    lOAPer = _percentage(
        overallSummaryList[0]['lEmp'], overallSummaryList[0]['total']);
    gOAPer = _percentage(
        overallSummaryList[0]['gztEmp'], overallSummaryList[0]['total']);


    setState(() {});
  }

  _percentage(value, totalvalue) {
    var val1 = double.parse(value);
    var val2 = double.parse(totalvalue);

    var formula=(val1 / val2) * 100;

    if(formula.isNaN || formula.isInfinite){
      formula=0.0;
    }
    return formula;
  }

  void infoAlertCustom() {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 300.0,
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'P :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: 'Present'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'A :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: 'Absent'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'L: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: 'Leave'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'G :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: 'GZT'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'T :',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: 'Total'),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 50.0)),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
