import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../const.dart';
import '../theme.dart';
import 'buttons.dart';
import 'common.dart';

class Dialogs {
  static showErrorMessage(message) {
    return Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 13.0);
  }

  static Future<void> showLoading({context, text}) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            contentPadding: const EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
            content: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 15, 20),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 15.0,
                                      top: 20),
                                  child: Center(
                                      child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  ))),
                              Container(
                                height: 10,
                              ),
                              Text(text ?? 'Please wait...',
                                  style: const TextStyle(color: Colors.black))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static Future<void> successDialog({context, productName}) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            contentPadding: const EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
            content: Card(
              color: WHITE,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                width: double.maxFinite,
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          verticalSpace(),
                          Center(
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: FILL_GREEN,
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(checkOut,
                                        height: 55,
                                        width: 55,
                                        package: 'my_cover_sdk'),
                                  ))),
                          verticalSpace(),
                          const Center(
                            child: Text(
                              'Purchase Successful',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 21),
                            ),
                          ),
                          verticalSpace(),
                          Text(
                              'You have just purchased \n$productName,\nKindly Check your email\nto complete your activation',
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14)),
                          verticalSpace(),
                          Padding(
                            padding: const EdgeInsets.all(35.0),
                            child: successButton(
                                text: 'Done',
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }),
                          ),
                          smallVerticalSpace(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<void> confirmClose(context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            contentPadding: const EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
            content: Card(
              color: WHITE,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                width: double.maxFinite,
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          verticalSpace(),
                          Center(
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: FILL_RED, shape: BoxShape.circle),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.cancel,
                                        color: RED, size: 45),
                                  ))),
                          verticalSpace(),
                          const Center(
                            child: Text('Quit Process',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 21)),
                          ),
                          verticalSpace(),
                          const Text(
                              'You are about to quit this process,do you want to proceed with this action?',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14)),
                          verticalSpace(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 35, 10, 35),
                            child: Row(
                              children: [
                                Expanded(
                                    child: InkWell(
                                        onTap: () => Navigator.pop(context),
                                        child: const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text('Cancel',style: TextStyle(fontWeight: FontWeight.w600),),
                                          ),
                                        ))),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: closeButton(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }),
                                ),
                              ],
                            ),
                          ),
                          smallVerticalSpace(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<void> failedDialog({context}) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 0,
            contentPadding: const EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
            content: Card(
              color: WHITE,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                width: double.maxFinite,
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          verticalSpace(),
                          Center(
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: FILL_RED, shape: BoxShape.circle),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(failed,
                                        height: 55,
                                        width: 55,
                                        package: 'my_cover_sdk'),
                                  ))),
                          verticalSpace(),
                          const Center(
                            child: Text(
                              'Purchase Unsuccessful',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 21),
                            ),
                          ),
                          verticalSpace(),
                          const Text(
                              'Your Payment is Unsuccessfully,\nRetry so you can continue',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14)),
                          verticalSpace(),
                          Padding(
                            padding: const EdgeInsets.all(35.0),
                            child: successButton(
                                text: 'Retry',
                                onTap: () {
                                  Navigator.pop(context);
                                }),
                          ),
                          smallVerticalSpace(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
