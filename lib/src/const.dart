import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';

const String insight = 'assets/images/insight.png';
const String book = 'assets/images/book.png';
const String checkOut = 'assets/images/check_icon.png';
const String failed = 'assets/images/fail_icon.png';
const String myCover = 'assets/images/my_cover.png';

const String mca = 'assets/images/mca.png';
const String layer = 'assets/images/layer.png';
const String ussd = 'assets/images/ussd.png';
const String transfer = 'assets/images/transfer.png';
const String auto = 'assets/images/auto.png';
const String health = 'assets/images/health.png';
const String gadget = 'assets/images/gadget.png';
const String travel = 'assets/images/travel.png';

const String emptyEmailField = 'Email field cannot be empty!';
const String emptyTextField = 'Field cannot be empty!';
const String invalidEmailField =
    "Email provided isn\'t valid.Try another email address";
const String emailRegex = '[a-zA-Z0-9\+\.\_\%\-\+]{1,256}' +
    '\\@' +
    '[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}' +
    '(' +
    '\\.' +
    '[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}' +
    ')+';

const String phoneNumberRegex = r'0[789][01]\d{8}';

const String phoneNumberLengthError = 'Phone number must be 11 digits';

const String bvnLengthError = 'BVN must be 10 digits';

const String invalidPhoneNumberField =
    "Number provided isn\'t valid.Try another phone number";

double width(BuildContext context) => MediaQuery.of(context).size.width;

//MediaQuery Height
double height(BuildContext context) => MediaQuery.of(context).size.height;


// var htmlStyle = {
//   "ul": Style(padding: const EdgeInsets.all(8)),
//   "li": Style(padding: const EdgeInsets.all(8),
//     listStyleType: ListStyleType.fromWidget(Container(width: 8, height: 8, decoration: const BoxDecoration(color: PRIMARY, shape: BoxShape.circle),)), )
// };