import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  final items = [
    {'name': 'Ali', 'id': '1', 'dept': 'Sick', 'desig': '###', 'status': "###"},
    {
      'name': 'Akbar',
      'id': '2',
      'dept': 'Sick',
      'desig': '###',
      'status': "###"
    },
    {
      'name': 'Bakar',
      'id': '3',
      'dept': 'Sick',
      'desig': '###',
      'status': "###"
    },
    {
      'name': 'Rehan',
      'id': '4',
      'dept': 'Sick',
      'desig': '###',
      'status': "###"
    },
    {'name': 'Ali', 'id': '5', 'dept': 'Sick', 'desig': '###', 'status': "###"},
    {
      'name': 'Bashir',
      'id': '6',
      'dept': 'Sick',
      'desig': '###',
      'status': "###"
    },
    {'name': 'Ali', 'id': '7', 'dept': 'Sick', 'desig': '###', 'status': "###"},
  ];

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
                      "Department Status",
                      style: TextStyle(color: Clrs.white, fontSize: 20),
                    )))
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                child: Text(
                  "Outdoor Request",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        "Dept",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Clrs.dark_Grey),
                      ),
                      Text(
                        "Desig",
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
            SizedBox(
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
                                    items[index]['dept']!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Clrs.dark_Grey),
                                  ),
                                  flex: 1),
                              Flexible(
                                  child: Text(
                                    items[index]['desig']!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Clrs.dark_Grey),
                                  ),
                                  flex: 1),
                              Flexible(
                                  child: Text(
                                    items[index]['status']!,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Clrs.dark_Grey),
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
    );
  }
}
