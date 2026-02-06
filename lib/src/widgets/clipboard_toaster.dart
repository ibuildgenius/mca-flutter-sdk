import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';

class ToastNotification {
  static show(
      {required BuildContext context,
      required String copiedText,
      required String toastMessage}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      padding: const EdgeInsets.all(6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      behavior: SnackBarBehavior.floating,
      backgroundColor: CustomColors.greyToastColor,
      content: Row(
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(7),
          //   child: Image.asset(
          //     ConstantString.mca,
          //     width: 35,
          //     height: 35,
          //     package: 'mca_official_flutter_sdk',
          //   ),
          // ),
          horizontalSpacer(80),
          Text(toastMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                color: CustomColors.whiteColor,
                fontWeight: FontWeight.w500,
              ))
        ],
      ),
    ));
  }
}
