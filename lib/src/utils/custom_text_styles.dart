import 'package:flutter/material.dart';

class CustomTextStyles {
  static TextStyle bold(
          {double? fontSize = 13, Color? color, double? height}) =>
      TextStyle(
        fontFamily: "PhantomSans",
        package: 'mca_official_flutter_sdk',
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        color: color,
        height: height,
      );

  static TextStyle semiBold(
          {double? fontSize = 13, Color? color, double? height}) =>
      TextStyle(
        fontFamily: "PhantomSans",
        package: 'mca_official_flutter_sdk',
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
        color: color,
        height: height,
      );

  static TextStyle regular(
          {double? fontSize = 13, Color? color, double? height}) =>
      TextStyle(
        fontFamily: "PhantomSans",
        package: 'mca_official_flutter_sdk',
        fontSize: fontSize,
        color: color,
        height: height,
      );

  static TextStyle w500(
          {double? fontSize = 13, Color? color, double? height}) =>
      TextStyle(
        fontFamily: "PhantomSans",
        package: 'mca_official_flutter_sdk',
        fontWeight: FontWeight.w500,
        fontSize: fontSize,
        color: color,
        height: height,
      );
}
