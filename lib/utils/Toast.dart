import 'dart:developer';
import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';

void toast(
  String value, {
  ToastGravity? gravity,
  length = Toast.LENGTH_SHORT,
  Color? bgColor,
  Color? textColor,
  bool print = false,
}) {
  if (value.validate().isEmpty ) {
    log(value);
  } else {
    Fluttertoast.showToast(
      msg: value.validate(),
      gravity: gravity,
      toastLength: length,
      backgroundColor: bgColor,
      textColor: textColor,
    );
    if (print) log(value);
  }
}

extension StringExtension on String? {

  String validate({String value = ''}) {
    if (this.isEmptyOrNull) {
      return value;
    } else {
      return this!;
    }
  }

  bool get isEmptyOrNull =>
      this == null ||
          (this != null && this!.isEmpty) ||
          (this != null && this! == 'null');
}