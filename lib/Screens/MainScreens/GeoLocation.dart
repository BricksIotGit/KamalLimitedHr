import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kamal_limited/utils/Toast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../styling/colors.dart';
import '../../styling/images.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import '../../styling/size_config.dart';
import '../Setting/google_map.dart';
import 'Home.dart';

class GeoLocation extends StatefulWidget {
  const GeoLocation({Key? key}) : super(key: key);

  @override
  State<GeoLocation> createState() => _GeoLocationState();
}

class _GeoLocationState extends State<GeoLocation> {
  var isLoading = false;
  String username = 'xxhrms';
  String password = 'xxhrms';

  Future<void> markPresence(String attnd) async {
    // Request location permission
    LocationPermission permission = await Geolocator.requestPermission();
    final prefs = await SharedPreferences.getInstance();
    final String? empPf_No = prefs.getString('pf_no');
    print("geo loaction empPf_No $empPf_No");
    if (permission == LocationPermission.denied) {
      // Permission denied, handle accordingly
    } else if (permission == LocationPermission.deniedForever) {
      // Permission permanently denied, handle accordingly
    } else {
      // Permission granted, proceed with getting the user's location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print("my location latlong :${position.latitude},${position.longitude}");
      // print("radius : 507 meters");
      // Define the valid location

      LatLng validLocation = const LatLng(31.39242550667618,
          74.32504793466433); // kamal limited Example valid location
      // LatLng validLocation = const LatLng(31.581384, 74.396033);  //homeExample valid location
      double validRadius = 50; // Example valid radius in meters

      // Calculate the distance from the valid location
      Geodesy geodesy = Geodesy();
      double distanceInMeters = double.parse(geodesy
          .distanceBetweenTwoGeoPoints(
            LatLng(position.latitude, position.longitude),
            validLocation,
          )
          .toString());
      print("Distance from valid location ${distanceInMeters}");
      // Verify the distance against the valid radius
      if (distanceInMeters <= validRadius) {
        if (empPf_No != null) {
          if (attnd == "in") {
            markAttndIn(empPf_No);
          } else {
            markAttndOut(empPf_No);
          }
        } else {
          toast("PF No is missing!");
        }
      } else {
        setState(() {
          isLoading = false;
        });
        errorCustom("You are not in office");
        print("absent");
        // Distance is outside the valid radius
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      "Mark Attendance",
                      style: TextStyle(color: Clrs.white, fontSize: 20),
                    )))
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Note: Attendance will only be marked when you are in the office!",
                style: TextStyle(color: Colors.grey),
              ),
            ),

            SizedBox(
              height: SizeConfig.heightMultiplier * 60,
              width: SizeConfig.widthMultiplier * 90,
              child:
                  Padding(padding: EdgeInsets.all(10.0), child: MyMapWidget()),
            ),

            isLoading
                ? CircularProgressIndicator(
                    color: Colors.grey,
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await markPresence("in");
                    },
                    child: Text('Attendance In',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Clrs.black,
                      shape: StadiumBorder(),
                      minimumSize: Size(150, 40),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await markPresence("out");
                    },
                    child: Text('Attendance Out',
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

            // Center(
            //   child: ElevatedButton(
            //       onPressed: () async {
            //         await markPresence();
            //       },
            //       child: const Text("Present")),
            // ),
          ],
        ),
      ),
    );
  }

  void errorCustom(String msg) {
    Dialog errorDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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

  void submitAlertCustom(String msg) {
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
                        "https://assets1.lottiefiles.com/packages/lf20_1uwfterr.json"))),
            Padding(padding: EdgeInsets.only(top: 5.0)),
            Text("Message: $msg"),
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

  Future<void> markAttndOut(String empPf_No) async {
    String url =
        'http://202.125.141.170:8080/orawsv/XXHRMS/POST_ATTND_OUT'; // Replace with the actual URL of your SOAP API
    String auth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    String xmlBody = '''
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:post="http://202.125.141.170:8080/orawsv/XXHRMS/POST_ATTND_OUT">
   <soapenv:Header/>
   <soapenv:Body>
      <post:POST_ATTND_OUTInput>
         <post:P_PF_NO-NUMBER-IN>$empPf_No</post:P_PF_NO-NUMBER-IN>
         <post:P_OUTPUT-VARCHAR2-OUT/>
      </post:POST_ATTND_OUTInput>
   </soapenv:Body>
</soapenv:Envelope>
  ''';

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'text/xml',
          'Authorization': auth,
        },
        body: xmlBody,
      );

      if (response.statusCode == 200) {
        print("attnd in pressed response ${response.body}");

        // Parse the response body using the xml package
        var document = xml.XmlDocument.parse(response.body);
        var envelope = document.findAllElements('soap:Envelope').single;
        var body = envelope.findAllElements('soap:Body').single;
        var outputElement = body
            .findAllElements('POST_ATTND_OUTOutput',
                namespace:
                    'http://202.125.141.170:8080/orawsv/XXHRMS/POST_ATTND_OUT')
            .single;
        var pOutput = outputElement.findElements('P_OUTPUT').single;
        String pOutputValue = pOutput.text;

        print('P_OUTPUT Value: $pOutputValue');

        if (pOutputValue != "OUT Successfully") {
          errorCustom(pOutputValue);
        } else {
          submitAlertCustom(pOutputValue);
        } //response.body;
      } else {
        throw Exception('SOAP request failed');
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> markAttndIn(String empPf_No) async {
    String url =
        'http://202.125.141.170:8080/orawsv/XXHRMS/POST_ATTND_IN'; // Replace with the actual URL of your SOAP API
    String auth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    String xmlBody = '''
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:post="http://202.125.141.170:8080/orawsv/XXHRMS/POST_ATTND_IN">
         <soapenv:Header/>
         <soapenv:Body>
            <post:POST_ATTND_INInput>
               <post:P_PF_NO-NUMBER-IN>$empPf_No</post:P_PF_NO-NUMBER-IN>
               <post:P_OUTPUT-VARCHAR2-OUT/>
            </post:POST_ATTND_INInput>
         </soapenv:Body>
      </soapenv:Envelope>
  ''';

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'text/xml',
          'Authorization': auth,
        },
        body: xmlBody,
      );

      if (response.statusCode == 200) {
        print("attnd in pressed response ${response.body}");

        // Parse the response body using the xml package
        var document = xml.XmlDocument.parse(response.body);
        var envelope = document.findAllElements('soap:Envelope').single;
        var body = envelope.findAllElements('soap:Body').single;
        var outputElement = body
            .findAllElements('POST_ATTND_INOutput',
                namespace:
                    'http://202.125.141.170:8080/orawsv/XXHRMS/POST_ATTND_IN')
            .single;
        var pOutput = outputElement.findElements('P_OUTPUT').single;
        String pOutputValue = pOutput.text;

        print('P_OUTPUT Value: $pOutputValue');

        if (pOutputValue == "Already IN" || pOutputValue == "Wait For 2 Minutes to Sign-IN Again.") {
          errorCustom(pOutputValue);
        } else {
          submitAlertCustom(pOutputValue);
        } //response.body;
      } else {
        throw Exception('SOAP request failed');
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
