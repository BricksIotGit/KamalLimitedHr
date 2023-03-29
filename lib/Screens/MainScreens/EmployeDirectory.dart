import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:xml/xml.dart' as xml;

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
  String dropdownvalueDesig = 'ALL';
  String dropdownvalueDepart = 'ALL';

  String infoEmpId = "0000";
  String infoEmpDesignLvl = "0000";
  String infoEmpDvName = "0000";
  String infoEmpDvEmail = "0000";

  TextEditingController textController = new TextEditingController();
  bool fetchOrNot = false;
  List<Map<String, String>> employeesDirectory = [];
  List<Map<String, String>> employeesDirectoryBackup = [];

  var itemsOfDg = [
    'ALL',
    'RECEPTIONIST',
    'EXECUTIVE',
    'DEPUTY MANAGER',
    'MANAGER',
    'GENERAL MANAGER',
    'ASSISTANT MANAGER',
    'SENIOR MANAGER',
    'ASSISTANT BUSINESS ANALYST',
    'OFFICER',
    'ASSISTANT NETWORK ADMINISTRATOR',
    'INCHARGE',
    'RECRUITMENT ASSOCIATE',
    'TIME KEEPER',
    'OFFICE BOY',
    'SUPERVISOR',
    'GATE CLERK',
    'CCTV OPERATOR',
    'EXCHANGE OPERATOR',
    'SWEEPER',
    'DRIVER',
    'SECURITY GUARD',
  ];

  var itemsOfdept = [
    'ALL',
    'GD - ADMINISTRATION',
    'GD - INTERNAL AUDIT',
    'GD - COSTING',
    'GD - IMPORT & EXPORT',
    'GD - INFORMATION TECHNOLOGY',
    'GD - HUMAN RESOURCES',
  ];
  String query = '';
  List<Map<String, String>> results = [];

  void searchFunc(String search, int first) {
    setState(() {
      //createPDF();

      print(
          '2 desig is:  ${dropdownvalueDesig} and dept is:$dropdownvalueDepart');
      // print("name: ${employeesDirectory[0]['ename']}");

      if (first == 1 &&
          dropdownvalueDepart == "ALL" &&
          dropdownvalueDesig == "ALL") {
        print('1');

        results = employeesDirectoryBackup
            .where((elem) =>
                // elem['empDesig']
                //     .toString()
                //     .toLowerCase()
                //     .contains(query.toLowerCase()) ||
                elem['ename']
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();

        employeesDirectory = results;
      } else if (first == 1 &&
          dropdownvalueDepart != "ALL" &&
          dropdownvalueDesig == "ALL") {
        print('2');

        // results = employeesDirectoryBackup
        //      .where((elem) =>
        //  elem['empDpt']
        //      .toString()
        //      .toLowerCase()
        //      .contains(query.toLowerCase()))
        //      .toList();

        print("Length 1: ${results.length}");
        results = results
            .where((elem) => elem['ename']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
        print("Length 2: ${results.length}");

        employeesDirectory = results;
      } else if (first == 1 &&
          dropdownvalueDepart != "ALL" &&
          dropdownvalueDesig != "ALL") {
        print("3");
        results = employeesDirectoryBackup
            .where((elem) => elem['ename']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();

        // results = results
        //     .where((elem) =>
        // elem['empDpt']
        //     .toString()
        //     .toLowerCase()
        //     .contains(query.toLowerCase()))
        //     .toList();
        //
        // results = results
        //     .where((elem) =>
        // elem['empDesig']
        //     .toString()
        //     .toLowerCase()
        //     .contains(query.toLowerCase()))
        //     .toList();

        employeesDirectory = results;
      } else if (first == 1 &&
          dropdownvalueDepart == "ALL" &&
          dropdownvalueDesig != "ALL") {
        print("4");
        results = employeesDirectoryBackup
            .where((elem) => elem['ename']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();

        results = results
            .where((elem) => elem['empDpt']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();

        results = results
            .where((elem) => elem['empDesig']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();

        employeesDirectory = results;
      }

      //  print("resul 2: ${results}");
      // print("resul ${results[0]['ename']}");
      //print("length before ${employeesDirectory.length}");

      // employeesDirectory = results;
      // print("length after ${employeesDirectory.length}");
    });
  }

  void setResults(String query) {
    setState(() {
      //createPDF();
      print('row is ${employeesDirectory}');
      print("name: ${employeesDirectory[0]['ename']}");

      results = employeesDirectory
          .where((elem) =>
              // elem['empDesig']
              //     .toString()
              //     .toLowerCase()
              //     .contains(query.toLowerCase()) ||
              elem['ename']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();

      //  print("resul 2: ${results}");
      print("resul ${results[0]['ename']}");

      // print("length before ${employeesDirectory.length}");

      employeesDirectory = results;
      // print("length after ${employeesDirectory.length}");
    });
    // createPDF();
  }

  void setResultsDropDept(String query) {
    setState(() {
      results = employeesDirectoryBackup
          .where((elem) => elem['empDpt']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
      employeesDirectory = results;
    });
    // createPDF();
  }

  void setResultsDropDown(String query) {
    setState(() {
      //createPDF();
      print('EM length: ${employeesDirectory.length}');
      print('EMB length: ${employeesDirectoryBackup.length}');
      //  print("name: ${employeesDirectory[0]['ename']}");

      if (employeesDirectory.length == employeesDirectoryBackup.length) {
        results = employeesDirectoryBackup
            .where((elem) => elem['empDesig']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
        employeesDirectory = results;
      } else if (employeesDirectory.length == 0) {
        results = employeesDirectoryBackup
            .where((elem) => elem['empDpt']
                .toString()
                .toLowerCase()
                .contains(dropdownvalueDepart.toLowerCase()))
            .toList();
        employeesDirectory = results;
        //setResultsDropDown(query);
      } else {
        results = employeesDirectory
            .where((elem) => elem['empDesig']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
        employeesDirectory = results;
      }

      //  print("resul 2: ${results}");
      // print("resul ${results[0]['ename']}");

      // print("length before ${employeesDirectory.length}");

      //  print("length after ${employeesDirectory.length}");
    });
    // createPDF();
  }

  void reasign() {
    setState(() {
      // hitApi();

      employeesDirectory = employeesDirectoryBackup;
    });
  }

  @override
  void initState() {
    hitApi();
    super.initState();
  }

  hitApi() async {
    String username = 'xxhrms';
    String password = 'xxhrms';
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);

    // 70500195 188700001 70500145 70500274
    var requestBody = '''<?xml version="1.0" encoding="utf-8"?>
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_DIRECTORY">
   <soapenv:Header/>
   <soapenv:Body>
      <get:GET_EMP_DIRECTORYInput>
         <get:P_OUTPUT-XMLTYPE-OUT/>
         <get:P_EMP_ID-NUMBER-IN>null</get:P_EMP_ID-NUMBER-IN>
      </get:GET_EMP_DIRECTORYInput>
   </soapenv:Body>
</soapenv:Envelope>''';

    var response = await post(
      Uri.parse('http://202.125.141.170:8080/orawsv/XXHRMS/GET_EMP_DIRECTORY'),
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
        fetchOrNot = true;
      });
    }
    // Parse XML data
    var xmlSP = response.body.toString();

    final document = xml.XmlDocument.parse(xmlSP);
    print("Response document: ${document}");
    print(
        "Response document length: ${document.findAllElements('ROWSET').length}");

    final rowset = document.findAllElements('ROWSET').last;

    print("Response employeesNode: ${rowset}");

    for (var row in rowset.findAllElements('ROW')) {
      final empId = row.findElements('EMP_ID').single.text;
      final ename = row.findElements('ENAME').single.text;
      final fname = row.findElements('FNAME').single.text;
      final gndr = row.findElements('GNDR').single.text;
      final empDpt = row.findElements('EMP_DEPARTMENT').single.text;
      final empDesig = row.findElements('EMP_DESIGNATION').single.text;
      final doj = row.findElements('DOJ').single.text;
      final doc = (row.findElements('DOC').isNotEmpty)
          ? row.findElements('DOC').single.text
          : "";
      final empEmail = (row.findElements('EMAIL').isNotEmpty)
          ? row.findElements('EMAIL').single.text
          : "";

      final empType = row.findElements('EMP_TYPE').single.text;

      final empShift = row.findElements('EMP_SHIFT').single.text;
      final empDvName = row.findElements('DIV_NAME').single.text;
      final empDesignLvl = row.findElements('EMP_DESIGNATION_LVL').single.text;

      employeesDirectory.add({
        'empId': empId,
        'ename': ename,
        'fname': fname,
        'gndr': gndr,
        'empDpt': empDpt,
        'empDesig': empDesig,
        'doj': doj,
        'doc': doc,
        'empType': empType,
        'empEmail': empEmail,
        'empShift': empShift,
        'empDvName': empDvName,
        'empDesignLvl': empDesignLvl,
      });

      employeesDirectoryBackup = employeesDirectory;
    }

    print("Response employees length: ${employeesDirectory.length}");
  }

  void infoAlertCustom() {
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
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Employee ID:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' $infoEmpId'),
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
                      text: 'Division Name: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' $infoEmpDvName'),
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
                      text: 'Email: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '$infoEmpDvEmail'),
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

  @override
  Widget build(BuildContext context) {
    if (fetchOrNot) {
      return WillPopScope(

        onWillPop: () async  {
          print('The user tries to pop()');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Home()));
          return false;
        },
        child: Scaffold(
          body: SafeArea(
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
                              MaterialPageRoute(builder: (context) => const Home()));
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
                        "Employee Directory",
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
                                        if (query.isEmpty) {
                                          reasign();
                                        }

                                        searchFunc(query, 1);
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
                                borderSide: BorderSide(
                                    color: Clrs.light_Grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Clrs.light_Grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Clrs.light_Grey, width: 1),
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
                            onTap: () {},
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalueDepart = newValue!;
                                if (dropdownvalueDepart == "ALL") {
                                  reasign();
                                } else {
                                  setResultsDropDept(dropdownvalueDepart);
                                }
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
                                borderSide: BorderSide(
                                    color: Clrs.light_Grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Clrs.light_Grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Clrs.light_Grey, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Clrs.medium_Grey,
                            ),
                            dropdownColor: Clrs.light_Grey,
                            // Initial Value
                            value: dropdownvalueDesig,
                            // Down Arrow Ico
                            icon: const Icon(Icons.keyboard_arrow_down),
                            // Array list of items
                            items: itemsOfDg.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            onTap: () {},
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalueDesig = newValue!;
                                print(
                                    "value Drup $dropdownvalueDesig and $newValue");
                                if (dropdownvalueDesig == "ALL") {
                                  reasign();
                                } else {
                                  setResultsDropDown(dropdownvalueDesig);
                                }
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                "Sr.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Clrs.dark_Grey),
                              ),
                              flex: 0),
                          Flexible(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Clrs.dark_Grey),
                                ),
                              ),
                              flex: 1),
                          Flexible(
                              child: Text(
                                "Dept.",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Clrs.dark_Grey),
                              ),
                              flex: 1),
                          Flexible(
                              child: Text(
                                "Designation",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Clrs.dark_Grey),
                              ),
                              flex: 1),
                          Flexible(
                              child: Text(
                                "Status",
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
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemCount: employeesDirectory.length,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                      child: Text(
                                        "${index + 1}",
                                        style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Clrs.dark_Grey),
                                      ),
                                      flex: 0),
                                  Flexible(
                                      child: Text(
                                        employeesDirectory[index]['ename']!,
                                        style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Clrs.dark_Grey),
                                      ),
                                      flex: 1),
                                  Flexible(
                                      child: Text(
                                        employeesDirectory[index]['empDpt']!,
                                        style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Clrs.dark_Grey),
                                      ),
                                      flex: 1),
                                  Flexible(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          employeesDirectory[index]
                                              ['empDesig']!,
                                          style: TextStyle(
                                              //fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Clrs.dark_Grey),
                                        ),
                                      ),
                                      flex: 1),
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {
                                        infoEmpId =
                                            employeesDirectory[index]['empId']!;
                                        infoEmpDvName =
                                            employeesDirectory[index]
                                                ['empDvName']!;
                                        infoEmpDesignLvl =
                                            employeesDirectory[index]
                                                ['empDesignLvl']!;
                                        infoEmpDvEmail =
                                            employeesDirectory[index]
                                                ['empEmail']!;

                                        infoAlertCustom();
                                      },
                                      child: Text(
                                        "Info.",
                                        style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Clrs.dark_Grey),
                                      ),
                                    ),
                                  )
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
    else {
      return (Scaffold(
        body: SafeArea(
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
                        "Employee Directory",
                        style: TextStyle(color: Clrs.white, fontSize: 20),
                      )))
                ],
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(150.0),
                child: CircularProgressIndicator(color: Colors.grey,),
              )),
            ],
          ),
        ),
      ));
    }
  }
}
