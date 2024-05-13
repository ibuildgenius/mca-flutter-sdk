import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

Text textBoxTitle(text) => Text('$text',
    style: GoogleFonts.spaceGrotesk(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: DARK,
    ));

class InputFormField extends StatelessWidget {
  const InputFormField({
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: inputFormatters,
        enabled: enabled,
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 14,
          color: DARK,
          fontFamily: 'Space',
        ),
        textCapitalization: textCapitalization,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscure,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          filled: true,
          fillColor: LIGHT_GREY,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: GREY.withOpacity(0.6), width: 0.3),
              borderRadius: const BorderRadius.all(Radius.circular(4))),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: GREY.withOpacity(0.6), width: 0.3),
              borderRadius: const BorderRadius.all(Radius.circular(4))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: GREY.withOpacity(0.7), width: 0.3),
              borderRadius: const BorderRadius.all(Radius.circular(4))),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.redAccent, width: 0.3),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: GREY.withOpacity(0.6), width: 0.3),
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            fontSize: 13,
            color: GREY.withOpacity(0.4),
            fontFamily: 'Space',
          ),
          hintStyle: TextStyle(
            fontSize: 13,
            color: GREY.withOpacity(0.4),
            fontFamily: 'Space',
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: padding ?? 15.0, horizontal: 15.0),
        ),
      ),
    );
  }
}
