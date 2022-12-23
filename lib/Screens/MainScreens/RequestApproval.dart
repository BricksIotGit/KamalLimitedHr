import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
          ],
        ),
      ),
    );
  }
}
