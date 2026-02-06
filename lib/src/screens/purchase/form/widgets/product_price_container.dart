import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class ProductPriceContainer extends StatefulHookConsumerWidget {
  final String title;
  final bool isLoading;
  const ProductPriceContainer({
    super.key,
    required this.title,
    this.isLoading = false,
  });

  @override
  ConsumerState<ProductPriceContainer> createState() =>
      _ProductPriceContainerState();
}

class _ProductPriceContainerState extends ConsumerState<ProductPriceContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        mediumText(
          widget.title,
          fontSize: 14.sp,
          color: CustomColors.formTitleColor,
        ),
        verticalSpacer(8.sp),
        Container(
          width: double.infinity,
          height: 50.h,
          decoration: BoxDecoration(
            color: CustomColors.lightPrimaryBrandColor(),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₦',
                  style: TextStyle(
                    fontFamily: "",
                    package: 'mca_official_flutter_sdk',
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: CustomColors.primaryBrandColor(),
                  ),
                ),
                horizontalSpacer(10.sp),
                Expanded(
                  child: widget.isLoading
                      ? Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                              ),
                              child: SpinKitFadingCircle(
                                color: CustomColors.primaryBrandColor(),
                                size: 25.0,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          // (ref.watch(productPriceProvider).toString()),
                          StringUtils.formatPriceWithComma(
                                  ref.watch(productPriceProvider).toString()) ??
                              "0",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.semiBold(
                              fontSize: 18.sp,
                              color: CustomColors.primaryBrandColor()),
                        ),
                ),
              ],
            ),
          ),
        ),
        verticalSpacer(25.sp),
      ],
    );
  }
}

openGallery() async {
  ImagePicker imagePicker = ImagePicker();
  XFile? pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 612,
      maxWidth: 816);

  if (pickedFile != null) {
    File file = File(pickedFile.path);
    return file;
  }
  return null;
}
