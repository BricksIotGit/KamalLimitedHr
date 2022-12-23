import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import 'Home.dart';

class LeaveRequest extends StatefulWidget {
  const LeaveRequest({Key? key}) : super(key: key);

  @override
  _LeaveRequestState createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<LeaveRequest> {
  bool valuefirst = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        "Leave Request",
                        style: TextStyle(color: Clrs.white, fontSize: 20),
                      )))
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Leave Type",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            "Sick",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "Half Sick",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "Short",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "Casual",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "Annual",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                            child: Text(
                              "12",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "12",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "12",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "12",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "12",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            "Avoid",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            "3",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "3",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "3",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "3",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "3",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            "Bal",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            "3",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "3",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "3",
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            "3",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text(
                            "Tick",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.grey,
                              value: this.valuefirst,
                              onChanged: (bool? value) {
                                setState(() {
                                  this.valuefirst = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.grey,
                              value: this.valuefirst,
                              onChanged: (bool? value) {
                                setState(() {
                                  this.valuefirst = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.grey,
                              value: this.valuefirst,
                              onChanged: (bool? value) {
                                setState(() {
                                  this.valuefirst = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.grey,
                              value: this.valuefirst,
                              onChanged: (bool? value) {
                                setState(() {
                                  this.valuefirst = value!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              checkColor: Colors.white,
                              activeColor: Colors.grey,
                              value: this.valuefirst,
                              onChanged: (bool? value) {
                                setState(() {
                                  this.valuefirst = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: TextFormField(
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      labelText: 'Host',
                      labelStyle: TextStyle(color: Colors.black)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: TextFormField(
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      labelText: 'Visitor Name',
                      labelStyle: TextStyle(color: Colors.black)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: TextFormField(
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      labelText: 'No. of Visitors',
                      labelStyle: TextStyle(color: Colors.black)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: TextFormField(
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      labelText: 'Date',
                      labelStyle: TextStyle(color: Colors.black)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: TextFormField(
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      labelText: 'Purpose',
                      labelStyle: TextStyle(color: Colors.black)),
                  maxLines: 5,
                  minLines: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: Text('Submit',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Clrs.white,
                    shape: StadiumBorder(),
                    minimumSize: Size(250, 40),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
