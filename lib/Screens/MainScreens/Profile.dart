import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../styling/colors.dart';
import '../../styling/images.dart';
import '../../styling/size_config.dart';
import 'Home.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                        "Profile",
                        style: TextStyle(color: Clrs.white, fontSize: 20),
                      )))
                ],
              ),
              Image(image: AssetImage(Images.profile_ic)),
              Wrap(direction: Axis.vertical,
                  //  spacing: 1,
                  children: [
                    Container(
                      //  width: 80 * SizeConfig.widthMultiplier,
                      //padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Clrs.medium_Grey),
                        borderRadius: BorderRadius.circular(20),
                        color: Clrs.light_Grey,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    //  text: 'Hello ',
                                    //style: DefaultTextStyle.of(context).,
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Name:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      TextSpan(
                                          text: ' Ali',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    //  text: 'Hello ',
                                    //style: DefaultTextStyle.of(context).,
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Profile:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      TextSpan(
                                          text: ' Ali',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    //  text: 'Hello ',
                                    //style: DefaultTextStyle.of(context).,
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Department:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      TextSpan(
                                          text: ' Accounts',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    //  text: 'Hello ',
                                    //style: DefaultTextStyle.of(context).,
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Designation:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      TextSpan(
                                          text: ' Manager',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    //  text: 'Hello ',
                                    //style: DefaultTextStyle.of(context).,
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Salary:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      TextSpan(
                                          text: ' 00000',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    //  text: 'Hello ',
                                    //style: DefaultTextStyle.of(context).,
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Joining Date:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      TextSpan(
                                          text: ' 1 May 2021',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    //  text: 'Hello ',
                                    //style: DefaultTextStyle.of(context).,
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Name:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      TextSpan(
                                          text: ' Ali',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    //  text: 'Hello ',
                                    //style: DefaultTextStyle.of(context).,
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Profile:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      TextSpan(
                                          text: ' Ali',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    //  text: 'Hello ',
                                    //style: DefaultTextStyle.of(context).,
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Department:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      TextSpan(
                                          text: ' Accounts',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    //  text: 'Hello ',
                                    //style: DefaultTextStyle.of(context).,
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Designation:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      TextSpan(
                                          text: ' Manager',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    //  text: 'Hello ',
                                    //style: DefaultTextStyle.of(context).,
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Salary:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      TextSpan(
                                          text: ' 00000',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    //  text: 'Hello ',
                                    //style: DefaultTextStyle.of(context).,
                                    children: const <TextSpan>[
                                      TextSpan(
                                          text: 'Joining Date:',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey)),
                                      TextSpan(
                                          text: ' 1 May 2021',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 20, 20, 40),
                  child: Wrap(direction: Axis.vertical,
                      //  spacing: 1,
                      children: [
                        Container(
                          //  width: 80 * SizeConfig.widthMultiplier,
                          //padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Clrs.medium_Grey),
                            borderRadius: BorderRadius.circular(20),
                            color: Clrs.light_Grey,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Contact Info",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        //  text: 'Hello ',
                                        //style: DefaultTextStyle.of(context).,
                                        children: const <TextSpan>[
                                          TextSpan(
                                              text: 'Extension:',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey)),
                                          TextSpan(
                                              text: ' +92',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        //  text: 'Hello ',
                                        //style: DefaultTextStyle.of(context).,
                                        children: const <TextSpan>[
                                          TextSpan(
                                              text: 'Mobile:',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey)),
                                          TextSpan(
                                              text: ' 039855455',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        //  text: 'Hello ',
                                        //style: DefaultTextStyle.of(context).,
                                        children: const <TextSpan>[
                                          TextSpan(
                                              text: 'Phone:',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey)),
                                          TextSpan(
                                              text: ' 487449774',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RichText(
                                      text: TextSpan(
                                        //  text: 'Hello ',
                                        //style: DefaultTextStyle.of(context).,
                                        children: const <TextSpan>[
                                          TextSpan(
                                              text: 'Email:',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey)),
                                          TextSpan(
                                              text: ' employ@gmail.com',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
