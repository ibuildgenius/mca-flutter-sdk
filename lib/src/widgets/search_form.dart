import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mca_official_flutter_sdk/src/utils/constants/custom_colors.dart';

import '../theme.dart';

// Text textBoxTitle(text) => Text(' $text',
//     style: const TextStyle(
//       fontSize: 13,
//       fontWeight: FontWeight.w500,
//       color: DARK,
//       fontFamily: 'Space',
//     ));

class SearchFormField extends StatelessWidget {
  const SearchFormField({
    Key? key,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.obscure = false,
    this.onChanged,
    this.enabled = true,
    this.controller,
    this.label,
    this.hint,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.padding,
    this.keyboardType,
    this.maxLength,
    this.inputFormatters,
  }) : super(key: key);

  final suffixIcon;
  final prefixIcon;
  final onChanged;
  final validator;
  final enabled;
  final controller;
  final obscure;
  final label;
  final hint;
  final padding;
  final textCapitalization;
  final keyboardType;
  final inputFormatters;
  final maxLines;
  final maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 12),
      child: TextFormField(
        buildCounter: (context,
                {required currentLength, required isFocused, maxLength}) =>
            null,
        inputFormatters: inputFormatters,
        enabled: enabled,
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          color: DARK,
        ),
        textCapitalization: textCapitalization,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscure,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          filled: true,
          fillColor: CustomColors.whiteColor,
          border: InputBorder.none,
          enabledBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: CustomColors.searchBorderColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(25))),
          disabledBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: CustomColors.searchBorderColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(25))),
          focusedBorder: const OutlineInputBorder(
              borderSide:
                  BorderSide(color: CustomColors.deepBlueTextColor, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(25))),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: GREY.withOpacity(0.6), width: 1),
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.spaceGrotesk(
              fontSize: 13, color: CustomColors.hintTextColor),
          hintStyle: GoogleFonts.spaceGrotesk(
              fontSize: 13, color: CustomColors.hintTextColor),
          contentPadding:
              EdgeInsets.symmetric(vertical: padding ?? 15.0, horizontal: 15.0),
        ),
      ),
    );
  }
}
