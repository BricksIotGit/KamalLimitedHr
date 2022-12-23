import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import 'Home.dart';

class VisitorRequest extends StatefulWidget {
  const VisitorRequest({Key? key}) : super(key: key);

  @override
  _VisitorRequestState createState() => _VisitorRequestState();
}

class _VisitorRequestState extends State<VisitorRequest> {
  bool valuefirst = false;
  bool valueSecond = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
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
                              "Visitor Request",
                              style: TextStyle(color: Clrs.white, fontSize: 20),
                            )))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("Fill the form", style: TextStyle(fontSize: 16, color: Clrs.dark_Grey),),

                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
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
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
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
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
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
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        labelText: 'Date',
                        labelStyle: TextStyle(color: Colors.black)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Meal"),
                      Row(
                        children: [
                          Text("Special"),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.grey,
                            value: this.valuefirst,
                            onChanged: (bool? value) {
                              setState(() {
                                this.valuefirst = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Standard"),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.grey,
                            value: this.valuefirst,
                            onChanged: (bool? value) {
                              setState(() {
                                this.valuefirst = value!;
                              });
                            },
                          ),
                        ],
                      ),


                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Type"),
                      Row(
                        children: [
                          Text("Personal"),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.grey,
                            value: this.valueSecond,
                            onChanged: (bool? value) {
                              setState(() {
                                this.valueSecond = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Company"),
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.grey,
                            value: this.valueSecond,
                            onChanged: (bool? value) {
                              setState(() {
                                this.valueSecond = value!;
                              });
                            },
                          ),
                        ],
                      ),


                    ],
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
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black, width: 1.0),
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
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => Home()));
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
      ),
    );
  }
}
