import 'package:flutter/material.dart';

import '../theme.dart';


SizedBox smallVerticalSpace() => const SizedBox(height: 10);

SizedBox verticalSpace({double height=20.0}) =>  SizedBox(height: height);

Widget getProductName(name) {

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text('Underwritten by:', style: TextStyle(fontWeight: FontWeight.w600),),
      const SizedBox(width: 10,),
      getLogo(name)
    ],
  );
}

Widget getLogo(String name) {
  var newName = name.toLowerCase();


  if (newName.contains("mcg") || newName.contains("mycovergenius")) {
    return Image.asset("assets/images/mcg.png", package: 'mca_official_flutter_sdk');
  }else if (newName.contains("aiico") ) {
    return Image.asset("assets/images/aiico.png", package: 'mca_official_flutter_sdk');
  } else if (newName.contains("sti") ) {
    return Image.asset("assets/images/sti.png", package: 'mca_official_flutter_sdk');
  } else if (newName.contains("flexicare")) {
    return Image.asset("assets/images/flexicare.png", package: 'mca_official_flutter_sdk');
  } else if (newName.contains("leadway")) {
    return Image.asset("assets/images/leadway.png", package: 'mca_official_flutter_sdk');
  } else {
    return Text(
       name,
      style: const TextStyle(fontWeight: FontWeight.w600),
    );
  }

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


Widget textTile(text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
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
    ),
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