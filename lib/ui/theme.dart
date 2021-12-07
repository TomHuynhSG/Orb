import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

const Color bluishClr = Color(0xFFff4667);
const Color yellowClr = Color(0xFF40798C);
const Color pinkClr = Color(0xFFFFB746);
const Color successClr = Color(0xFF009DAE);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
Color? darkHeaderClr = Colors.grey[800];

class Themes {
  static final light = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: primaryClr,
    brightness: Brightness.light,
  );
  static final dark = ThemeData(
    backgroundColor: darkGreyClr,
    brightness: Brightness.dark,
    primaryColor: primaryClr,
  );
}

TextStyle get headingTextStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

TextStyle get subHeadingTextStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.grey[400] : Colors.grey),
  );
}

TextStyle get titleTextStle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

TextStyle get subTitleTextStle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 16,
        color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[700]),
  );
}

TextStyle get bodyTextStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.white : Colors.black),
  );
}

TextStyle get body2TextStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode ? Colors.grey[200] : Colors.grey[600]),
  );
}
