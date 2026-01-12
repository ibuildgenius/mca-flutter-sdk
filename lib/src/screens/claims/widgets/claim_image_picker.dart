// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/generic_dialog.dart';
import 'package:mca_official_flutter_sdk/src/screens/claims/upload_third_party_document_screen.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class ClaimImagePicker extends StatefulHookConsumerWidget {
  final String label;

  final StateProvider<File?> imageProvider;
  const ClaimImagePicker({
    super.key,
    required this.label,
    required this.imageProvider,
  });

  @override
  ConsumerState<ClaimImagePicker> createState() => _ClaimImagePickerState();
}

class _ClaimImagePickerState extends ConsumerState<ClaimImagePicker> {
  @override
  Widget build(BuildContext context) {
    final shouldValidate = ref.watch(validateClaimDocProvider);

    return GestureDetector(
      onTap: ref.watch(widget.imageProvider) == null
          ? () async {
              // var selectedImage = await selectImage(ImageSource.camera);
              File? selectedImage;

              await GenericDialog().showSelectImageDialog(
                context: context,
                onCameraPressed: () async {
                 // Navigator.pop(context);
                  selectedImage = await selectImage(ImageSource.camera);
                  if (selectedImage != null) {
                    ref.read(widget.imageProvider.notifier).state =
                        selectedImage;
                  }
                },
                onGalleryPressed: () async {
                 // Navigator.pop(context);
                  selectedImage = await selectImage(ImageSource.gallery);
                  if (selectedImage != null) {
                    ref.read(widget.imageProvider.notifier).state =
                        selectedImage;
                  }
                },
              );
            }
          : () async {
              ref.read(widget.imageProvider.notifier).state = null;
            },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // w500Text(
          //   widget.label,
          //   fontSize: 14.sp,
          //   color: CustomColors.formTitleColor,
          // ),
          verticalSpacer(8.sp),
          DottedBorder(
            color: CustomColors.checkBoxBorderColor,
            // strokeWidth: 2,
            dashPattern: const [10, 10],
            borderType: BorderType.RRect,
            radius: const Radius.circular(5),
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadiusDirectional.circular(5),
              child: Container(
                width: double.infinity,
                height: 46,
                decoration: BoxDecoration(
                  color: CustomColors.backBorderColor,
                  border: Border.all(
                      color: CustomColors.dividerGreyColor, width: 0.8),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          ref.watch(widget.imageProvider) == null
                              ? regularText("Upload",
                                  fontSize: 13.sp,
                                  color: CustomColors.greyTextColor)
                              : const Icon(
                                  Icons.image,
                                  color: CustomColors.formHintColor,
                                  size: 20,
                                ),
                          horizontalSpacer(10.w),
                          ref.watch(widget.imageProvider) == null
                              ? Text(
                                  widget.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomTextStyles.w500(
                                      fontSize: 14,
                                      color: CustomColors.backTextColor),
                                )
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Text(
                                      p.basename(
                                        ref.read(widget.imageProvider)?.path ??
                                            "",
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: CustomTextStyles.regular(
                                          fontSize: 15.sp,
                                          color: CustomColors.blackColor),
                                    ),
                                  ),
                                ),
                        ],
                      )),
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: ref.watch(widget.imageProvider) == null
                              ? CustomColors.lightPrimaryBrandColor()
                              : Colors.red.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Center(
                            child: mediumText(
                              ref.watch(widget.imageProvider) == null
                                  ? "Upload"
                                  : "Remove",
                              fontSize: 13.sp,
                              color: ref.watch(widget.imageProvider) == null
                                  ? CustomColors.primaryBrandColor()
                                  : Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          verticalSpacer(5.sp),
          ref.watch(widget.imageProvider) == null && shouldValidate
              ? Text(
                  "Upload ${widget.label.toLowerCase()}",
                  style: CustomTextStyles.regular(
                    fontSize: 12.sp,
                    color: Colors.red,
                  ),
                )
              : Container(),
          verticalSpacer(15),
        ],
      ),
    );
  }
}

Future<File?> selectImage(ImageSource source) async {
  ImagePicker imagePicker = ImagePicker();
  XFile? pickedFile = await imagePicker.pickImage(
      source: source, imageQuality: 50, maxHeight: 612, maxWidth: 816);

  if (pickedFile != null) {
    File file = File(pickedFile.path);
    return file;
  }
  return null;
}

// Future<File?> openGallery() async {
//   ImagePicker imagePicker = ImagePicker();
//   XFile? pickedFile = await imagePicker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: 50,
//       maxHeight: 612,
//       maxWidth: 816);

//   if (pickedFile != null) {
//     File file = File(pickedFile.path);
//     return file;
//   }
//   return null;
// }
