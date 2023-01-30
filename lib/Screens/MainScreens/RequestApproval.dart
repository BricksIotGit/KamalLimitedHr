import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import 'Home.dart';

class RequestApproval extends StatefulWidget {
  const RequestApproval({Key? key}) : super(key: key);

  @override
  _RequestApprovalState createState() => _RequestApprovalState();
}

class _RequestApprovalState extends State<RequestApproval> {
  final items = [
    {'name': 'Ali', 'id': '1', 'type': 'Sick', 'from':'###','to':"###",'days': '1'},
    {'name': 'Akbar', 'id': '1', 'type': 'Sick', 'from':'###','to':"###",'days': '1'},
    {'name': 'Bakar', 'id': '1', 'type': 'Sick', 'from':'###','to':"###",'days': '1'},
    {'name': 'Rehan', 'id': '1', 'type': 'Sick', 'from':'###','to':"###",'days': '1'},
    {'name': 'Ali', 'id': '1', 'type': 'Sick', 'from':'###','to':"###",'days': '1'},
    {'name': 'Bashir', 'id': '1', 'type': 'Sick', 'from':'###','to':"###",'days': '1'},
    {'name': 'Ali', 'id': '1', 'type': 'Sick', 'from':'###','to':"###",'days': '1'},

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column
            (
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
                      onTap: (){
                        // Navigator.pop(context);
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => Home()));
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
                  child: Text("Leave Request",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
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
                          "Type",
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
                        ), Text(
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
              SizedBox(
                width: SizeConfig.widthMultiplier*100,
                height: SizeConfig.heightMultiplier*40,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Clrs.medium_Grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Clrs.white,
                    ),
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: Text(
                                      items[index]['id']!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1),
                                Flexible(
                                    child: Text(
                                      items[index]['name']!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1),
                                Flexible(
                                    child: Text(
                                      items[index]['type']!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1),
                                Flexible(
                                    child: Text(
                                      items[index]['from']!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1),
                                Flexible(
                                    child: Text(
                                      "to",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1) ,
                                Flexible(
                                    child: Text(
                                      "days",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1),
                                Flexible(
                                    child: SizedBox(
                                      width: SizeConfig.widthMultiplier*15,
                                      height: 20,
                                      child: ToggleSwitch(
                                        customWidths: [30.0, 30.0],
                                        cornerRadius: 10.0,
                                        activeBgColors: [[Colors.green], [Colors.redAccent]],
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.grey,
                                        inactiveFgColor: Colors.white,
                                        totalSwitches: 2,
                                        labels: ['', ''],
                                        icons: [FontAwesomeIcons.check, FontAwesomeIcons.times],
                                        onToggle: (index) {
                                          print('switched to: $index');
                                        },
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
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                  child: Text("Outdoor Request",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
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
                        ), Text(
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
              SizedBox(
                width: SizeConfig.widthMultiplier*100,
                height: SizeConfig.heightMultiplier*40,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Clrs.medium_Grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Clrs.white,
                    ),
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: Text(
                                      items[index]['id']!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1),
                                Flexible(
                                    child: Text(
                                      items[index]['name']!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1),
                                Flexible(
                                    child: Text(
                                      items[index]['from']!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1),
                                Flexible(
                                    child: Text(
                                      "to",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1) ,
                                Flexible(
                                    child: Text(
                                      "days",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Clrs.dark_Grey),
                                    ),
                                    flex: 1),
                                Flexible(
                                    child: SizedBox(
                                      width: SizeConfig.widthMultiplier*15,
                                      height: 20,
                                      child: ToggleSwitch(
                                        customWidths: [30.0, 30.0],
                                        cornerRadius: 10.0,
                                        activeBgColors: [[Colors.green], [Colors.redAccent]],
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.grey,
                                        inactiveFgColor: Colors.white,
                                        totalSwitches: 2,
                                        labels: ['', ''],
                                        icons: [FontAwesomeIcons.check, FontAwesomeIcons.times],
                                        onToggle: (index) {
                                          print('switched to: $index');
                                        },
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
              ),

            ],
          ),
        ),
      ),
    );
  }
}
