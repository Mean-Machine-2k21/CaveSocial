import 'package:flutter/material.dart';

import '../global.dart';

class AppTextStyle {
  static String _appFont = 'CircularStd';
  String get appFont => _appFont;
  TextStyle heading = TextStyle(
    fontFamily: _appFont,
    fontSize: 25,
    fontWeight: FontWeight.normal,
    // color: color.contrast,
  );
  TextStyle headingBold = TextStyle(
    fontFamily: _appFont,
    fontSize: 25,
    fontWeight: FontWeight.bold,
    // color: color.contrast,
  );
  TextStyle heading2 = TextStyle(
    fontFamily: _appFont,
    fontSize: 20,
    fontWeight: FontWeight.normal,
    // color: color.contrast,
  );
  TextStyle heading2Bold = TextStyle(
    fontFamily: _appFont,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    // color: color.contrast,
  );
  TextStyle body = TextStyle(
    fontFamily: _appFont,
    fontSize: 15,
    fontWeight: FontWeight.normal,
    // color: color.contrast,
  );
  TextStyle bodyBold = TextStyle(
    fontFamily: _appFont,
    fontSize: 15,
    fontWeight: FontWeight.bold,
    // color: color.contrast,
  );
  
}
