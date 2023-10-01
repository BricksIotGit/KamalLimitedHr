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
  String dropdownvalueDesig = 'ALL DEPARTMENTS';
  String dropdownvalueDepart = 'ALL DEPARTMENTS';

  String dropDesignQuery = 'null';
  String dropDeptQuery = 'null';

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
  String? selectedLocation;
  String? selectedDept;
  String? selectedDeptIs = "ALL DEPARTMENTS";

  // onDeptChanged(String? value) {
  //
  //   print("onDeptChanged value $value");
  //   //dont change second dropdown if 1st item didnt change
  //   if (value != selectedDsgn) selectedDept = null;
  //   setState(() {
  //     selectedDsgn = value;
  //   });
  //
  //   dropdownvalueDepart = value!;
  //   if (dropdownvalueDepart == "ALL DEPARTMENTS") {
  //     dropDeptQuery='null';
  //
  //   } else {
  //     dropDeptQuery="'$dropdownvalueDepart'";
  //
  //   }
  //   dropDesignQuery="null";
  //   apiSearch();
  //
  // }




  var itemsOfdept = [
    'ALL DEPARTMENTS',
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
    var concatName = "";

    if (searchQuery == 'null') {
      concatName = "null";
    } else {
      concatName = "'%$searchQuery%'";
    }

      print("apiserrr $searchQuery and $concatName and $dropDeptQuery and $dropDesignQuery");
    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_DIRECTORY">
             <soapenv:Header/>
             <soapenv:Body>
            <get:GET_EMP_DIRECTORYInput>
             <get:P_OUTPUT-XMLTYPE-OUT/>
            <get:P_ENAME-VARCHAR2-IN>${concatName.toUpperCase()}</get:P_ENAME-VARCHAR2-IN>
             <get:P_EMP_ID-VARCHAR2-IN>null</get:P_EMP_ID-VARCHAR2-IN>
             <get:P_EMP_DESIGNATION-VARCHAR2-IN>null</get:P_EMP_DESIGNATION-VARCHAR2-IN>
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

    if (document.findAllElements('ROWSET').isEmpty) {
      toast("No data available for this query");
    } else {
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
        final ext = row.findElements('EXT_NO').single.text;
        final doc = (row.findElements('DOC').isNotEmpty)
            ? row.findElements('DOC').single.text
            : "";
        final empEmail = (row.findElements('EMAIL').isNotEmpty)
            ? row.findElements('EMAIL').single.text
            : "";

        final empType = row.findElements('EMP_TYPE').single.text;

        final empShift = row.findElements('EMP_SHIFT').single.text;
        final empDvName = row.findElements('DIV_NAME').single.text;
        final empDesignLvl =
            row.findElements('EMP_DESIGNATION_LVL').single.text;

        employeesDirectoryAPISearch.add({
          'empId': empId,
          'ename': ename,
          'fname': fname,
          'gndr': gndr,
          'empDpt': empDpt,
          'empDesig': empDesig,
          'doj': doj,
          'doc': doc,
          'ext': ext,
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

    getAllDept().then((value) {
      hitApi();
    });
    super.initState();
  }
  Future<void> getAllDept() async {

    // http://202.125.141.170:8080/orawsv/XXHRMS/GET_EMP_DEPT
    var requestBody = '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_DEPT">
   <soapenv:Header/>
   <soapenv:Body>
      <get:GET_EMP_DEPTInput>
         <get:P_OUTPUT-XMLTYPE-OUT/>
      </get:GET_EMP_DEPTInput>
   </soapenv:Body>
</soapenv:Envelope>''';

    var response = await post(
      Uri.parse('http://202.125.141.170:8080/orawsv/XXHRMS/GET_EMP_DEPT'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");

    if(response.statusCode==200){
      final document =  xml.XmlDocument.parse(response.body.toString());
      final rowsetElement = document.findAllElements('ROWSET').single;
      List< xml.XmlElement> rowElements = rowsetElement.findAllElements('ROW').toList();

      itemsOfdept.clear();
      itemsOfdept.add("ALL DEPARTMENTS");
      for (final rowElement in rowElements) {
        String? deptId = rowElement.getElement('DEPT_ID')?.text;
        String? empDepartment = rowElement.getElement('EMP_DEPARTMENT')?.text;

        print('DEPT_ID: $deptId');
        print('EMP_DEPARTMENT: $empDepartment');
        print('----------------------------------');
        itemsOfdept.add('$empDepartment');
      }
      setState(() {

      });
      print("itemsOfdept complete: $itemsOfdept");

    }

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
      final ext = row.findElements('EXT_NO').single.text;
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
        'ext': ext,
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

  void infoAlertCustom(int index) {
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
                      text: 'Ext No:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' ${employeesDirectory[index]['ext']}'),
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
                                      onChanged: (v) {},
                                      onSubmitted: (v) {
                                        setState(() {
                                          query = v;
                                          if (query.isEmpty) {
                                            searchQuery = 'null';
                                            reasign();
                                          } else {
                                            searchQuery = v;
                                          }

                                          apiSearch();
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                // Image(
                                //   //   height:50* SizeConfig.heightMultiplier,
                                //   width: 10 * SizeConfig.widthMultiplier,
                                //   image: AssetImage(Images.notification_ic),
                                // ),
                                SizedBox(width: 10 * SizeConfig.widthMultiplier,),

                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 14.8 * SizeConfig.heightMultiplier,
                        left: 57 * SizeConfig.widthMultiplier,
                        child: OutlinedButton(
                          child: Text(
                            "Clear filters",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            //here
                          selectedDeptIs="ALL DEPARTMENTS";
                            selectedDsgn = null;
                            selectedDept = null;
                            textController.text = "";
                            searchQuery = "null";
                            dropDeptQuery = "null";
                            dropDesignQuery = "null";
                            dropdownvalueDesig = 'ALL DEPARTMENTS';
                            dropdownvalueDepart = 'ALL DEPARTMENTS';
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
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(30, 15, 30, 5),
                      //   child: SizedBox(
                      //     width: 85 * SizeConfig.widthMultiplier,
                      //     child: SizedBox(
                      //       width: 30 * SizeConfig.widthMultiplier,
                      //       child: DropdownButtonFormField(
                      //
                      //           isExpanded: true,
                      //           decoration: InputDecoration(
                      //             contentPadding: const EdgeInsets.only(
                      //                 top: 5, bottom: 5, left: 10, right: 5),
                      //             //this one
                      //             focusedBorder: OutlineInputBorder(
                      //               borderSide: BorderSide(
                      //                   color: Clrs.light_Grey, width: 1),
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //             enabledBorder: OutlineInputBorder(
                      //               borderSide: BorderSide(
                      //                   color: Clrs.light_Grey, width: 1),
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //             border: OutlineInputBorder(
                      //               borderSide: BorderSide(
                      //                   color: Clrs.light_Grey, width: 1),
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //             filled: true,
                      //             fillColor: Clrs.medium_Grey,
                      //           ),
                      //           dropdownColor: Clrs.light_Grey,
                      //           // Initial Value
                      //           value: selectedDsgn,
                      //           // Down Arrow Ico
                      //           icon: const Icon(Icons.keyboard_arrow_down),
                      //           // Array list of items
                      //           items: dataSetAll.keys.map((String items) {
                      //             return DropdownMenuItem(
                      //               value: items,
                      //               child: Text(items),
                      //             );
                      //           }).toList(),
                      //           onTap: () {},
                      //           onChanged: onDeptChanged
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(30, 5, 30, 15),
                      //   child: Container(
                      //     width: 85 * SizeConfig.widthMultiplier,
                      //     child: SizedBox(
                      //       width: 30 * SizeConfig.widthMultiplier,
                      //       child: DropdownButtonFormField(
                      //         isExpanded: true,
                      //         decoration: InputDecoration(
                      //           contentPadding: const EdgeInsets.only(
                      //               top: 5, bottom: 5, left: 10, right: 5),
                      //           //this one
                      //           focusedBorder: OutlineInputBorder(
                      //             borderSide: BorderSide(
                      //                 color: Clrs.light_Grey, width: 1),
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           enabledBorder: OutlineInputBorder(
                      //             borderSide: BorderSide(
                      //                 color: Clrs.light_Grey, width: 1),
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           border: OutlineInputBorder(
                      //             borderSide: BorderSide(
                      //                 color: Clrs.light_Grey, width: 1),
                      //             borderRadius: BorderRadius.circular(10),
                      //           ),
                      //           filled: true,
                      //           fillColor: Clrs.medium_Grey,
                      //         ),
                      //         dropdownColor: Clrs.light_Grey,
                      //         // Initial Value
                      //         value: selectedDept,
                      //         // Down Arrow Ico
                      //         icon: const Icon(Icons.keyboard_arrow_down),
                      //         // Array list of items
                      //         items: (dataSetAll[selectedDsgn] ?? []).map((String items) {
                      //           print("TEST list $items");
                      //           return DropdownMenuItem(
                      //             value: items,
                      //             child: Text(items),
                      //           );
                      //         }).toList(),
                      //         onTap: () {},
                      //         onChanged: (String? newValue) {
                      //           try{
                      //             setState(() {
                      //               selectedDept=newValue;
                      //               dropdownvalueDesig = newValue!;
                      //               print(
                      //                   "value Drup $dropdownvalueDesig and $newValue");
                      //               if (dropdownvalueDesig == "ALL DEPARTMENTS") {
                      //                 dropDesignQuery='null';
                      //               } else {
                      //                 dropDesignQuery="'$dropdownvalueDesig'";
                      //               }
                      //               apiSearch();
                      //             });
                      //           }
                      //           catch (e){
                      //             print("$e");
                      //           }
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),

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
                              value: "Garments Division",
                              // Down Arrow Ico
                              icon: const Icon(Icons.keyboard_arrow_down),
                              // Array list of items
                              items: <String>['Garments Division']
                                  .map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onTap: () {},
                              onChanged: (String? value) {},
                            ),
                          ),
                        ),
                      ),
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
                              value: selectedDeptIs,
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
                              onChanged: (String? value) {
                                setState(() {
                                  print("object is $value");
                                  if(value=="ALL DEPARTMENTS"){
                                    selectedDeptIs = value!;
                                    dropDeptQuery="null";
                                  }
                                  else{
                                    selectedDeptIs = value!;
                                    dropDeptQuery="'$value'";
                                  }
                                });
                                apiSearch();
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
                                      fontSize: 13,
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
                                        fontSize: 13,
                                        color: Clrs.dark_Grey),
                                  ),
                                ),
                                flex: 1),
                            Flexible(
                                child: Align(
                                  alignment: Alignment.centerLeft,

                                  child: Text(
                                    "Dept.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Clrs.dark_Grey),
                                  ),
                                ),
                                flex: 1),
                            Flexible(
                                child: Align(
                                  alignment: Alignment.centerLeft,

                                  child: Text(
                                    "Designation",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Clrs.dark_Grey),
                                  ),
                                ),
                                flex: 1),
                            Flexible(
                                child: Text(
                                  "Status",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Clrs.dark_Grey),
                                ),
                                flex: 1)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50 * SizeConfig.heightMultiplier,
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
                                          infoEmpId = employeesDirectory[index]
                                              ['empId']!;
                                          infoEmpDvName =
                                              employeesDirectory[index]
                                                  ['empDvName']!;
                                          infoEmpDesignLvl =
                                              employeesDirectory[index]
                                                  ['empDesignLvl']!;
                                          infoEmpDvEmail =
                                              employeesDirectory[index]
                                                  ['empEmail']!;

                                          infoAlertCustom(index);
                                        },
                                        child: Text(
                                          "Info.",
                                          style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              fontSize: 12,
                                              color: Clrs.blue),
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
                            // Image(
                            //   //   height:50* SizeConfig.heightMultiplier,
                            //   width: 10 * SizeConfig.widthMultiplier,
                            //   image: AssetImage(Images.notification_ic),
                            // ),
                            SizedBox(width: 10 * SizeConfig.widthMultiplier,),
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
                          value: "Garments Division",
                          // Down Arrow Ico
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: <String>['Garments Division']
                              .map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onTap: () {},
                          onChanged: (String? value) {},
                        ),
                      ),
                    ),
                  ),
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
                          value: selectedDeptIs,
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
                          onChanged: (String? value) {
                            setState(() {
                              print("object is $value");
                              if(value=="ALL DEPARTMENTS"){
                                selectedDeptIs = value!;
                                dropDeptQuery="null";
                              }
                              else{
                                selectedDeptIs = value!;
                                dropDeptQuery="'$value'";
                              }
                            });
                            //apiSearch();
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
