import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kamal_limited/utils/Toast.dart';
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

  String dropDesignQuery='null';
  String dropDeptQuery='null';

  String query = '';
  String searchQuery = 'null';
  List<Map<String, String>> results = [];


  String infoEmpId = "0000";
  String infoEmpDesignLvl = "0000";
  String infoEmpDvName = "0000";
  String infoEmpDvEmail = "0000";

  TextEditingController textController = new TextEditingController();
  bool fetchOrNot = false;
  List<Map<String, String>> employeesDirectory = [];
  List<Map<String, String>> employeesDirectoryAPISearch = [];
  List<Map<String, String>> employeesDirectoryBackup = [];

  //String username = 'xxhrms';
  //String password = 'xxhrms';
  String basicAuth = 'Basic ' + base64.encode(utf8.encode('xxhrms:xxhrms'));


  String? selectedDsgn;
  String? selectedDept;

  onDeptChanged(String? value) {

    print("onDeptChanged value $value");
    //dont change second dropdown if 1st item didnt change
    if (value != selectedDsgn) selectedDept = null;
    setState(() {
      selectedDsgn = value;
    });

    dropdownvalueDepart = value!;
    if (dropdownvalueDepart == "ALL") {
      dropDeptQuery='null';

    } else {
      dropDeptQuery="'$dropdownvalueDepart'";

    }
    dropDesignQuery="null";
    apiSearch();

  }

  late Map<String, List<String>> dataSetAll = {
    'ALL':itemsOfDg,
    'GD - ADMINISTRATION': adminDsgn,
    'GD - INTERNAL AUDIT': internalAuditDsgn,
    'GD - COSTING': costingDsgn,
    'GD - IMPORT &amp; EXPORT': importExportDsgn,
    'GD - INFORMATION TECHNOLOGY': infoTechDsgn,
    'GD - HUMAN RESOURCES': humanResourceDsgn,
  };
  final List<String> adminDsgn = [
    'ALL',
    'DRIVER',
    'SWEEPER',
    'OFFICE BOY',
    'SUPERVISOR',
    'RECEPTIONIST',
    'SECURITY GUARD',
    'GATE CLERK',
    'CCTV OPERATOR',
    'ASSISTANT MANAGER',
    'DEPUTY MANAGER',
    'EXCHANGE OPERATOR',
  ];
  final List<String> internalAuditDsgn = [
    'ALL',
    'OFFICER',
    'INCHARGE',
    'SENIOR MANAGER',
    'EXECUTIVE.',
    'DEPUTY MANAGER',
  ];
  final List<String> costingDsgn = [
    'ALL',
    'OFFICER',
    'DEPUTY MANAGER',
  ];

  final List<String> importExportDsgn = [
    'ALL',
    'OFFICER',
    'SENIOR MANAGER',
    'ASSISTANT MANAGER',
  ];
  final List<String> infoTechDsgn = [
    'ALL',

    'ASSISTANT NETWORK ADMINISTRATOR',
    'ASSISTANT BUSINESS ANALYST',
    'MANAGER',
    'OFFICER',
    'ASSISTANT MANAGER',
  ];
  final List<String> humanResourceDsgn = [
    'ALL',
    'TIME KEEPER',
    'OFFICER',
    'EXECUTIVE',
    'RECRUITMENT ASSOCIATE',
    'EXECUTIVE.',
    'DEPUTY MANAGER',
    'GENERAL MANAGER',

  ];
  // print(basicAuth);
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
    'GD - IMPORT &amp; EXPORT',
    'GD - INFORMATION TECHNOLOGY',
    'GD - HUMAN RESOURCES',
  ];

  void apiSearch() async {
    setState(() {

     fetchOrNot = false;
    });
    employeesDirectory.clear();
    var concatName="";

    if(searchQuery=='null'){
      concatName="null";
    }else{
      concatName="'%$searchQuery%'";
    }

   // print("apiserrr $searchQuery and $concatName and $dropDeptQuery and $dropDesignQuery");
    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_DIRECTORY">
             <soapenv:Header/>
             <soapenv:Body>
            <get:GET_EMP_DIRECTORYInput>
             <get:P_OUTPUT-XMLTYPE-OUT/>
            <get:P_ENAME-VARCHAR2-IN>${concatName.toUpperCase()}</get:P_ENAME-VARCHAR2-IN>
             <get:P_EMP_ID-VARCHAR2-IN>null</get:P_EMP_ID-VARCHAR2-IN>
             <get:P_EMP_DESIGNATION-VARCHAR2-IN>$dropDesignQuery</get:P_EMP_DESIGNATION-VARCHAR2-IN>
             <get:P_EMP_DEPARTMENT-VARCHAR2-IN>$dropDeptQuery</get:P_EMP_DEPARTMENT-VARCHAR2-IN>
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
    if (response.statusCode == 200) {
      setState(() {
        fetchOrNot = true;
      });
    }
    // Parse XML data
    var xmlSP = response.body.toString();

    final document = xml.XmlDocument.parse(xmlSP);
   // print("search Response document: ${document}");
    print(
        "Response document length: ${document.findAllElements('ROWSET').length}");

    if(document.findAllElements('ROWSET').isEmpty){
      toast("No data available for this query");
    }

    else{
      final rowset = document.findAllElements('ROWSET').last;

      // print("Response employeesNode: ${rowset}");

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

        employeesDirectoryAPISearch.add({
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

        employeesDirectoryBackup = employeesDirectoryAPISearch;
      }
      setState(() {

        employeesDirectory = employeesDirectoryAPISearch;
      //  print("lissssst $employeesDirectory");
      //  print("lissssst $employeesDirectory");
      });
    }
  }

  void reasign() {
    setState(() {
      employeesDirectory = employeesDirectoryBackup;
    });
  }

  @override
  void initState() {
    hitApi();
    super.initState();
  }

  hitApi() async {
    // 70500195 188700001 70500145 70500274
    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_DIRECTORY">
   <soapenv:Header/>
   <soapenv:Body>
      <get:GET_EMP_DIRECTORYInput>
         <get:P_OUTPUT-XMLTYPE-OUT/>
         <get:P_ENAME-VARCHAR2-IN>null</get:P_ENAME-VARCHAR2-IN>
         <get:P_EMP_ID-VARCHAR2-IN>null</get:P_EMP_ID-VARCHAR2-IN>
         <get:P_EMP_DESIGNATION-VARCHAR2-IN>null</get:P_EMP_DESIGNATION-VARCHAR2-IN>
         <get:P_EMP_DEPARTMENT-VARCHAR2-IN>null</get:P_EMP_DEPARTMENT-VARCHAR2-IN>
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
                        //   height:50* SizeConfig.heightMultiplier,
                        width: 100 * SizeConfig.widthMultiplier,
                        image: AssetImage(Images.header_grey),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Home()));
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

                                      },
                                      onSubmitted: (v){
                                        setState(() {
                                          query = v;
                                          if (query.isEmpty) {
                                            searchQuery='null';
                                            reasign();
                                          }else{
                                            searchQuery=v;

                                          }

                                                  apiSearch();


                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Image(
                                  //   height:50* SizeConfig.heightMultiplier,
                                  width: 10 * SizeConfig.widthMultiplier,
                                  image: AssetImage(Images.notification_ic),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 14.8 *SizeConfig.heightMultiplier,
                       left:57* SizeConfig.widthMultiplier,
                        child: OutlinedButton(
                          child: Text(
                            "Clear filters",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            selectedDsgn=null;
                             selectedDept=null;
                            textController.text="";
                            searchQuery="null";
                            dropDeptQuery="null";
                            dropDesignQuery="null";
                            dropdownvalueDesig = 'ALL';
                              dropdownvalueDepart = 'ALL';
                            setState(() {
                             apiSearch();

                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 15, 30, 5),
                        child: SizedBox(
                          width: 85 * SizeConfig.widthMultiplier,
                          child: SizedBox(
                            width: 30 * SizeConfig.widthMultiplier,
                            child: DropdownButtonFormField(

                                isExpanded: true,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
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
                                value: selectedDsgn,
                                // Down Arrow Ico
                                icon: const Icon(Icons.keyboard_arrow_down),
                                // Array list of items
                                items: dataSetAll.keys.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onTap: () {},
                                onChanged: onDeptChanged
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 15),
                        child: Container(
                          width: 85 * SizeConfig.widthMultiplier,
                          child: SizedBox(
                            width: 30 * SizeConfig.widthMultiplier,
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
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
                              value: selectedDept,
                              // Down Arrow Ico
                              icon: const Icon(Icons.keyboard_arrow_down),
                              // Array list of items
                              items: (dataSetAll[selectedDsgn] ?? []).map((String items) {
                                print("TEST list $items");
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onTap: () {},
                              onChanged: (String? newValue) {
                                try{
                                  setState(() {
                                    selectedDept=newValue;
                                    dropdownvalueDesig = newValue!;
                                    print(
                                        "value Drup $dropdownvalueDesig and $newValue");
                                    if (dropdownvalueDesig == "ALL") {
                                      dropDesignQuery='null';
                                    } else {
                                      dropDesignQuery="'$dropdownvalueDesig'";
                                    }
                                    apiSearch();
                                  });
                                }
                              catch (e){
                                  print("$e");
                              }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // abouve new
                  // Column(
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.fromLTRB(30, 15, 30, 5),
                  //       child: Container(
                  //         width: 85 * SizeConfig.widthMultiplier,
                  //         child: SizedBox(
                  //           width: 30 * SizeConfig.widthMultiplier,
                  //           child: DropdownButtonFormField(
                  //             isExpanded: true,
                  //             decoration: InputDecoration(
                  //               contentPadding: const EdgeInsets.only(
                  //                   top: 5, bottom: 5, left: 10, right: 5),
                  //               //this one
                  //               focusedBorder: OutlineInputBorder(
                  //                 borderSide: BorderSide(
                  //                     color: Clrs.light_Grey, width: 1),
                  //                 borderRadius: BorderRadius.circular(10),
                  //               ),
                  //               enabledBorder: OutlineInputBorder(
                  //                 borderSide: BorderSide(
                  //                     color: Clrs.light_Grey, width: 1),
                  //                 borderRadius: BorderRadius.circular(10),
                  //               ),
                  //               border: OutlineInputBorder(
                  //                 borderSide: BorderSide(
                  //                     color: Clrs.light_Grey, width: 1),
                  //                 borderRadius: BorderRadius.circular(10),
                  //               ),
                  //               filled: true,
                  //               fillColor: Clrs.medium_Grey,
                  //             ),
                  //             dropdownColor: Clrs.light_Grey,
                  //             // Initial Value
                  //             value: dropdownvalueDepart,
                  //             // Down Arrow Ico
                  //             icon: const Icon(Icons.keyboard_arrow_down),
                  //             // Array list of items
                  //             items: itemsOfdept.map((String items) {
                  //               return DropdownMenuItem(
                  //                 value: items,
                  //                 child: Text(items),
                  //               );
                  //             }).toList(),
                  //             onTap: () {},
                  //             onChanged: (String? newValue) {
                  //               setState(() {
                  //                 dropdownvalueDepart = newValue!;
                  //                 if (dropdownvalueDepart == "ALL") {
                  //                   dropDeptQuery='null';
                  //                   //reasign();
                  //                 } else {
                  //                   dropDeptQuery="'$dropdownvalueDepart'";
                  //                   //setResultsDropDept(dropdownvalueDepart);
                  //                 }
                  //                 apiSearch();
                  //
                  //               });
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.fromLTRB(30, 5, 30, 15),
                  //       child: Container(
                  //         width: 85 * SizeConfig.widthMultiplier,
                  //         child: SizedBox(
                  //           width: 30 * SizeConfig.widthMultiplier,
                  //           child: DropdownButtonFormField(
                  //             isExpanded: true,
                  //             decoration: InputDecoration(
                  //               contentPadding: const EdgeInsets.only(
                  //                   top: 5, bottom: 5, left: 10, right: 5),
                  //               //this one
                  //               focusedBorder: OutlineInputBorder(
                  //                 borderSide: BorderSide(
                  //                     color: Clrs.light_Grey, width: 1),
                  //                 borderRadius: BorderRadius.circular(10),
                  //               ),
                  //               enabledBorder: OutlineInputBorder(
                  //                 borderSide: BorderSide(
                  //                     color: Clrs.light_Grey, width: 1),
                  //                 borderRadius: BorderRadius.circular(10),
                  //               ),
                  //               border: OutlineInputBorder(
                  //                 borderSide: BorderSide(
                  //                     color: Clrs.light_Grey, width: 1),
                  //                 borderRadius: BorderRadius.circular(10),
                  //               ),
                  //               filled: true,
                  //               fillColor: Clrs.medium_Grey,
                  //             ),
                  //             dropdownColor: Clrs.light_Grey,
                  //             // Initial Value
                  //             value: dropdownvalueDesig,
                  //             // Down Arrow Ico
                  //             icon: const Icon(Icons.keyboard_arrow_down),
                  //             // Array list of items
                  //             items: itemsOfDg.map((String items) {
                  //               return DropdownMenuItem(
                  //                 value: items,
                  //                 child: Text(items),
                  //               );
                  //             }).toList(),
                  //             onTap: () {},
                  //             onChanged: (String? newValue) {
                  //               setState(() {
                  //                 dropdownvalueDesig = newValue!;
                  //                 print(
                  //                     "value Drup $dropdownvalueDesig and $newValue");
                  //
                  //                 // print(
                  //                 //     "value Drup $dropdownvalueDesig and $newValue");
                  //                 if (dropdownvalueDesig == "ALL") {
                  //                   dropDesignQuery='null';
                  //                   // reasign();
                  //                 } else {
                  //                   dropDesignQuery="'$dropdownvalueDesig'";
                  //                   // setResultsDropDown(dropdownvalueDesig);
                  //                 }
                  //
                  //                 apiSearch();
                  //               });
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
                  SizedBox(

                    height: 50*SizeConfig.heightMultiplier,
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

                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return (Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  Image(
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
                  Positioned(
                      top: 40,
                      width: 100 * SizeConfig.widthMultiplier,
                      child: Center(
                          child: Text(
                        "Employee Directory",
                        style: TextStyle(color: Clrs.white, fontSize: 20),
                      ))),
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
                                      // if (query.isEmpty) {
                                      //   reasign();
                                      // }

                                      // apiSearch(query);
                                      //  searchFunc(query, 1);
                                    });
                                  },
                                ),
                              ),
                            ),
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
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 15, 30, 5),
                    child: Container(
                      width: 85 * SizeConfig.widthMultiplier,
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
                          onTap: () {},
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalueDepart = newValue!;
                              // if (dropdownvalueDepart == "ALL") {
                              //   reasign();
                              // } else {
                              //   setResultsDropDept(dropdownvalueDepart);
                              // }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 5, 30, 15),
                    child: Container(
                      width: 85 * SizeConfig.widthMultiplier,
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


                              // // print(
                              // //     "value Drup $dropdownvalueDesig and $newValue");
                              // if (dropdownvalueDesig == "ALL") {
                              //   dropDesignQuery='null';
                              //  // reasign();
                              // } else {
                              //   dropDesignQuery=dropdownvalueDesig;
                              //  // setResultsDropDown(dropdownvalueDesig);
                              // }
                              // apiSearch();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              )),
            ],
          ),
        ),
      ));
    }
  }
}
