import 'package:flutter/material.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';

class CustomColors {
  static const whiteColor = Color(0xFFFFFFFF);
  static const blackColor = Color(0xFF000000);
  static const primaryText = Color(0xFF1D2939);
  static const backBorderColor = Color(0xFFF9FAFB);
  static const lightGreenColor = Color(0xFFE6F4F2);
  static const blackTextColor = Color(0xFF101828);
  static const tipTextColor = Color(0xFF2B313B);
  static const greyTextColor = Color(0xFF667085);
  static const redExitColor = Color(0xFFF04438);
  static const redTimeUpColor = Color(0xFFFDA29B);
  static const lightRedColor = Color(0xFFFEF3F2);

  static const progressGreenColor = Color(0xFF12B76A);
  static const progressGreenTextColor = Color(0xFF039855);
  static const lightDividerColor = Color(0xFFEAEAEA);
  static const blueTextColor = Color(0xFF0084FE);

  static const greyToastColor = Color(0xFF9CA3AF);
  static const dividerGreyColor = Color(0xFFEAECF0);
  static const lightDividerGreyColor = Color(0xFFEBEBEB);

  static const checkBoxBorderColor = Color(0xFF98A2B3);
  static const productBorderColor = Color(0xFFD0D5DD);
  static const discountBgColor = Color(0xFFF2F4F7);
  static const backTextColor = Color(0xFF344054);
  static const lightGreenBgColor = Color(0xFFA6F4C5);
  static const lightOrangeBgColor = Color(0xFFFEDF89);

  static const darkTextColor = Color(0xFF070707);

  static const formTitleColor = Color(0xFF475467);
  static const formHintColor = Color(0xFF999CA0);

  static const lightBlackColor = Color(0xFF747474);
  static const orangeColor = Color(0xFFF79009);
  static const disabledOrangeColor = Color(0xFFFEC84B);

  static const lightOrangeColor = Color(0xFFFFFAEB);

  static const toastGreenColor = Color(0xFF12B76A);

  static const toastOrangeColor = Color(0xFFF79009);

  static const toastRedColor = Color(0xFFF04438);

  static Color primaryBrandColor() {
    String? brandColorPrimary = Global.brandColorPrimary;
    bool isDefaultColour = (Global.businessDetails == null ||
        Global.businessDetails?.isDefaultLogo == true);

    // Global.isDefaultColour;

    if (brandColorPrimary == null ||
        brandColorPrimary.isEmpty ||
        isDefaultColour == true) {
      return const Color(0xFF3BAA90);
    }

    brandColorPrimary = brandColorPrimary.toUpperCase().replaceAll("#", "");
    if (brandColorPrimary.length == 6) {
      brandColorPrimary = "FF$brandColorPrimary";
    }

    if (brandColorPrimary.length != 8) {
      return const Color(0xFF3BAA90);
    }

    try {
      return Color(int.parse(brandColorPrimary, radix: 16));
    } catch (e) {
      return const Color(0xFF3BAA90);
    }
  }

  static Color lightPrimaryBrandColor() =>
      primaryBrandColor().withOpacity(0.07);

  static Color lighterPrimaryBrandColor() =>
      primaryBrandColor().withOpacity(0.05);

  ///OLD
  static const secondaryBlackColor = Color(0xFF070707);

  static const gray700Color = Color(0xFF344054);
  static const gray400Color = Color(0xFF98A2B3);
  static const gray100Color = Color(0xFFF2F4F7);
  static const grayTextColor = Color(0xFF909090);

  static Color transGray100Color = const Color(0xFF555555).withOpacity(0.6);

  static Color transGrayColor = const Color(0xFF2B2B2B).withOpacity(0.5);
  static const grayColor = Color(0xFF2B2B2B);
  static const grayiconColor = Color(0xFFACACAC);

  static const lightGrayTextColor = Color(0xFF5F738C);
  static const purple500Color = Color(0xFF7A5AF8);
  static const purple50Color = Color(0xFFF4F3FF);
  static const purple25Color = Color(0xFFFAFAFF);

  static const greenColor = Color(0xFF3BAA90);
  static const success500Color = Color(0xFF12B76A);

  static const redColor = Color(0xFFCA0808);
}
