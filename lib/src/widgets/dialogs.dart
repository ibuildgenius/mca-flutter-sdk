import 'package:flutter/material.dart';

import '../const.dart';
import '../theme.dart';
import 'buttons.dart';
import 'common.dart';

class Dialogs {
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Wrap(
                children: <Widget>[
                  Center(
                    child: Container(
                      color: WHITE,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                    fontWeight: FontWeight.w700, fontSize: 22),
                              ),
                            ),
                            verticalSpace(),
                             Text(
                                'You have just purchase $productName, \nKindly Check your email\nto complete your activation',
                                textAlign: TextAlign.center,
                                style:const TextStyle(fontSize: 16)),
                            verticalSpace(),
                            Padding(
                              padding: const EdgeInsets.all(35.0),
                              child: successButton(
                                  text: 'Done',
                                  onTap: () {
                                    Navigator.pop(context);
                                  }),
                            ),
                            smallVerticalSpace(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
