// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/dialogs_and_popups/generic_dialog.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class CustomImagePicker extends StatefulHookConsumerWidget {
  final String fieldName, label, description;
  final bool required;
  const CustomImagePicker({
    super.key,
    required this.fieldName,
    required this.label,
    required this.description,
    required this.required,
  });

  @override
  ConsumerState<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends ConsumerState<CustomImagePicker> {
  @override
  Widget build(BuildContext context) {
    final formErrors = ref.watch(formErrorsProvider);
    final shouldValidate = ref.watch(shouldValidateImageplusDrop);

    return GestureDetector(
      onTap: ref.watch(imagePlaceholderProvider)[widget.fieldName] == null
          ? () async {
              // var selectedImage = await selectImage(ImageSource.camera);
              File? selectedImage;

              await GenericDialog().showSelectImageDialog(
                context: context,
                onCameraPressed: () async {
                  Navigator.pop(context);
                  selectedImage = await selectImage(ImageSource.camera);
                  if (selectedImage != null) {
                    GenericDialog().previewImageDialog(
                      context: context,
                      selectedImage: selectedImage!,
                      onNoPressed: () {
                        selectedImage = null;
                        Navigator.pop(context);
                        return;
                      },
                      onOkPressed: () {
                        Navigator.pop(context);
                        if (selectedImage != null) {
                          ref
                              .read(formErrorsProvider.notifier)
                              .state
                              .remove(widget.fieldName);
                          setState(() {
                            ref
                                    .read(imagePlaceholderProvider.notifier)
                                    .state[widget.fieldName] =
                                selectedImage!.path.toString();

                            Map<String, File?> selectedImagemap = {
                              widget.fieldName: selectedImage,
                            };
                            ref
                                .read(imageListProvider.notifier)
                                .state
                                .add(selectedImagemap);
                          });
                        }
                      },
                    );
                  }
                },
                onGalleryPressed: () async {
                  Navigator.pop(context);
                  selectedImage = await selectImage(ImageSource.gallery);
                  if (selectedImage != null) {
                    ref
                        .read(formErrorsProvider.notifier)
                        .state
                        .remove(widget.fieldName);
                    setState(() {
                      ref
                              .read(imagePlaceholderProvider.notifier)
                              .state[widget.fieldName] =
                          selectedImage!.path.toString();

                      Map<String, File?> selectedImagemap = {
                        widget.fieldName: selectedImage,
                      };
                      ref
                          .read(imageListProvider.notifier)
                          .state
                          .add(selectedImagemap);
                    });
                  }
                },
              );
            }
          : () async {
              if (widget.required == true) {
                ref.read(formErrorsProvider.notifier).state[widget.fieldName] =
                    "This is a required field";
              }
              setState(() {
                ref
                    .read(imagePlaceholderProvider.notifier)
                    .state
                    .remove(widget.fieldName);

                // Get the current state of the image list
                List<Map<String, File?>> currentList =
                    List.from(ref.read(imageListProvider.notifier).state);

                // Find and remove the map entry
                currentList
                    .removeWhere((map) => map.containsKey(widget.fieldName));

                // Update the state
                ref.read(imageListProvider.notifier).state = currentList;
              });
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
                          child:
                              // ref.watch(imagePlaceholderProvider)[
                              //             widget.fieldName] ==
                              //         null
                              //     ?
                              Row(
                        children: [
                          ref.watch(imagePlaceholderProvider)[
                                      widget.fieldName] ==
                                  null
                              ? regularText("Upload",
                                  fontSize: 13.sp,
                                  color: CustomColors.greyTextColor)
                              : const Icon(
                                  Icons.image,
                                  color: CustomColors.formHintColor,
                                  size: 20,
                                ),
                          horizontalSpacer(10.w),
                          ref.watch(imagePlaceholderProvider)[
                                      widget.fieldName] ==
                                  null
                              ? Text(
                                  widget.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomTextStyles.w500(
                                      fontSize: 15.sp,
                                      color: CustomColors.backTextColor),
                                )
                              : Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Text(
                                      ref
                                          .watch(imagePlaceholderProvider)[
                                              widget.fieldName]
                                          .toString(),
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
                          color: ref.watch(imagePlaceholderProvider)[
                                      widget.fieldName] ==
                                  null
                              ? CustomColors.lightPrimaryBrandColor()
                              : Colors.red.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Center(
                            child: mediumText(
                              ref.watch(imagePlaceholderProvider)[
                                          widget.fieldName] ==
                                      null
                                  ? "Upload"
                                  : "Remove",
                              fontSize: 14.sp,
                              color: ref.watch(imagePlaceholderProvider)[
                                          widget.fieldName] ==
                                      null
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
          formErrors.containsKey(widget.fieldName) && shouldValidate
              ? Text(
                  formErrors[widget.fieldName],
                  style: CustomTextStyles.regular(
                    fontSize: 12.sp,
                    color: Colors.red,
                  ),
                )
              : Container(),
          verticalSpacer(25.sp),
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
