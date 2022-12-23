import 'package:anim_search_bar/anim_search_bar.dart';
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
  TextEditingController textController=new TextEditingController();

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

                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                  child: Center(
                    child: Text("Employe Directory", style: TextStyle(color: Clrs.white, fontSize: 20),)
                  ),
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
                          AnimSearchBar(
                            width:90* SizeConfig.widthMultiplier, textController: textController,
                            onSuffixTap: (){
                              setState(() {
                                textController.clear();
                              });
                            }, onSubmitted: (String ) {  },

                          ),
                          // Image(
                          //   //   height:50* SizeConfig.heightMultiplier,
                          //   width: 10 * SizeConfig.widthMultiplier,
                          //   image: AssetImage(Images.search_ic),
                          // ),
                          // Image(
                          //   //   height:50* SizeConfig.heightMultiplier,
                          //   width: 10 * SizeConfig.widthMultiplier,
                          //   image: AssetImage(Images.notification_ic),
                          // ),
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
                      width: 35*SizeConfig.widthMultiplier,

                      child: SizedBox(
                        width: 30*SizeConfig.widthMultiplier,
                        child: DropdownButtonFormField(

                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top:5, bottom: 5,left: 10,right: 5), //this one
                            focusedBorder: OutlineInputBorder(

                              borderSide: BorderSide(color: Clrs.light_Grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Clrs.light_Grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Clrs.light_Grey, width: 1),
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
                      width: 35*SizeConfig.widthMultiplier,
                      child: SizedBox(
                        width: 30*SizeConfig.widthMultiplier,
                        child: DropdownButtonFormField(
                          isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top:5, bottom: 5,left: 10,right: 5), //this one

                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Clrs.light_Grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Clrs.light_Grey, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Clrs.light_Grey, width: 1),
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
                        Text("Sr.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Name.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Designation.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Dept.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Status.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Clrs.medium_Grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Clrs.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("1.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Ali",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("GM Manager",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Hr",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Info.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Clrs.medium_Grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Clrs.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("1.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Ali",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("GM Manager",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Hr",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Info.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Clrs.medium_Grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Clrs.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("1.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Ali",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("GM Manager",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Hr",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Info.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Clrs.medium_Grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Clrs.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("1.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Ali",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("GM Manager",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Hr",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Info.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),)
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Clrs.medium_Grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Clrs.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("1.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Ali",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("GM Manager",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Hr",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),),
                        Text("Info.",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 ,color: Clrs.dark_Grey),)
                      ],
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
