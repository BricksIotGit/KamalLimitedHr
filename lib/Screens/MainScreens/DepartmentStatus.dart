import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:kamal_limited/utils/Toast.dart';
import 'package:xml/xml.dart' as xml;

import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import 'Home.dart';

class DepartmentStatus extends StatefulWidget {
  const DepartmentStatus({Key? key}) : super(key: key);

  @override
  _DepartmentStatusState createState() => _DepartmentStatusState();
}

class _DepartmentStatusState extends State<DepartmentStatus> {
  List<Map<String, String>> deptStatusList = [];

  bool fetchOrNot=false;
  String dropdownvalueDepart = 'ALL';
  var itemsOfdept = [
    'ALL',
    'GD - ADMINISTRATION',
    'GD - INTERNAL AUDIT',
    'GD - COSTING',
    'GD - IMPORT & EXPORT',
    'GD - INFORMATION TECHNOLOGY',
    'GD - HUMAN RESOURCES',
  ];
  String username = 'xxhrms';
  String password = 'xxhrms';
  String basicAuth="";
  @override
  void initState() {
    //hitApi();
    init();
    getAllDept();
    super.initState();
  }
  init(){
     basicAuth = 'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);
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
      itemsOfdept.add("ALL");
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

  hitApi(String formattedDate) async {
   deptStatusList.clear();

    // var concatDPT="'"+dropdownvalueDepart+"'";
    // var concatDate="'"+formattedDate+"'";
   var concatDPT="'$dropdownvalueDepart'";
    var concatDate="'$formattedDate'";

    print("hit api DPT: $dropdownvalueDepart");
    print("hit api DPT: $formattedDate");
    print("hit api DPT: $concatDPT");
    print("hit api DPT: $concatDate");



    // 70500195 188700001 70500145 70500274
    var requestBody = '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_DEPT_STATUS">
   <soapenv:Header/>
   <soapenv:Body>
      <get:GET_EMP_DEPT_STATUSInput>
         <get:P_OUTPUT-XMLTYPE-OUT/>
         <get:P_EMP_DEPARTMENT-VARCHAR2-IN>$concatDPT</get:P_EMP_DEPARTMENT-VARCHAR2-IN>
         <get:P_ATTND_DATE-VARCHAR2-IN>$concatDate</get:P_ATTND_DATE-VARCHAR2-IN>
      </get:GET_EMP_DEPT_STATUSInput>
   </soapenv:Body>
</soapenv:Envelope>''';

    var response = await post(
      Uri.parse('http://202.125.141.170:8080/orawsv/XXHRMS/GET_EMP_DEPT_STATUS'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      var xmlSP = response.body.toString();
      final document = xml.XmlDocument.parse(xmlSP);
      final rows = document.findAllElements('ROW');

      for (var row in rows) {
        final empId = row.findElements('EMP_ID').single.text;
        final ename = row.findElements('ENAME').single.text;
        final empDepartment = row.findElements('EMP_DEPARTMENT').single.text;
        final empDesignation = row.findElements('EMP_DESIGNATION').single.text;
        final status = row.findElements('STATUS').single.text;
        final attndDate = row.findElements('ATTND_DATE').single.text;

        final rowMap = {
          'EMP_ID': empId,
          'ENAME': ename,
          'EMP_DEPARTMENT': empDepartment,
          'EMP_DESIGNATION': empDesignation,
          'STATUS': status,
          'ATTND_DATE': attndDate
        };

        deptStatusList.add(rowMap);
      }
      if(deptStatusList.isEmpty){
        toast("No data Available");
      }
      setState(() {
        fetchOrNot = false;
      });
    }


    print("list of deptStatusList: $deptStatusList");

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
                        "Department Status",
                        style: TextStyle(color: Clrs.white, fontSize: 20),
                      )))
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: Text(
                    "Select Department and Date for results",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
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
                              print("selected dpt is: $dropdownvalueDepart");
                              if (dropdownvalueDepart == "ALL") {
                                //reasign();
                              } else {
                               // setResultsDropDept(dropdownvalueDepart);
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                   Padding(padding: EdgeInsets.all(0),
                   child:
                     ElevatedButton(
                       onPressed: () async {
                         DateTime? pickedDate = await showDatePicker(
                             context: context,
                             initialDate: DateTime.now(),
                             firstDate: DateTime(2010),
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
                               "date is: $formattedDate");

                           fetchOrNot=true;
                           hitApi(formattedDate);//formatted date output using intl package =>  2021-03-16
                           setState(() {
                             //set output date to TextField value.
                           });
                         } else {}
                         setState(() {

                         });
                       },
                       child: const Text('Select Date',
                           style: TextStyle(
                             color: Colors.black,
                           )),
                       style: ElevatedButton.styleFrom(
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(10),
                           //border radius equal to or more than 50% of width
                         ),
                         backgroundColor: Clrs.white,

                         minimumSize: Size(150, 45),
                       ),

                        )
                   )],
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
                        Text(
                          "Id",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Clrs.dark_Grey),
                        ),
                        Text(
                          "Name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Clrs.dark_Grey),
                        ),
                        // Text(
                        //   "Dept",
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 14,
                        //       color: Clrs.dark_Grey),
                        // ),
                        Text(
                          "Designation",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Clrs.dark_Grey),
                        ),
                        Text(
                          "Status",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Clrs.dark_Grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(0),child:fetchOrNot?CircularProgressIndicator(color: Colors.grey,):SizedBox() ,),

              SizedBox(
                width: SizeConfig.widthMultiplier * 100,
                height: SizeConfig.heightMultiplier * 60,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Clrs.medium_Grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Clrs.white,
                    ),
                    child: ListView.builder(
                      itemCount: deptStatusList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(0),
                          child: ListTile(
                            title: Row(
                              // mainAxisAlignment: MainAxisAlignment.,
                              children: [
                                Flexible(
                                    child: Text(
                                      deptStatusList[index]['EMP_ID']!,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1),
                                Flexible(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          deptStatusList[index]['ENAME']!,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Clrs.dark_Grey),
                                        ),
                                      ),
                                    ),
                                    flex: 2),
                                // Flexible(
                                //     child: Align(
                                //       alignment: Alignment.centerLeft,
                                //
                                //       child: Text(
                                //         deptStatusList[index]['EMP_DEPARTMENT']!,
                                //         style: TextStyle(
                                //             fontSize: 12,
                                //             color: Clrs.dark_Grey),
                                //       ),
                                //     ),
                                //     flex: 2),
                                Flexible(
                                    child: Align(
                                      alignment: Alignment.centerLeft,

                                      child: Text(
                                        deptStatusList[index]['EMP_DESIGNATION']!,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Clrs.dark_Grey),
                                      ),
                                    ),
                                    flex: 1),
                                Flexible(
                                    child: Align(
                                      alignment: Alignment.centerRight,

                                      child: Text(
                                        deptStatusList[index]['STATUS']!,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Clrs.dark_Grey),
                                      ),
                                    ),
                                    flex: 1),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
