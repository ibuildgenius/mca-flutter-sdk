import 'package:flutter/material.dart';

import '../theme.dart';


SizedBox smallVerticalSpace() => const SizedBox(height: 10);

SizedBox verticalSpace() => const SizedBox(height: 20);

RichText getProductName(name) {
  return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w400, color: DARK),
          children: [
            const TextSpan(text: 'Underwritten by:  '),
            TextSpan(
              text: name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ]));
}

 selectDate(BuildContext context) async {
  return await showDatePicker(
    context: context,
    helpText: 'Select your Date of Birth',
    initialDate: DateTime.now(),
    firstDate: DateTime(DateTime.now().year - 80),
    lastDate: DateTime.now(),
  );
}


Row textTile(text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(width: 10),
      const Padding(
        padding: EdgeInsets.all(5.0),
        child: Icon(Icons.circle, color: PRIMARY, size: 10),
      ),
      const SizedBox(width: 15),
      Expanded(
          child: Text(
            text,
            textAlign: TextAlign.start,
          ))
    ],
  );
}

Padding tabDeco(BuildContext context, title, selectedTabIndex, index) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Center(
      child: Text(title,
          style: TextStyle(
              fontSize: 11,
              fontWeight:
              selectedTabIndex == index ? FontWeight.w600 : FontWeight.w400,
              color: selectedTabIndex == index ? PRIMARY : BLACK)),
    ),
  );
}