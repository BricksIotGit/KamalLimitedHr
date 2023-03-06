import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:xml/xml.dart' as xml;
class Utils{
   Future<List<Map<String, String>>> getEmp(String id) async{
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
         <get:P_EMP_ID-NUMBER-IN>$id</get:P_EMP_ID-NUMBER-IN>
      </get:GET_EMP_DIRECTORYInput>
   </soapenv:Body>
</soapenv:Envelope>''';

     var response = await post(
       Uri.parse(
           'http://XXHRMS:XXHRMS@202.125.141.170:8080/orawsv/XXHRMS/GET_EMP_DIRECTORY'),
       headers: {
         'content-type': 'text/xml; charset=utf-8',
         'authorization': basicAuth
       },
       body: utf8.encode(requestBody),
     );

     print("Response status: ${response.statusCode}");
     print("Response body: ${response.body}");

     // Parse XML data
     var xmlSP = response.body.toString();

     final document = xml.XmlDocument.parse(xmlSP);
     print("Response document: ${document}");
     print("Response document length: ${document.findAllElements('ROWSET').length}");

     final rowset = document.findAllElements('ROWSET').last;

     print("Response employeesNode: ${rowset}");
     List<Map<String, String>> employees = [];

     for (var row in rowset.findAllElements('ROW')) {
       final empId = row.findElements('EMP_ID').single.text;
       final ename = row.findElements('ENAME').single.text;
       final fname = row.findElements('FNAME').single.text;
       final gndr = row.findElements('GNDR').single.text;
       final empDpt = row.findElements('EMP_DEPARTMENT').single.text;
       final empDesig = row.findElements('EMP_DESIGNATION').single.text;
       final doj = row.findElements('DOJ').single.text;
       final doc = row.findElements('DOC').single.text;
       final empType = row.findElements('EMP_TYPE').single.text;
       final empShift = row.findElements('EMP_SHIFT').single.text;

       employees.add({
         'empId': empId,
         'ename': ename,
         'fname': fname,
         'gndr': gndr,
         'empDpt': empDpt,
         'empDesig': empDesig,
         'doj': doj,
         'doc': doc,
         'empType': empType,
         'empShift': empShift,
       });
     }

     print("Response employees: ${employees}");
     return employees;
   }
}
