import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import '../../utils/Toast.dart';
import 'Home.dart';

class RequestApproval extends StatefulWidget {
  const RequestApproval({Key? key}) : super(key: key);

  @override
  _RequestApprovalState createState() => _RequestApprovalState();
}

class _RequestApprovalState extends State<RequestApproval> {
  List<Map<String, String>> leaveRequestList = [];
  String infoEmpId = "0000";
  String infoLeaveTitle = "0000";
  String infoLeaveFrom = "0000";
  String infoLeaveTo = "0000";
  String infoOfDays = "0000";
  String infoApprovalEmpId = "0000";

  bool fetchOrNot = false;

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
    final prefs = await SharedPreferences.getInstance();
    final String? empIDSp = prefs.getString('empID');
    // 70500195 188700001 70500145 70500274
    var requestBody = '''<?xml version="1.0" encoding="utf-8"?>
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:get="http://xmlns.oracle.com/orawsv/XXHRMS/GET_EMP_PEND_LV_APPROVAL">
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

    var document = xml.XmlDocument.parse(xmlSP);
    var rows = document.findAllElements('ROW');
    print(
        "Response document length: ${document.findAllElements('ROW').length}");

    if(document.findAllElements('ROW').isEmpty){
      toast("No data available! ");
    }
    for (var row in rows) {
      var empId = row.findElements('EMP_ID').single.text;
      var leaveTitle = row.findElements('LEAVE_TITLE').single.text;
      var leaveFrom = row.findElements('LEAVE_FROM').single.text;
      var leaveTo = row.findElements('LEAVE_TO').single.text;
      var nOfDays = row.findElements('NO_OF_DAYS').single.text;
      var approvalEmpId = row.findElements('APPROVAL_EMP_ID').single.text;
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
      });
      //
      // employeesDirectoryBackup = employeesDirectory;
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
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
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
                          height: SizeConfig.heightMultiplier * 40,
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
                                                "${index + 1}", //here
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
                                                child: ElevatedButton(
                                                  onPressed: () {
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
                                                    infoApprovalEmpId =
                                                        leaveRequestList[index]
                                                            ['approvalEmpId']!;

                                                    infoAlertCustom(index);
                                                  },
                                                  child: Text('Action',
                                                      style: TextStyle(
                                                        fontSize: 7,
                                                        color: Colors.black,
                                                      )),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Clrs.white,
                                                    shape: StadiumBorder(),
                                                    minimumSize: Size(50, 20),
                                                  ),
                                                ),
                                              ),
                                              flex: 2)
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      : CircularProgressIndicator(color: Colors.grey,),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
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
                          Text(
                            "From",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Clrs.dark_Grey),
                          ),
                          Text(
                            "To",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Clrs.dark_Grey),
                          ),
                          Text(
                            "Days",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Clrs.dark_Grey),
                          ),
                          Text(
                            "Appr",
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
                  child: fetchOrNot ? SizedBox() : CircularProgressIndicator(color: Colors.grey,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void infoAlertCustom(int index) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 350.0,
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
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 50.0)),
              ElevatedButton(
                onPressed: () {
                  postHitApi(index);
                },
                child: const Text('Post',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Clrs.black,
                  shape: StadiumBorder(),
                  minimumSize: Size(150, 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => errorDialog);
  }

  Future<void> postHitApi(
      int index
      ) async {
    //here

    // 'empId': empId,
    // 'leaveTitle': leaveTitle,
    // 'leaveFrom': leaveFrom,
    // 'leaveTo': leaveTo,
    // 'nOfDays': nOfDays,
    // 'approvalEmpId': approvalEmpId,
    // 'empDes': empDes,
    // 'empName': empName,
     print("step in post hit api: ${leaveRequestList[index]['leaveTitle']}");

     var leaveID="";
     var sessionID="";
     if(leaveRequestList[index]['leaveTitle']=="SICK LEAVE"){

       sessionID="0";
       leaveID="12";
     }
     else if(leaveRequestList[index]['leaveTitle']=="CPL LEAVE"){
       sessionID="0";
       leaveID="14";
     }
     else if(leaveRequestList[index]['leaveTitle']=="ANUAL LEAVE"){
       sessionID="4";
       leaveID="13";
     }
     else if(leaveRequestList[index]['leaveTitle']=="CASUAL LEAVE"){
       sessionID="0";
       leaveID="11";
     }


    String username = 'xxhrms';
    String password = 'xxhrms';
    String basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);

    // 70500195 188700001 70500145 70500274

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
        'authorization': basicAuth
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

      if (outputValue == "OK") {
        submitAlertCustom();
        // toast("Post successfully!");
      } // prints "OK"
      else {
        errorCustom(outputValue!);
        // toast("Post fail!");
      }
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
