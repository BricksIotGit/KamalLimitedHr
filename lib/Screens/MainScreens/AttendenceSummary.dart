import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
  List<Map<String, String>> attendanceSummaryList = [];

  @override
  void initState() {
    hitApi();

    super.initState();
  }

  hitApi() async {
    fetchOrNot = true;
    String username = 'xxhrms';
    String password = 'xxhrms';
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);

    // 70500195 188700001 70500145 70500274
    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_ATTENDANCE">
   <soapenv:Header/>
   <soapenv:Body>
      <get:GET_EMP_ATTENDANCEInput>
         <get:P_OUTPUT-XMLTYPE-OUT/>
         <get:P_EMP_ID-VARCHAR2-IN>'50500006'</get:P_EMP_ID-VARCHAR2-IN>
      </get:GET_EMP_ATTENDANCEInput>
   </soapenv:Body>
</soapenv:Envelope>''';

    var response = await post(
      Uri.parse('http://202.125.141.170:8080/orawsv/XXHRMS/GET_EMP_ATTENDANCE'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Text("Month to Date"),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Table(
                                  defaultColumnWidth: FixedColumnWidth(30.0),
                                  // border: TableBorder.all(
                                  //     color: Clrs.dark_Grey, style: BorderStyle.solid, width: 0),
                                  children: [
                                    TableRow(children: [
                                      Column(children: [Text('L')]),
                                      Column(children: [Text('P')]),
                                      Column(children: [Text('A')]),
                                      Column(children: [Text('L')]),
                                      Column(children: [Text('G')]),
                                      Column(children: [Text('T')]),
                                    ]),
                                  ],
                                ),
                              ),
                              Table(
                                defaultColumnWidth: FixedColumnWidth(30.0),
                                border: TableBorder.all(
                                    color: Clrs.dark_Grey,
                                    style: BorderStyle.solid,
                                    width: 1),
                                children: [
                                  TableRow(children: [
                                    Column(children: [Text('2')]),
                                    Column(children: [Text('2')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                  ]),
                                  TableRow(children: [
                                    Column(children: [Text('4')]),
                                    Column(children: [Text('4')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                  ]),
                                ],
                              ),
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
                              Table(
                                defaultColumnWidth: FixedColumnWidth(30.0),
                                border: TableBorder.all(
                                    color: Clrs.dark_Grey,
                                    style: BorderStyle.solid,
                                    width: 1),
                                children: [
                                  TableRow(children: [
                                    Column(children: [Text('2')]),
                                    Column(children: [Text('2')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                  ]),
                                  TableRow(children: [
                                    Column(children: [Text('4')]),
                                    Column(children: [Text('4')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                  ]),
                                ],
                              ),
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
                              Table(
                                defaultColumnWidth: FixedColumnWidth(30.0),
                                border: TableBorder.all(
                                    color: Clrs.dark_Grey,
                                    style: BorderStyle.solid,
                                    width: 1),
                                children: [
                                  TableRow(children: [
                                    Column(children: [Text('2')]),
                                    Column(children: [Text('2')]),
                                    Column(children: [Text('9')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                  ]),
                                  TableRow(children: [
                                    Column(children: [Text('4')]),
                                    Column(children: [Text('4')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                    Column(children: [Text('5')]),
                                  ]),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Padding(
                    //     padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    //     child:
                    //         Text("Select Date", style: TextStyle(fontSize: 16)),
                    //   ),
                    // ),
                    // ListTile(
                    //   title: const Text(
                    //     'Weekly',
                    //     style: TextStyle(fontSize: 14),
                    //   ),
                    //   leading: Radio<SingingCharacter>(
                    //     value: SingingCharacter.lafayette,
                    //     groupValue: _character,
                    //     onChanged: (SingingCharacter? value) {
                    //       setState(() {
                    //         _character = value;
                    //       });
                    //     },
                    //   ),
                    // ),
                    // ListTile(
                    //   title: const Text(
                    //     'Monthly',
                    //     style: TextStyle(fontSize: 14),
                    //   ),
                    //   leading: Radio<SingingCharacter>(
                    //     value: SingingCharacter.jefferson,
                    //     groupValue: _character,
                    //     onChanged: (SingingCharacter? value) {
                    //       setState(() {
                    //         _character = value;
                    //       });
                    //     },
                    //   ),
                    // ),

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
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: Center(
                                                child: Text(
                                                  attendanceSummaryList[index]
                                                      ['ATTND_DATE']!,
                                                  style: TextStyle(
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Clrs.dark_Grey),
                                                ),
                                              ),
                                              flex: 1),
                                          Expanded(
                                              child: Center(
                                                child: Text(
                                                  attendanceSummaryList[index]
                                                      ['TIME_IN']!,
                                                  style: TextStyle(
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Clrs.dark_Grey),
                                                ),
                                              ),
                                              flex: 1),
                                          Expanded(
                                              child: Center(
                                                child: Text(
                                                  attendanceSummaryList[index]
                                                      ['TIME_OUT']!,
                                                  style: TextStyle(
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Clrs.dark_Grey),
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
                                                child: Text(
                                                  attendanceSummaryList[index]
                                                      ['STATUS']!,
                                                  style: TextStyle(
                                                      //  fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                      color: Clrs.dark_Grey),
                                                ),
                                              ),
                                              flex: 1),
                                          // Flexible(
                                          //     child: ElevatedButton(
                                          //       onPressed: () {
                                          //         Navigator.pushReplacement(
                                          //             context,
                                          //             MaterialPageRoute(
                                          //                 builder: (context) =>
                                          //                     Home()));
                                          //       },
                                          //       child: Text('Action',
                                          //           style: TextStyle(
                                          //             fontSize: 7,
                                          //             color: Colors.black,
                                          //           )),
                                          //       style: ElevatedButton.styleFrom(
                                          //         backgroundColor: Clrs.white,
                                          //         shape: StadiumBorder(),
                                          //         minimumSize: Size(50, 20),
                                          //       ),
                                          //     ),
                                          //     flex: 1)
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
}
