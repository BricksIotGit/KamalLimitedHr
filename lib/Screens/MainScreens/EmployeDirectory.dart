import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import 'Home.dart';

class EmployeeDirectory extends StatefulWidget {
  const EmployeeDirectory({Key? key}) : super(key: key);

  @override
  _EmployeeDirectoryState createState() => _EmployeeDirectoryState();
}

class _EmployeeDirectoryState extends State<EmployeeDirectory> {
  String dropdownvalueLocat = 'Location';
  String dropdownvalueDepart = 'Location';
  TextEditingController textController = new TextEditingController();

  var itemsOfED = [
    'Location',
    'Leave Requests',
    'Request Approvals',
    'Attendance Summary',
    'Department Status',
    'Outdoor Duty Request',
    'Visitor Request',
    'Complain or Suggestions',
    'Announcements',
    'Contact Us',
    'Profile',
  ];

  var itemsOfdept = [
    'Location',
    'Leave Requests',
    'Request Approvals',
    'Attendance Summary',
    'Department Status',
    'Outdoor Duty Request',
    'Visitor Request',
    'Complain or Suggestions',
    'Announcements',
    'Contact Us',
    'Profile',
  ];
  String query = '';
  List results = [];

  List item2 = [
    {'name': 'Ali', 'id': '1', 'designation': 'Manager', 'dept': 'Hr'},
    {'name': 'Akbar', 'id': '2', 'designation': 'Assistant', 'dept': 'Finance'},
    {'name': 'Saif', 'id': '3', 'designation': 'GM Manager', 'dept': 'IT'},
    {'name': 'Akbar', 'id': '4', 'designation': 'Manager', 'dept': 'Hr'},
    {'name': 'Saif', 'id': '5', 'designation': 'Manager', 'dept': 'IT'},
    {'name': 'Rehan', 'id': '6', 'designation': 'Manager', 'dept': 'Hr'},
    {'name': 'Ali', 'id': '7', 'designation': 'Manager', 'dept': 'IT'},
    {'name': 'Rehan', 'id': '8', 'designation': 'Manager', 'dept': 'Hr'},
    {'name': 'Ali', 'id': '9', 'designation': 'Manager', 'dept': 'Hr'},
  ];

