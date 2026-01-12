import 'package:flutter/material.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';

Widget boldText(
  String title, {
  Key? key,
  double? fontSize = 13,
  Color? color = CustomColors.blackTextColor,
  TextAlign? textAlign,
  TextOverflow? overflow,
  int? maxLines,
  bool softWrap = true,
}) =>
    Text(
      title,
      key: key,
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap,
      overflow: overflow,
      style: CustomTextStyles.bold(
        fontSize: fontSize,
        color: color,
      ),
    );

Widget semiBoldText(
  String title, {
  Key? key,
  double? fontSize = 13,
  Color? color = CustomColors.blackTextColor,
  TextAlign? textAlign,
  TextOverflow? overflow,
  int? maxLines,
  bool softWrap = true,
}) =>
    Text(
      title,
      key: key,
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap,
      overflow: overflow,
      style: CustomTextStyles.semiBold(
        fontSize: fontSize,
        color: color,
      ),
    );

Widget regularText(
  String title, {
  Key? key,
  double? fontSize = 13,
  Color? color = CustomColors.blackTextColor,
  TextAlign? textAlign,
  int? maxLines,
  bool softWrap = true,
}) =>
    Text(
      title,
      key: key,
      textAlign: textAlign,
      maxLines: maxLines,
      softWrap: softWrap,
      style: CustomTextStyles.regular(
        fontSize: fontSize,
        color: color,
      ),
    );

Widget mediumText(
  String title, {
  Key? key,
  double? fontSize = 13,
  Color? color,
  TextAlign? textAlign,
  int? maxLines,
}) =>
    Text(
      title,
      key: key,
      textAlign: textAlign,
      maxLines: maxLines,
      style: CustomTextStyles.w500(
        fontSize: fontSize,
        color: color,
      ),
    );
