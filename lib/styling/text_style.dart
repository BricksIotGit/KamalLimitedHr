import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kamal_limited/styling/size_config.dart';


class Style {
  Style._();

  static final TextStyle titleHeading = TextStyle(
    fontSize: 1.7 * SizeConfig.textMultiplier,
    fontFamily: 'SegoeUI',
  );
  static final TextStyle subtitleHeading = TextStyle(
    fontSize: 1.7 * SizeConfig.textMultiplier,
    fontFamily: 'SegoeUI',

  );
  static final TextStyle buttonStyle = TextStyle(
    fontSize: 2.2 * SizeConfig.heightMultiplier,
    fontWeight: FontWeight.bold,
    fontFamily: 'SegoUIBold',

  );
  static final TextStyle startScreen = TextStyle(
    fontSize: 2.4 * SizeConfig.heightMultiplier,
   // color:Clrs.purple,
    fontWeight: FontWeight.bold,
    fontFamily: 'SegoUIBold',
   );
  static final TextStyle getIn = TextStyle(
      fontSize: 2.6* SizeConfig.heightMultiplier,
      color:Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'SegoeUI',
  );
  static final TextStyle select_resources = TextStyle(
    fontSize: 3.4* SizeConfig.textMultiplier,
    color:Colors.white,
    fontWeight: FontWeight.w600,
    fontFamily: 'SegoeUI',
  );
  static final TextStyle normal_text = TextStyle(
    fontSize: 3.2* SizeConfig.heightMultiplier,
    color:Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'SegoeUI',
  );
  static final TextStyle grade_number = TextStyle(
    fontSize: 3* SizeConfig.heightMultiplier,
    color:Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'SegoeUIRegular',
  );
  static final TextStyle starttext = TextStyle(
    fontSize: 2.5 * SizeConfig.heightMultiplier,
   // color:Clrs.purple,
   wordSpacing: 1.0,
    fontFamily: 'SegoUIBold',
  );
  static final TextStyle italicHeading = TextStyle(
    fontSize: 1.8 * SizeConfig.textMultiplier,
    fontFamily: 'SegoeUIItalic',
    fontStyle: FontStyle.italic

  );
  static final TextStyle chectext = TextStyle(
    fontSize: 2.5 * SizeConfig.heightMultiplier,
   // color:Clrs.purple,
    wordSpacing: 1.0,

  );
  static final TextStyle getInlarge = TextStyle(
    fontSize: 3.5* SizeConfig.textMultiplier,
    color:Colors.black,
    fontWeight: FontWeight.bold,
    wordSpacing: 2.0,
    fontFamily: 'SegoeUI',
  );
}
