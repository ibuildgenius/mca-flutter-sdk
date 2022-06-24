import 'dart:developer';

import 'package:flutter/material.dart';

import '../../mca_flutter_sdk.dart';
import '../const.dart';
import '../theme.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';

class Failed extends StatelessWidget {
  const Failed({Key? key})
      : super(key: key);




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: RED.withOpacity(0.2)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.close, color: RED, size: 15),
                      )),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              Card(
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
                                    decoration: BoxDecoration(
                                        color: FILL_RED.withOpacity(0.5),
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(22.0),
                                      child: Image.asset(failed,
                                          height: 30,
                                          width: 30,
                                          package: 'mca_flutter_sdk'),
                                    ))),
                            verticalSpace(),
                            const Center(
                              child: Text(
                                'Failed to Initialise',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 21),
                              ),
                            ),
                            verticalSpace(),
                            const Text(
                                'Your purchase has failed to initialise,\nRetry so you can continue',
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
            ],
          ),
        ),
      ),
    );
  }
}
