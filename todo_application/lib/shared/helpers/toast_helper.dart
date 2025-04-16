import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> showCustomToast({
  required String message,
  ToastGravity gravity = ToastGravity.BOTTOM,
  Color backgroundColor = const Color(0xFF12365F),
  Color textColor = const Color(0xfffafafa),
  double fontSize = 16,
  Toast toastLength = Toast.LENGTH_LONG,
}) async {
  await Fluttertoast.showToast(
    msg: message,
    toastLength: toastLength,
    gravity: gravity,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: fontSize,
  );
}
