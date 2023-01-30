import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    SingingCharacter? _character = SingingCharacter.lafayette;
    final item2 = [
      {'date': '1 Jan 23', 'in': '09:30', 'out': '05:00','dutyTime':'08:30', 'status': 'Present'},
      {'date': '2 Jan 23', 'in': '09:00', 'out': '05:00','dutyTime':'08:20', 'status': 'Absent'},
      {'date': '3 Jan 23', 'in': '09:50', 'out': '05:00', 'dutyTime':'08:10','status': 'Present'},
      {'date': '4 Jan 23', 'in': '09:20', 'out': '05:00', 'dutyTime':'08:60','status': 'Present'},
      {'date': '5 Jan 23', 'in': '09:00', 'out': '05:00', 'dutyTime':'08:30','status': 'Out-Missing'},
      {'date': '6 Jan 23', 'in': '09:00', 'out': '05:00','dutyTime':'08:70', 'status': 'Present'},
      {'date': '7 Jan 23', 'in': '09:20', 'out': '05:00','dutyTime':'08:20', 'status': 'Present'},
      {'date': '8 Jan 23', 'in': '09:00', 'out': '05:00', 'dutyTime':'08:30','status': 'Present'},

    ];
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
                        "Attendance Summary",
                        style: TextStyle(color: Clrs.white, fontSize: 20),
                      )))
                ],
              ),
              SizedBox(
                width: SizeConfig.widthMultiplier * 90,
                height: SizeConfig.heightMultiplier * 100,
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child:
                          Text("Select Date", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Weekly',
                      style: TextStyle(fontSize: 14),
                    ),
                    leading: Radio<SingingCharacter>(
                      value: SingingCharacter.lafayette,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      'Monthly',
                      style: TextStyle(fontSize: 14),
                    ),
                    leading: Radio<SingingCharacter>(
                      value: SingingCharacter.jefferson,
                      groupValue: _character,
                      onChanged: (SingingCharacter? value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),

                  Container(
                    // margin: const EdgeInsets.all(15.0),
                    // padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight:Radius.circular(10.0),topLeft: Radius.circular(10.0)),
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
                              child: Text("Current Week",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                            ))),
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
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Date",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black54)),
                                  Text("In",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black54)),
                                  Text("Out",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black54)),
                                  Text("Duty Time",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black54)),
                                  Text("Status",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black54)),
                                  Text("Query",
                                      style: TextStyle(
                                          fontSize: 13, color: Colors.black54))
                                ],
                              ),
                            ))),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight:Radius.circular(10.0),bottomLeft: Radius.circular(10.0)),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.black26,
                          //                   <--- border color
                          width: 1.0,
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: item2.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: SizeConfig.widthMultiplier * 90,
                            child: Container(
                              // decoration: BoxDecoration(
                              //   border: Border.all(color: Clrs.medium_Grey),
                              //   borderRadius: BorderRadius.circular(10),
                              //   color: Clrs.white,
                              // ),
                              child: ListTile(
                                title: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                            child: Text(
                                              item2[index]['date']!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Clrs.dark_Grey),
                                            ),
                                            flex: 1),
                                        Flexible(
                                            child: Text(
                                              item2[index]['in']!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Clrs.dark_Grey),
                                            ),
                                            flex: 1),
                                        Flexible(
                                            child: Text(
                                              item2[index]['out']!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Clrs.dark_Grey),
                                            ),
                                            flex: 1),
                                        Flexible(
                                            child: Text(
                                              item2[index]['dutyTime']!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Clrs.dark_Grey),
                                            ),
                                            flex: 1),
                                        Flexible(
                                            child: Text(
                                              item2[index]['status']!,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Clrs.dark_Grey),
                                            ),
                                            flex: 1),
                                        Flexible(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Home()));
                                              },
                                              child: Text('Action',
                                                  style: TextStyle(
                                                    fontSize: 7,
                                                    color: Colors.black,
                                                  )),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Clrs.white,
                                                shape: StadiumBorder(),
                                                minimumSize: Size(50, 20),
                                              ),
                                            ),
                                            flex: 1)
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

                  // Table(
                  //   defaultColumnWidth: FixedColumnWidth(30.0),
                  //
                  //   children: [
                  //
                  //     TableRow(children: [
                  //       Column(children: [Text('4')]),
                  //       Column(children: [Text('4')]),
                  //       Column(children: [Text('5')]),
                  //       Column(children: [Text('5')]),
                  //       Column(children: [Text('5')]),
                  //       Column(children: [Text('5')]),
                  //     ]),
                  //   ],
                  // ),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
