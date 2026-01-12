import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mca_official_flutter_sdk/src/utils/custom_text_styles.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/utils/thousands_seperator.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

import '../constants/custom_colors.dart';

// Widget customTextField(String name,
//     {String? hintText,
//     String? labelText,
//     IconData? prefixIcon,
//     IconData? suffixIcon,
//     Widget? prefix,
//     String? initialValue,
//     bool isHint = false,
//     bool obscureText = false,
//     bool readOnly = false,
//     String? helperText,
//     String? Function(String?)? validator,
//     TextEditingController? controller,
//     void Function()? onSuffixTap,
//     void Function(String?)? onChanged}) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       SizedBox(
//         // height: 50,
//         child: FormBuilderTextField(
//           initialValue: initialValue,
//           cursorColor: CustomColors.primaryBrandColor().withOpacity(0.4),
//           name: name,
//           obscureText: obscureText,
//           validator: validator,
//           readOnly: readOnly,
//           onChanged: onChanged,
//           controller: controller,
//           decoration: InputDecoration(
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
//             enabledBorder: const OutlineInputBorder(
//               borderSide:
//                   BorderSide(color: CustomColors.dividerGreyColor, width: 0.8),
//               borderRadius: BorderRadius.all(
//                 Radius.circular(5),
//               ),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(
//                 color: CustomColors.primaryBrandColor().withOpacity(0.3),
//               ),
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(5),
//               ),
//             ),
//             focusedErrorBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.red.withOpacity(0.7)),
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(5),
//               ),
//             ),
//             errorBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.red.withOpacity(0.7)),
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(5),
//               ),
//             ),
//             suffixIcon: suffixIcon == null
//                 ? null
//                 : GestureDetector(
//                     onTap: onSuffixTap,
//                     child: Icon(
//                       suffixIcon,
//                       size: 16,
//                       color: CustomColors.blackColor,
//                     ),
//                   ),
//             prefixIcon: prefixIcon != null
//                 ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         prefixIcon,
//                         size: 16,
//                         color: CustomColors.blackColor,
//                       ),
//                     ],
//                   )
//                 : prefix,
//             fillColor: CustomColors.backBorderColor,
//             filled: true,
//             hintText: hintText,
//             labelText: labelText,
//             floatingLabelBehavior: FloatingLabelBehavior.auto,
//             floatingLabelStyle: CustomTextStyles.regular(
//                 fontSize: 12.sp, color: CustomColors.primaryBrandColor()),
//             labelStyle: CustomTextStyles.regular(
//                 fontSize: 14.sp, color: CustomColors.checkBoxBorderColor),
//             errorStyle: const TextStyle(
//               color: Colors.red,
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//             hintStyle: CustomTextStyles.regular(
//                 fontSize: 14, color: CustomColors.checkBoxBorderColor),
//           ),
//         ),
//       ),
//     ],
//   );
// }

Widget customTextField(String name,
    {String? hintText,
    String? labelText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Widget? prefix,
    String? initialValue,
    bool isCurrency = false,
    bool isNumber = false,
    bool isHint = false,
    bool obscureText = false,
    bool readOnly = false,
    String? helperText,
    String? Function(String?)? validator,
    TextEditingController? controller,
    void Function()? onSuffixTap,
    void Function(String?)? onChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        // height: 50,
        child: FormBuilderTextField(
          initialValue: initialValue,
          cursorColor: CustomColors.blackColor.withOpacity(0.5),
          name: name,
          obscureText: obscureText,
          validator: validator,
          readOnly: readOnly,
          onChanged: onChanged,
          controller: controller,
          style: CustomTextStyles.regular(
              fontSize: 14.sp, color: CustomColors.blackColor),
          inputFormatters: isNumber
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]'),
                  ),
                  if (isCurrency) ThousandsSeparatorInputFormatter(),
                ]
              : null,
          keyboardType: isNumber ? TextInputType.phone : null,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            enabledBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: CustomColors.dividerGreyColor, width: 0.8),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColors.primaryBrandColor().withOpacity(0.4),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.withOpacity(0.7)),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.withOpacity(0.7)),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            suffixIcon: suffixIcon == null
                ? null
                : GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(
                      suffixIcon,
                      size: 16,
                      color: CustomColors.blackColor,
                    ),
                  ),
            prefixIcon: prefixIcon != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        prefixIcon,
                        size: 16,
                        color: CustomColors.blackColor,
                      ),
                    ],
                  )
                : prefix,
            fillColor: CustomColors.backBorderColor,
            filled: true,
            hintText: hintText,
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: CustomTextStyles.regular(
                fontSize: 12.sp, color: CustomColors.primaryBrandColor()),
            labelStyle: CustomTextStyles.regular(
                fontSize: 14.sp, color: CustomColors.checkBoxBorderColor),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            hintStyle: CustomTextStyles.regular(
                fontSize: 14.sp, color: CustomColors.checkBoxBorderColor),
          ),
        ),
      ),
    ],
  );
}