  void setResults(String query) {
    setState(() {
      //createPDF();
      print('row is ${item2}');
      print("name: ${item2[0]['name']}");

      results = item2
          .where((elem) =>
              // elem.id
              //     .toString()
              //     .toLowerCase()
              //     .contains(query.toLowerCase()) ||

              elem['name']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();

      //  print("resul 2: ${results}");
      print("resul ${results[0]['name']}");

      print("length before ${item2.length}");

      item2 = results;
      print("length after ${item2.length}");
    });
    // createPDF();
  }

  void reasign() {
    setState(() {
      item2 = [
        {'name': 'Ali', 'id': '1', 'designation': 'Manager', 'dept': 'Hr'},
        {
          'name': 'Akbar',
          'id': '2',
          'designation': 'Assistant',
          'dept': 'Finance'
        },
        {'name': 'Saif', 'id': '3', 'designation': 'GM Manager', 'dept': 'IT'},
        {'name': 'Akbar', 'id': '4', 'designation': 'Manager', 'dept': 'Hr'},
        {'name': 'Saif', 'id': '5', 'designation': 'Manager', 'dept': 'IT'},
        {'name': 'Rehan', 'id': '6', 'designation': 'Manager', 'dept': 'Hr'},
        {'name': 'Ali', 'id': '7', 'designation': 'Manager', 'dept': 'IT'},
        {'name': 'Rehan', 'id': '8', 'designation': 'Manager', 'dept': 'Hr'},
        {'name': 'Ali', 'id': '9', 'designation': 'Manager', 'dept': 'Hr'},
      ];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Image(
                    //   height:50* SizeConfig.heightMultiplier,
                    width: 100 * SizeConfig.widthMultiplier,
                    image: AssetImage(Images.header_grey),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                    child: Center(
                        child: Text(
                      "Employe Directory",
                      style: TextStyle(color: Clrs.white, fontSize: 20),
                    )),
                  ),
                  Positioned(
                    top: 8 * SizeConfig.heightMultiplier,
                    width: 100 * SizeConfig.widthMultiplier,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        //  color: Clrs.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          //Center Row contents horizontally,

                          children: [
                            Container(
                              //color: Colors.white,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                // boxShadow: [
                                //   BoxShadow(color: Colors.grey, spreadRadius: 3),
                                // ],
                              ),
                              child: SizedBox(
                                width: SizeConfig.widthMultiplier * 75,
                                child: CupertinoSearchTextField(
                                  controller: textController,
                                  autocorrect: true,

                                  onChanged: (v) {
                                    setState(() {
                                      query = v;
                                      if (query.length < 1) {
                                        // getDocumentListApiCall();
                                        reasign();
                                      }
                                      setResults(query);
                                    });
                                  },
                                ),
                              ),
                            ),
                            // AnimSearchBar(
                            //   width: 90 * SizeConfig.widthMultiplier,
                            //   textController: textController,
                            //   onSuffixTap: () {
                            //     setState(() {
                            //       textController.clear();
                            //     });
                            //   },
                            //   onSubmitted: (String) {},
                            // ),
                            // Image(
                            //   //   height:50* SizeConfig.heightMultiplier,
                            //   width: 10 * SizeConfig.widthMultiplier,
                            //   image: AssetImage(Images.search_ic),
                            // ),
                            Image(
                              //   height:50* SizeConfig.heightMultiplier,
                              width: 10 * SizeConfig.widthMultiplier,
                              image: AssetImage(Images.notification_ic),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                    child: Container(
                      width: 35 * SizeConfig.widthMultiplier,
                      child: SizedBox(
                        width: 30 * SizeConfig.widthMultiplier,
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 5),
                            //this one
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Clrs.light_Grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Clrs.light_Grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Clrs.light_Grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Clrs.medium_Grey,
                          ),
                          dropdownColor: Clrs.light_Grey,
                          // Initial Value
                          value: dropdownvalueLocat,
                          // Down Arrow Ico
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: itemsOfED.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalueLocat = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                    child: Container(
                      width: 35 * SizeConfig.widthMultiplier,
                      child: SizedBox(
                        width: 30 * SizeConfig.widthMultiplier,
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 5),
                            //this one

                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Clrs.light_Grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Clrs.light_Grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Clrs.light_Grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Clrs.medium_Grey,
                          ),
                          dropdownColor: Clrs.light_Grey,
                          // Initial Value
                          value: dropdownvalueDepart,
                          // Down Arrow Ico
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: itemsOfdept.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalueDepart = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Clrs.medium_Grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Clrs.light_Grey,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sr.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Clrs.dark_Grey),
                        ),
                        Text(
                          "Name.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Clrs.dark_Grey),
                        ),
                        Text(
                          "Designation.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Clrs.dark_Grey),
                        ),
                        Text(
                          "Dept.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Clrs.dark_Grey),
                        ),
                        Text(
                          "Status.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Clrs.dark_Grey),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: item2.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Clrs.medium_Grey),
                            borderRadius: BorderRadius.circular(10),
                            color: Clrs.white,
                          ),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: Text(
                                      item2[index]['id']!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1),
                                Flexible(
                                    child: Text(
                                      item2[index]['name']!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1),
                                Flexible(
                                    child: Text(
                                      item2[index]['designation']!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1),
                                Flexible(
                                    child: Text(
                                      item2[index]['dept']!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1),
                                Flexible(
                                    child: Text(
                                      "Info.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1)
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )

              // Padding(
              //   padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Clrs.medium_Grey),
              //       borderRadius: BorderRadius.circular(10),
              //       color: Clrs.white,
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(15.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text("1.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("Ali",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("GM Manager",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("Hr",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("Info.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),)
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Clrs.medium_Grey),
              //       borderRadius: BorderRadius.circular(10),
              //       color: Clrs.white,
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(15.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text("1.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("Ali",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("GM Manager",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("Hr",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("Info.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),)
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Clrs.medium_Grey),
              //       borderRadius: BorderRadius.circular(10),
              //       color: Clrs.white,
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(15.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text("1.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("Ali",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("GM Manager",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("Hr",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("Info.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),)
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Clrs.medium_Grey),
              //       borderRadius: BorderRadius.circular(10),
              //       color: Clrs.white,
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(15.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text("2.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("Ali",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("GM Manager",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("Hr",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("Info.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),)
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Clrs.medium_Grey),
              //       borderRadius: BorderRadius.circular(10),
              //       color: Clrs.white,
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.all(15.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text("1.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("Ali",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("GM Manager",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("Hr",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
              //           Text("Info.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),)
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
