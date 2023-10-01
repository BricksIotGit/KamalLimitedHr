import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kamal_limited/utils/Toast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import '../../utils/sentNotification.dart';
import 'Home.dart';

class RequestApproval extends StatefulWidget {
  const RequestApproval({Key? key}) : super(key: key);

  @override
  _RequestApprovalState createState() => _RequestApprovalState();
}

class _RequestApprovalState extends State<RequestApproval> {
  List<Map<String, String>> leaveRequestList = [];
  List<Map<String, String>> outDoorRequestList = [];
  String infoEmpId = "0000";
  String infoLeaveTitle = "0000";
  String infoLeaveFrom = "0000";
  String infoLeaveTo = "0000";
  String infoOfDays = "0000";
  String infoReason = "0000";
  String infoApprovalEmpId = "0000";

  double heightCustomLR = SizeConfig.heightMultiplier * 30;
  double heightCustomOD = SizeConfig.heightMultiplier * 10;
  bool fetchOrNot = false;
  bool fetchOrNotOD = false;
  String username = 'xxhrms';
  String password = 'xxhrms';
  String? basicAuth;
  SharedPreferences? prefs;
  String? empIDSp;

  @override
  void initState() {
    init();

    super.initState();
  }

  init() async {
    basicAuth = 'Basic ' + base64.encode(utf8.encode('$username:$password'));
    prefs = await SharedPreferences.getInstance();
    empIDSp = prefs?.getString('empID');
    print("init run");
    hitApi();
    fetchOutDoorData();
  }