Widget customFormTextField(String name,
    {required String? title,
    String? hintText,
    String? labelText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Widget? prefix,
    String? initialValue,
    bool isCurrency = false,
    bool isNumber = false,
    bool isHint = false,
    bool obscureText = false,
    bool readOnly = false,
    int? maxLines,
    int? maxLength,
    Widget? suffix,
    bool enabled = true,
    String? helperText,
    String? Function(String?)? validator,
    TextEditingController? controller,
    AutovalidateMode? autovalidateMode,
    void Function()? onSuffixTap,
    void Function()? onTap,
    void Function(String?)? onChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title == null
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: mediumText(
                title,
                fontSize: 14.sp,
                color: CustomColors.formTitleColor,
              ),
            ),
      // verticalSpacer(8.sp),
      SizedBox(
        // height: 50,
        child: FormBuilderTextField(
          enabled: enabled,
          initialValue: initialValue,
          cursorColor: CustomColors.blackColor.withOpacity(0.5),
          name: name,

          // enabled: enabled,
          maxLength: maxLength,
          key: ValueKey(name),
          autovalidateMode: autovalidateMode,
          obscureText: obscureText,
          onTap: onTap,
          validator: validator,
          readOnly: readOnly,
          maxLines: maxLines,
          onChanged: onChanged,
          controller: controller,
          style: CustomTextStyles.regular(
              fontSize: 15.sp, color: CustomColors.blackColor),
          inputFormatters: isNumber
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]'),
                  ),
                  if (isCurrency) ThousandsSeparatorInputFormatter(),
                ]
              : null,
          keyboardType: isNumber ? TextInputType.phone : null,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            enabledBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: CustomColors.dividerGreyColor, width: 0.8),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColors.primaryBrandColor().withOpacity(0.4),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.withOpacity(0.7)),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.withOpacity(0.7)),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            suffixIcon: suffix ??
                (suffixIcon == null
                    ? null
                    : GestureDetector(
                        onTap: onSuffixTap,
                        child: Icon(
                          suffixIcon,
                          size: 16,
                          color: CustomColors.blackColor,
                        ),
                      )),
            prefixIcon: isCurrency
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '₦',
                        style: TextStyle(
                          fontFamily: "",
                          package: 'mca_official_flutter_sdk',
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          color: CustomColors.greyTextColor,
                        ),
                      )
                    ],
                  )
                : prefixIcon != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            prefixIcon,
                            size: 16,
                            color: CustomColors.blackColor,
                          ),
                        ],
                      )
                    : prefix,
            fillColor: CustomColors.backBorderColor,
            filled: true,
            hintText: hintText,
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: CustomTextStyles.regular(
                fontSize: 12.sp, color: CustomColors.primaryBrandColor()),
            labelStyle: CustomTextStyles.regular(
                fontSize: 14.sp, color: CustomColors.checkBoxBorderColor),
            errorStyle: CustomTextStyles.regular(
              fontSize: 12.sp,
              color: Colors.red,
            ),
            hintStyle: CustomTextStyles.regular(
                fontSize: 14.sp, color: CustomColors.formHintColor),
          ),
        ),
      ),
      verticalSpacer(25.sp),
    ],
  );
}

Widget customFilterTextField(String name,
    {String? hintText,
    String? labelText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Widget? prefix,
    String? initialValue,
    bool isCurrency = false,
    bool isNumber = false,
    bool isHint = false,
    bool obscureText = false,
    bool readOnly = false,
    String? helperText,
    String? Function(String?)? validator,
    TextEditingController? controller,
    void Function()? onSuffixTap,
    void Function(String?)? onChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        // height: 50,
        child: FormBuilderTextField(
          initialValue: initialValue,
          cursorColor: CustomColors.blackColor.withOpacity(0.5),
          name: name,
          obscureText: obscureText,
          validator: validator,
          readOnly: readOnly,
          onChanged: onChanged,
          controller: controller,
          style: CustomTextStyles.regular(
              fontSize: 14.sp, color: CustomColors.blackColor),
          inputFormatters: isNumber
              ? <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]'),
                  ),
                  if (isCurrency) ThousandsSeparatorInputFormatter(),
                ]
              : null,
          keyboardType: isNumber ? TextInputType.phone : null,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            enabledBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: CustomColors.dividerGreyColor, width: 0.8),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColors.primaryBrandColor().withOpacity(0.4),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.withOpacity(0.7)),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.withOpacity(0.7)),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            suffixIcon: suffixIcon == null
                ? null
                : GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(
                      suffixIcon,
                      size: 16,
                      color: CustomColors.blackColor,
                    ),
                  ),
            prefixIcon: prefixIcon != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        prefixIcon,
                        size: 16,
                        color: CustomColors.blackColor,
                      ),
                    ],
                  )
                : prefix,
            fillColor: CustomColors.backBorderColor,
            filled: true,
            hintText: hintText,
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: CustomTextStyles.regular(
                fontSize: 12.sp, color: CustomColors.primaryBrandColor()),
            labelStyle: CustomTextStyles.regular(
                fontSize: 14.sp, color: CustomColors.checkBoxBorderColor),
            errorStyle: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            hintStyle: CustomTextStyles.regular(
                fontSize: 14.sp, color: CustomColors.checkBoxBorderColor),
          ),
        ),
      ),
    ],
  );
}

// Widget customMultiTextField(String name,
//     {String? hintText,
//     IconData? prefixIcon,
//     IconData? suffixIcon,
//     Widget? prefix,
//     String? initialValue,
//     double height = 120,
//     bool isHint = false,
//     bool obscureText = false,
//     bool readOnly = false,
//     String? helperText,
//     String? Function(String?)? validator,
//     TextEditingController? controller,
//     void Function()? onSuffixTap,
//     void Function(String?)? onChanged}) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       SizedBox(
//         height: height,
//         child: FormBuilderTextField(
//           initialValue: initialValue,
//           cursorColor: CustomColors.orangeColor.withOpacity(0.4),
//           name: name,
//           obscureText: obscureText,
//           validator: validator,
//           readOnly: readOnly,
//           maxLines: 20,
//           onChanged: onChanged,
//           controller: controller,
//           decoration: InputDecoration(
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
//             enabledBorder: const OutlineInputBorder(
//               borderSide: BorderSide(color: CustomColors.lightGreyColor),
//             ),
//             focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(
//                     color: CustomColors.mainBlueColor.withOpacity(0.3))),
//             focusedErrorBorder: const OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.red)),
//             suffixIcon: GestureDetector(
//               onTap: onSuffixTap,
//               child: Icon(
//                 suffixIcon,
//                 size: 16,
//                 color: CustomColors.blackColor,
//               ),
//             ),
//             prefixIcon: prefixIcon != null
//                 ? Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         prefixIcon,
//                         size: 16,
//                         color: CustomColors.blackColor,
//                       ),
//                     ],
//                   )
//                 : prefix,
//             fillColor: CustomColors.textFieldColor,
//             // filled: true,
//             hintText: hintText,
//             hintStyle: const TextStyle(
//                 color: CustomColors.hintTextColor,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500),
//           ),
//         ),
//       ),
//     ],
//   );
// }

Widget searchCustomTextField(String name,
    {String? hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    Widget? prefix,
    Widget? suffix,
    String? initialValue,
    bool isHint = false,
    bool obscureText = false,
    bool readOnly = false,
    String? helperText,
    String? Function(String?)? validator,
    TextEditingController? controller,
    void Function()? onSuffixTap,
    void Function(String?)? onChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        height: 50,
        child: FormBuilderTextField(
          initialValue: initialValue,
          cursorColor: CustomColors.primaryBrandColor().withOpacity(0.4),
          name: name,
          obscureText: obscureText,
          validator: validator,
          readOnly: readOnly,
          onChanged: onChanged,
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(
              left: 20,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: CustomColors.whiteColor.withOpacity(0.8)),
              borderRadius: BorderRadius.circular(25),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: CustomColors.whiteColor.withOpacity(0.8)),
              borderRadius: BorderRadius.circular(25),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
            ),
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(
                      suffixIcon,
                      size: 16,
                      color: CustomColors.blackColor,
                    ),
                  )
                : suffix,
            prefixIcon: prefixIcon != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        prefixIcon,
                        size: 16,
                        color: CustomColors.blackColor,
                      ),
                    ],
                  )
                : prefix,
            // fillColor: CustomColors.lightGreyColor.withOpacity(0.4),
            filled: true,
            hintText: hintText,
            hintStyle: const TextStyle(
                color: CustomColors.greyTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    ],
  );
}