  hitApi() async {
    // print(basicAuth); $empIDSp
    // 70500195 188700001 70500145 70500274
    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_PEND_LV_APPROVAL">
    <soapenv:Header/>
     <soapenv:Body>
      <get:GET_EMP_PEND_LV_APPROVALInput>
         <get:P_OUTPUT-XMLTYPE-OUT/>
         <get:P_EMP_ID-VARCHAR2-IN>$empIDSp</get:P_EMP_ID-VARCHAR2-IN>
      </get:GET_EMP_PEND_LV_APPROVALInput>
     </soapenv:Body>
    </soapenv:Envelope>''';

    var response = await post(
      Uri.parse(
          'http://202.125.141.170:8080/orawsv/XXHRMS/GET_EMP_PEND_LV_APPROVAL'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth.toString()
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          fetchOrNot = true;
        });
      }
    }
    // Parse XML data
    var xmlSP = response.body.toString();

    var document = xml.XmlDocument.parse(xmlSP);
    var rows = document.findAllElements('ROW');
    print(
        "Response document length: ${document.findAllElements('ROW').length}");

    // if (document.findAllElements('ROW').isEmpty) {
    //   toast("No data available! ");
    // }
    for (var row in rows) {
      var empId = row.findElements('EMP_ID').single.text;
      var leaveTitle = row.findElements('LEAVE_TITLE').single.text;
      var leaveFrom = row.findElements('LEAVE_FROM').single.text;
      var leaveTo = row.findElements('LEAVE_TO').single.text;
      var nOfDays = row.findElements('NO_OF_DAYS').single.text;
      var lvID = row.findElements('LV_ID').single.text;
      var approvalEmpId = row.findElements('APPROVAL_EMP_ID').single.text;
      var reason = row.findElements('REASON').single.text;
      final empName = (row.findElements('ENAME').isNotEmpty)
          ? row.findElements('ENAME').single.text
          : "Empty";
      final empDes = (row.findElements('EMP_DESIGNATION').isNotEmpty)
          ? row.findElements('EMP_DESIGNATION').single.text
          : "Empty";

      print("");
      print('EMP_ID: $empId');
      print('LEAVE_TITLE: $leaveTitle');
      print('LEAVE_FROM: $leaveFrom');
      print('LEAVE_TO: $leaveTo');
      print('N_OF_DAYS: $nOfDays');
      print('APPROVAL_EMP_ID: $approvalEmpId');

      leaveRequestList.add({
        'empId': empId,
        'leaveTitle': leaveTitle,
        'leaveFrom': leaveFrom,
        'leaveTo': leaveTo,
        'nOfDays': nOfDays,
        'approvalEmpId': approvalEmpId,
        'empDes': empDes,
        'empName': empName,
        'lvID': lvID,
        'reason': reason,
      });
      //
      // employeesDirectoryBackup = employeesDirectory;
    }
    if (leaveRequestList.isNotEmpty) {
      setState(() {
        heightCustomLR = SizeConfig.heightMultiplier * 40;
      });
    }
    // print("Response employees length: ${employeesDirectory.length}");
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
                          "Request Approval",
                          style: TextStyle(color: Clrs.white, fontSize: 20),
                        )))
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                    child: Text(
                      "Leave Request",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Sr.",
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
                          Text(
                            "Designation",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Clrs.dark_Grey),
                          ),
                          Text(
                            "Action",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Clrs.dark_Grey),
                          ),
                          Text(
                            " ",
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
                Padding(
                  padding: EdgeInsets.all(0),
                  child: fetchOrNot
                      ? SizedBox(
                          width: SizeConfig.widthMultiplier * 100,
                          height: heightCustomLR,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Clrs.medium_Grey),
                                borderRadius: BorderRadius.circular(10),
                                color: Clrs.white,
                              ),
                              child: ListView.builder(
                                itemCount: leaveRequestList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Flexible(
                                              child: Text(
                                                "${index + 1}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Clrs.dark_Grey),
                                              ),
                                              flex: 1),
                                          Flexible(
                                              child: Text(
                                                leaveRequestList[index]
                                                    ['empName']!,
                                                style: TextStyle(
                                                    //  fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Clrs.dark_Grey),
                                              ),
                                              flex: 1),
                                          Flexible(
                                              child: Text(
                                                leaveRequestList[index]
                                                    ['empDes']!,
                                                style: TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Clrs.dark_Grey),
                                              ),
                                              flex: 1),
                                          Flexible(
                                              child: SizedBox(
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        15,
                                                height: 20,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    infoEmpId =
                                                        leaveRequestList[index]
                                                            ['empId']!;
                                                    infoLeaveTitle =
                                                        leaveRequestList[index]
                                                            ['leaveTitle']!;
                                                    infoLeaveFrom =
                                                        leaveRequestList[index]
                                                            ['leaveFrom']!;

                                                    infoLeaveTo =
                                                        leaveRequestList[index]
                                                            ['leaveTo']!;
                                                    infoOfDays =
                                                        leaveRequestList[index]
                                                            ['nOfDays']!;
                                                    infoReason =
                                                        leaveRequestList[index]
                                                            ['reason']!;
                                                    infoApprovalEmpId =
                                                        leaveRequestList[index]
                                                            ['approvalEmpId']!;

                                                    infoAlertCustom(index, 0);
                                                  },
                                                  child: Text('Action',
                                                    style: TextStyle(
                                                        decoration: TextDecoration.underline,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                        color: Clrs.blue),),
                                                ),
                                              ),
                                              flex: 1)
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      : CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                    child: Text(
                      "Outdoor Request",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
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
                            "Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Clrs.dark_Grey),
                          ),
                          // Text(
                          //   "From",
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: 14,
                          //       color: Clrs.dark_Grey),
                          // ),
                          // Text(
                          //   "To",
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: 14,
                          //       color: Clrs.dark_Grey),
                          // ),
                          Text(
                            "Days",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Clrs.dark_Grey),
                          ),
                          Text(
                            "Desig.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Clrs.dark_Grey),
                          ),
                          Text(
                            "Action",
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
                Padding(
                  padding: EdgeInsets.all(0),
                  child: fetchOrNotOD
                      ? SizedBox(
                          width: SizeConfig.widthMultiplier * 100,
                          height: heightCustomOD,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Clrs.medium_Grey),
                                borderRadius: BorderRadius.circular(10),
                                color: Clrs.white,
                              ),
                              child: ListView.builder(
                                itemCount: outDoorRequestList.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                              child: Text(
                                                "${index + 1}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Clrs.dark_Grey),
                                              ),
                                              flex: 1),
                                          Flexible(
                                              child: Text(
                                                outDoorRequestList[index]
                                                    ['empName']!,
                                                style: TextStyle(
                                                    //  fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Clrs.dark_Grey),
                                              ),
                                              flex: 1),
                                          // Flexible(
                                          //     child: Text(
                                          //       outDoorRequestList[index]
                                          //           ['leaveFrom']!,
                                          //       style: TextStyle(
                                          //           //  fontWeight: FontWeight.bold,
                                          //           fontSize: 12,
                                          //           color: Clrs.dark_Grey),
                                          //     ),
                                          //     flex: 1),
                                          // Flexible(
                                          //     child: Text(
                                          //       outDoorRequestList[index]
                                          //           ['leaveTo']!,
                                          //       style: TextStyle(
                                          //           //  fontWeight: FontWeight.bold,
                                          //           fontSize: 12,
                                          //           color: Clrs.dark_Grey),
                                          //     ),
                                          //     flex: 1),
                                          Flexible(
                                              child: Text(
                                                outDoorRequestList[index]
                                                    ['nOfDays']!,
                                                style: TextStyle(
                                                    //  fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Clrs.dark_Grey),
                                              ),
                                              flex: 1),
                                          Flexible(
                                              child: Text(
                                                outDoorRequestList[index]
                                                    ['empDes']!,
                                                style: TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Clrs.dark_Grey),
                                              ),
                                              flex: 1),
                                          Flexible(
                                              child: SizedBox(
                                                width:
                                                    SizeConfig.widthMultiplier *
                                                        15,
                                                height: 20,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    infoEmpId =
                                                        outDoorRequestList[
                                                            index]['empId']!;
                                                    infoLeaveTitle =
                                                        outDoorRequestList[
                                                                index]
                                                            ['leaveTitle']!;
                                                    infoLeaveFrom =
                                                        outDoorRequestList[
                                                                index]
                                                            ['leaveFrom']!;

                                                    infoLeaveTo =
                                                        outDoorRequestList[
                                                            index]['leaveTo']!;
                                                    infoOfDays =
                                                        outDoorRequestList[
                                                            index]['nOfDays']!;
                                                    infoApprovalEmpId =
                                                        outDoorRequestList[
                                                                index]
                                                            ['approvalEmpId']!;

                                                    infoReason =
                                                        outDoorRequestList[
                                                            index]['reason']!;

                                                    infoAlertCustom(index, 1);
                                                  },
                                                  child: Text('Action',
                                                    style: TextStyle(
                                                        decoration: TextDecoration.underline,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                        color: Clrs.blue),),
                                                  // style:
                                                  //     ElevatedButton.styleFrom(
                                                  //   backgroundColor:
                                                  //       Clrs.dark_Grey,
                                                  //   shape: StadiumBorder(),
                                                  //   minimumSize: Size(50, 20),
                                                  // ),
                                                ),
                                              ),
                                              flex: 1)
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      : CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  fetchOutDoorData() async {
    print("My empid $empIDSp");

    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_PEND_OD_APPROVAL">
   <soapenv:Header/>
   <soapenv:Body>
      <get:GET_EMP_PEND_OD_APPROVALInput>
         <get:P_OUTPUT-XMLTYPE-OUT/>
         <get:P_EMP_ID-VARCHAR2-IN>$empIDSp</get:P_EMP_ID-VARCHAR2-IN>
      </get:GET_EMP_PEND_OD_APPROVALInput>
   </soapenv:Body>
</soapenv:Envelope>''';

    var response = await post(
      Uri.parse(
          'http://202.125.141.170:8080/orawsv/XXHRMS/GET_EMP_PEND_OD_APPROVAL'),
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
        fetchOrNotOD = true;
      });
    }
    // Parse XML data
    var xmlSP = response.body.toString();

    var document = xml.XmlDocument.parse(xmlSP);
    var rows = document.findAllElements('ROW');
    print(
        "Response document length: ${document.findAllElements('ROW').length}");

    // if (document.findAllElements('ROW').isEmpty) {
    //   toast("No data available! ");
    // }
    for (var row in rows) {
      var empId = row.findElements('EMP_ID').single.text;
      final empName = (row.findElements('ENAME').isNotEmpty)
          ? row.findElements('ENAME').single.text
          : "Empty";
      final empDes = (row.findElements('EMP_DESIGNATION').isNotEmpty)
          ? row.findElements('EMP_DESIGNATION').single.text
          : "Empty";
      var leaveTitle = row.findElements('LEAVE_TITLE').single.text;
      var leaveFrom = row.findElements('LEAVE_FROM').single.text;
      var leaveTo = row.findElements('LEAVE_TO').single.text;
      var nOfDays = row.findElements('NO_OF_DAYS').single.text;
      var approvalEmpId = row.findElements('APPROVAL_EMP_ID').single.text;
      var reason = row.findElements('REASON').single.text;
      var timeFrom = row.findElements('TIME_FM').single.text;
      var timeTo = row.findElements('TIME_TO').single.text;
      var lvID = row.findElements('LV_ID').single.text;

      print("");
      print('EMP_ID: $empId');
      print('LEAVE_TITLE: $leaveTitle');
      print('LEAVE_FROM: $leaveFrom');
      print('LEAVE_TO: $leaveTo');
      print('N_OF_DAYS: $nOfDays');
      print('APPROVAL_EMP_ID: $approvalEmpId');
      print('REASON: $reason');
      print('TIME_FM: $timeFrom');
      print('TIME_TO: $timeTo');

      outDoorRequestList.add({
        'empId': empId,
        'empName': empName,
        'leaveTitle': leaveTitle,
        'leaveFrom': leaveFrom,
        'leaveTo': leaveTo,
        'nOfDays': nOfDays,
        'approvalEmpId': approvalEmpId,
        'empDes': empDes,
        'reason': reason,
        'timeFrom': timeFrom,
        'timeTo': timeTo,
        'lvID': lvID,
      });
      //
      // employeesDirectoryBackup = employeesDirectory;
    }

    if (outDoorRequestList.isEmpty && leaveRequestList.isEmpty) {
      toast("No pending request available!");
    } else if (outDoorRequestList.isNotEmpty) {
      setState(() {
        heightCustomOD = SizeConfig.heightMultiplier * 30;
      });
    }

    //print('outDoorRequestList ${outDoorRequestList}');
  }

  void infoAlertCustom(int index, int mode) {
    print("mode $mode");
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 450.0,
        width: 300.0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.clear_rounded,
                    color: Colors.grey,
                    size: 24.0,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Leave Title:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' $infoLeaveTitle'),
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
                            text: 'Leave from: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' $infoLeaveFrom'),
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
                            text: 'Leave to: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' $infoLeaveTo'),
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
                            text: 'Days: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '$infoOfDays'),
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
                            text: 'Reason:  ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: '$infoReason'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (mode == 0) {
                        // postHitApi(index);
                        rejectLeaveApi(index);
                      } else {
                        // postOutDoorApi(index);
                        rejectOutDoorApi(index);
                      }
                    },
                    child: const Text('Reject',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black45,
                      shape: StadiumBorder(),
                      minimumSize: Size(100, 40),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (mode == 0) {
                        postHitApi(index);
                      } else {
                        postOutDoorApi(index);
                      }
                    },
                    child: const Text('Post',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: StadiumBorder(),
                      minimumSize: Size(100, 40),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  Future<void> postOutDoorApi(int index) async {
    dynamic leaveId;
    print("index $index");
    print("index ${outDoorRequestList[index]["empId"]}");
    print("index ${outDoorRequestList[index]["nOfDays"]}");
    print("index ${outDoorRequestList[index]["leaveFrom"]}");
    if (outDoorRequestList[index]["nOfDays"] == "1") {
      leaveId = 16;
    } else {
      leaveId = 19;
    }

    leaveId = outDoorRequestList[index]["lvID"];
    print("index ${leaveId}");

//here
    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:post="http://xmlns.oracle.com/orawsv/XXHRMS/POST_EMP_OUTDOOR">
   <soapenv:Header/>
   <soapenv:Body>
      <post:POST_EMP_OUTDOORInput>
         <post:P_OUTPUT-VARCHAR2-OUT/>
         <post:P_LV_ID-NUMBER-IN>$leaveId</post:P_LV_ID-NUMBER-IN>
         <post:P_EMP_ID-VARCHAR2-IN>${outDoorRequestList[index]["empId"]}</post:P_EMP_ID-VARCHAR2-IN>
         <post:P_DATE-DATE-IN>${outDoorRequestList[index]["leaveFrom"]}</post:P_DATE-DATE-IN>
      </post:POST_EMP_OUTDOORInput>
   </soapenv:Body>
</soapenv:Envelope>''';
//
    var response = await post(
      Uri.parse(
          'http://XXHRMS:XXHRMS@202.125.141.170:8080/orawsv/XXHRMS/POST_EMP_OUTDOOR'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth.toString()
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    print("Response body submit: ${response.body}");
//
    var xmlString = response.body;

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(xmlString);
      final outputElement = document
          .getElement('soap:Envelope')
          ?.getElement('soap:Body')
          ?.getElement('POST_EMP_OUTDOOROutput')
          ?.getElement('P_OUTPUT');

      final outputValue = outputElement?.text;
      print(outputValue);

      if (outputValue == "Leave Posted Successfully") {
        String notificationId = DateTime.now().toString();

        await sendTopicMessage(outDoorRequestList[index]['empId']! ?? "",'Outdoor Duty Request','Your outdoor duty request has been accepted',notificationId);

        submitAlertCustom("Request Accepted!");
        // toast("Post successfully!");
      } // prints "OK"
      else {
        errorCustom(outputValue!);
        // toast("Post fail!");
      }
    }
  }

  Future<void> rejectOutDoorApi(int index) async {
    dynamic leaveId;
    print("index $index");
    print("empId ${outDoorRequestList[index]["empId"]}");
    print("nOfDays ${outDoorRequestList[index]["nOfDays"]}");
    print("leaveFrom ${outDoorRequestList[index]["leaveFrom"]}");
    if (outDoorRequestList[index]["nOfDays"] == "1") {
      leaveId = 16;
    } else {
      leaveId = 19;
    }
    print("leaveId ${leaveId}");

    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:rej="http://xmlns.oracle.com/orawsv/XXHRMS/REJECT_EMP_OUTDOOR">
   <soapenv:Header/>
   <soapenv:Body>
      <rej:REJECT_EMP_OUTDOORInput>
         <rej:P_TO_DATE-DATE-IN>${outDoorRequestList[index]["leaveTo"]}</rej:P_TO_DATE-DATE-IN>
         <rej:P_OUTPUT-VARCHAR2-OUT/>
         <rej:P_L_DAY-NUMBER-IN>${outDoorRequestList[index]["nOfDays"]}</rej:P_L_DAY-NUMBER-IN>
         <rej:P_LV_ID-NUMBER-IN>$leaveId</rej:P_LV_ID-NUMBER-IN>
         <rej:P_FM_DATE-DATE-IN>${outDoorRequestList[index]["leaveFrom"]}</rej:P_FM_DATE-DATE-IN>
         <rej:P_EMP_ID-VARCHAR2-IN>${outDoorRequestList[index]["empId"]}</rej:P_EMP_ID-VARCHAR2-IN>
      </rej:REJECT_EMP_OUTDOORInput>
   </soapenv:Body>
</soapenv:Envelope>''';

    var response = await post(
      Uri.parse(
          'http://XXHRMS:XXHRMS@202.125.141.170:8080/orawsv/XXHRMS/REJECT_EMP_OUTDOOR'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth.toString()
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    print("Response body submit: ${response.body}");
//
    var xmlString = response.body;

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(xmlString);
      final outputElement = document
          .getElement('soap:Envelope')
          ?.getElement('soap:Body')
          ?.getElement('REJECT_EMP_OUTDOOROutput')
          ?.getElement('P_OUTPUT');

      final outputValue = outputElement?.text;
      print("outputValue");

      if (outputValue == "OutDoor Rejected") {
        String notificationId = DateTime.now().toString();

        await sendTopicMessage(outDoorRequestList[index]['empId']! ?? "",'Outdoor Duty Request','Your outdoor duty request has been rejected',notificationId);

        submitAlertCustom("Request Rejected!");
        // toast("Post successfully!");
      } // prints "OK"
      else {
        errorCustom(outputValue!);
        // toast("Post fail!");
      }
    }
  }

  Future<void> postHitApi(int index) async {
    print("step in post hit api: ${leaveRequestList[index]['leaveTitle']}");

    String? leaveID = "";
    var sessionID = "";
    if (leaveRequestList[index]['leaveTitle'] == "SICK LEAVE" ||
        leaveRequestList[index]['leaveTitle'] == "HALF SICK") {
      sessionID = "0";
      // leaveID = "12";
    } else if (leaveRequestList[index]['leaveTitle'] == "HALF SICK") {
      sessionID = "0";
      //   leaveID = "18";
    } else if (leaveRequestList[index]['leaveTitle'] == "CPL LEAVE") {
      sessionID = "0";
      // leaveID = "14";
    } else if (leaveRequestList[index]['leaveTitle'] == "ANUAL LEAVE") {
      sessionID = "4";
      //  leaveID = "13";
    } else if (leaveRequestList[index]['leaveTitle'] == "CASUAL LEAVE" ||
        leaveRequestList[index]['leaveTitle'] == "HALF CASUAL") {
      sessionID = "0";
      //  leaveID = "11";
    } else if (leaveRequestList[index]['leaveTitle'] == "HALF CASUAL") {
      sessionID = "0";
      //   leaveID = "17";
    }
    leaveID = leaveRequestList[index]['lvID'];

    // 70500195 188700001 70500145 70500274
    print(
        "post: ${leaveRequestList[index]['leaveTo']!} : $sessionID : ${leaveRequestList[index]['nOfDays']!} : $leaveID : ${leaveRequestList[index]['leaveFrom']!} : ${leaveRequestList[index]['empId']!}");

    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:post="http://xmlns.oracle.com/orawsv/XXHRMS/POST_EMP_LEAVES">
   <soapenv:Header/>
   <soapenv:Body>
      <post:POST_EMP_LEAVESInput>
         <post:P_TO_DATE-DATE-IN>${leaveRequestList[index]['leaveTo']!}</post:P_TO_DATE-DATE-IN>
         <post:P_SESSION_ID-NUMBER-IN>$sessionID</post:P_SESSION_ID-NUMBER-IN>
         <post:P_OUTPUT-VARCHAR2-OUT/>
         <post:P_L_DAY-NUMBER-IN>${leaveRequestList[index]['nOfDays']!}</post:P_L_DAY-NUMBER-IN>
         <post:P_LV_ID-NUMBER-IN>$leaveID</post:P_LV_ID-NUMBER-IN>
         <post:P_FM_DATE-DATE-IN>${leaveRequestList[index]['leaveFrom']!}</post:P_FM_DATE-DATE-IN>
         <post:P_EMP_ID-VARCHAR2-IN>${leaveRequestList[index]['empId']!}</post:P_EMP_ID-VARCHAR2-IN>
         <post:P_CPL_DATE-DATE-IN></post:P_CPL_DATE-DATE-IN>
      </post:POST_EMP_LEAVESInput>
   </soapenv:Body>
</soapenv:Envelope>''';
    var response = await post(
      Uri.parse(
          'http://XXHRMS:XXHRMS@202.125.141.170:8080/orawsv/XXHRMS/POST_EMP_LEAVES'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth.toString()
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    print("Response body submit: ${response.body}");

    var xmlString = response.body;

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(xmlString);
      final outputElement = document
          .getElement('soap:Envelope')
          ?.getElement('soap:Body')
          ?.getElement('POST_EMP_LEAVESOutput')
          ?.getElement('P_OUTPUT');

      final outputValue = outputElement?.text;
      print(outputValue);

      if (outputValue == "Leave Posted Successfully") {
        String notificationId = DateTime.now().toString();

        await sendTopicMessage(leaveRequestList[index]['empId']! ?? "",'Leave Request','Your leave request has been accepted',notificationId);

        submitAlertCustom("Request Accepted!");
        // toast("Post successfully!");
      } // prints "OK"
      else {
        errorCustom(outputValue!);
        // toast("Post fail!");
      }
    }
  }

  Future<void> rejectLeaveApi(int index) async {
    print(
        "step in rejectLeaveApi hit api: ${leaveRequestList[index]['leaveTitle']}");

    var leaveID = "";
    var sessionID = "";
    if (leaveRequestList[index]['leaveTitle'] == "SICK LEAVE") {
      sessionID = "0";
      leaveID = "12";
    } else if (leaveRequestList[index]['leaveTitle'] == "HALF SICK") {
      sessionID = "0";
      leaveID = "18";
    } else if (leaveRequestList[index]['leaveTitle'] == "CPL LEAVE") {
      sessionID = "0";
      leaveID = "14";
    } else if (leaveRequestList[index]['leaveTitle'] == "ANUAL LEAVE") {
      sessionID = "4";
      leaveID = "13";
    } else if (leaveRequestList[index]['leaveTitle'] == "CASUAL LEAVE") {
      sessionID = "0";
      leaveID = "11";
    } else if (leaveRequestList[index]['leaveTitle'] == "HALF CASUAL") {
      sessionID = "0";
      leaveID = "17";
    }

    // String username = 'xxhrms';
    // String password = 'xxhrms';
    // String basicAuth =
    //     'Basic ' + base64.encode(utf8.encode('$username:$password'));
    // print(basicAuth);

    // 70500195 188700001 70500145 70500274

    print(
        "reject: ${leaveRequestList[index]['leaveTo']!} : $sessionID : ${leaveRequestList[index]['nOfDays']!} : $leaveID : ${leaveRequestList[index]['leaveFrom']!} : ${leaveRequestList[index]['empId']!}");

    var requestBody =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:rej="http://xmlns.oracle.com/orawsv/XXHRMS/REJECT_EMP_LEAVES">
   <soapenv:Header/>
   <soapenv:Body>
      <rej:REJECT_EMP_LEAVESInput>
         <rej:P_TO_DATE-DATE-IN>${leaveRequestList[index]['leaveTo']!}</rej:P_TO_DATE-DATE-IN>
         <rej:P_SESSION_ID-NUMBER-IN>$sessionID</rej:P_SESSION_ID-NUMBER-IN>
         <rej:P_OUTPUT-VARCHAR2-OUT/>
         <rej:P_L_DAY-NUMBER-IN>${leaveRequestList[index]['nOfDays']!}</rej:P_L_DAY-NUMBER-IN>
         <rej:P_LV_ID-NUMBER-IN>$leaveID</rej:P_LV_ID-NUMBER-IN>
         <rej:P_FM_DATE-DATE-IN>${leaveRequestList[index]['leaveFrom']!}</rej:P_FM_DATE-DATE-IN>
         <rej:P_EMP_ID-VARCHAR2-IN>${leaveRequestList[index]['empId']!}</rej:P_EMP_ID-VARCHAR2-IN>
      </rej:REJECT_EMP_LEAVESInput>
   </soapenv:Body>
</soapenv:Envelope>''';

    var response = await post(
      Uri.parse(
          'http://XXHRMS:XXHRMS@202.125.141.170:8080/orawsv/XXHRMS/REJECT_EMP_LEAVES'),
      headers: {
        'content-type': 'text/xml; charset=utf-8',
        'authorization': basicAuth.toString()
      },
      body: utf8.encode(requestBody),
    );

    print("Response status: ${response.statusCode}");
    print("Response body submit: ${response.body}");

    var xmlString = response.body;

    if (response.statusCode == 200) {
      final document = xml.XmlDocument.parse(xmlString);
      final outputElement = document
          .getElement('soap:Envelope')
          ?.getElement('soap:Body')
          ?.getElement('REJECT_EMP_LEAVESOutput')
          ?.getElement('P_OUTPUT');

      final outputValue = outputElement?.text;
      print("outputValue:  + ${outputValue}");

      if (outputValue == "Leave Rejected") {
        submitAlertCustom("Request Rejected!");
        String notificationId = DateTime.now().toString();

        await sendTopicMessage(leaveRequestList[index]['empId']! ?? "",'Leave Request','Your leave request has been rejected',notificationId);

        // toast("Post successfully!");
      } // prints "OK"
      else {
        errorCustom(outputValue!);
        // toast("Post fail!");
      }
    }
  }

  void submitAlertCustom(String msg) {
    Dialog doneDialog = Dialog(
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
                  child: Lottie.network(
                      "https://assets9.lottiefiles.com/packages/lf20_vzhtcqsd.json")),
            ),
            Padding(padding: EdgeInsets.only(top: 5.0)),
            Text(msg),
            TextButton(
                onPressed: () {
                  //  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                },
                child: Text(
                  'Close!',
                  style: TextStyle(color: Colors.green, fontSize: 16.0),
                ))
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => doneDialog);
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
                  child: Lottie.network(
                      "https://assets10.lottiefiles.com/packages/lf20_O6BZqckTma.json")),
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
