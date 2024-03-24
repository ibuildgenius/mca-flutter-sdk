import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mca_official_flutter_sdk/src/utils/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/utils/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';

import '../const.dart';
import '../theme.dart';
import 'buttons.dart';
import 'common.dart';
import 'dialogs.dart';

class BodyScaffold extends StatelessWidget {
  const BodyScaffold(
      {Key? key,
      this.backAction,
      this.text,
      this.buttonAction,
      this.logo,
      required this.body})
      : super(key: key);
  final logo, backAction, buttonAction, text;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: backAction,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: Center(
                            child: SvgPicture.asset(
                              ConstantString.backIcon,
                              height: 15,
                              width: 15,
                              package: 'mca_official_flutter_sdk',
                            ),
                          ),
                        ),
                      ),

                      // Container(
                      //     decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: WHITE.withOpacity(0.7)),
                      //     child: const Padding(
                      //       padding: EdgeInsets.all(8.0),
                      //       child: Icon(Icons.arrow_back,
                      //           color: CustomColors.greenColor, size: 15),
                      //     )),
                    ),
                  ],
                ),
                logo == ''
                    ? Image.asset(ConstantString.myCoverLogo,
                        height: 30, package: 'mca_official_flutter_sdk')
                    : Image.network(
                        logo,
                        height: 30,
                      ),
                InkWell(
                  onTap: () => Dialogs.confirmClose(context),
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: RED.withOpacity(0.2)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.close, color: RED, size: 15),
                      )),
                ),
              ],
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     logo == ''
          //         ? Image.asset(mca,
          //             height: 30, package: 'mca_official_flutter_sdk')
          //         : Image.network(
          //             logo,
          //             height: 30,
          //           ),
          //   ],
          // ),
          // const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                // decoration: BoxDecoration(
                //     color: WHITE, borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      verticalSpace(),
                      body,
                      smallVerticalSpace(),
                      // const Divider(),
                      button(text: text ?? 'Get Covered', onTap: buttonAction),
                      verticalSpacer(5),
                      Image.asset(myCover,
                          width: 160,
                          fit: BoxFit.fitWidth,
                          package: 'mca_official_flutter_sdk'),
                      // smallVerticalSpace(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // const SizedBox(height: 10),
          verticalSpacer(10),
        ],
      ),
    );
  }
}

class FormBodyScaffold extends StatelessWidget {
  const FormBodyScaffold(
      {Key? key,
      this.backAction,
      this.text,
      this.buttonAction,
      this.logo,
      required this.body})
      : super(key: key);
  final logo, backAction, buttonAction, text;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom -
              40,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: backAction,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: Center(
                            child: SvgPicture.asset(
                              ConstantString.backIcon,
                              height: 15,
                              width: 15,
                              package: 'mca_official_flutter_sdk',
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //     decoration: BoxDecoration(
                      //         shape: BoxShape.circle,
                      //         color: WHITE.withOpacity(0.7)),
                      //     child: const Padding(
                      //       padding: EdgeInsets.all(8.0),
                      //       child: Icon(Icons.arrow_back, color: BLACK, size: 15),
                      //     )),
                    ),
                    logo == ''
                        ? Image.asset(ConstantString.myCoverLogo,
                            height: 30, package: 'mca_official_flutter_sdk')
                        : Image.network(
                            logo,
                            height: 30,
                          ),
                    InkWell(
                      onTap: () => Dialogs.confirmClose(context),
                      child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: RED.withOpacity(0.2)),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.close, color: RED, size: 15),
                          )),
                    ),
                  ],
                ),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     logo == ''
              //         ? Image.asset(mca,
              //             height: 30, package: 'mca_official_flutter_sdk')
              //         : Image.network(
              //             logo,
              //             height: 30,
              //           ),
              //   ],
              // ),
              // const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: WHITE, borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          verticalSpace(),
                          body,
                          smallVerticalSpace(),
                          // const Divider(),
                          button(
                              text: text ?? 'Get Covered', onTap: buttonAction),
                          verticalSpacer(5),
                          Image.asset(myCover,
                              width: 160,
                              fit: BoxFit.fitWidth,
                              package: 'mca_official_flutter_sdk'),
                          smallVerticalSpace(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              verticalSpace(),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentBodyScaffold extends StatelessWidget {
  const PaymentBodyScaffold(
      {Key? key,
      this.backAction,
      this.text,
      this.buttonAction,
      this.logo,
      required this.body})
      : super(key: key);
  final logo, backAction, buttonAction, text;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: backAction,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Center(
                        child: SvgPicture.asset(
                          ConstantString.backIcon,
                          height: 15,
                          width: 15,
                          package: 'mca_official_flutter_sdk',
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //     decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: WHITE.withOpacity(0.7)),
                  //     child: const Padding(
                  //       padding: EdgeInsets.all(8.0),
                  //       child: Icon(Icons.arrow_back, color: BLACK, size: 15),
                  //     )),
                ),
                logo == ''
                    ? Image.asset(ConstantString.myCoverLogo,
                        height: 30, package: 'mca_official_flutter_sdk')
                    : Image.network(
                        logo,
                        height: 30,
                      ),
                InkWell(
                  onTap: () => Dialogs.confirmClose(context),
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: RED.withOpacity(0.2)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.close, color: RED, size: 15),
                      )),
                ),
              ],
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     logo == ''
          //         ? Image.asset(mca,
          //             height: 30, package: 'mca_official_flutter_sdk')
          //         : Image.network(
          //             logo,
          //             height: 30,
          //           ),
          //   ],
          // ),
          // const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                    color: WHITE, borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      verticalSpace(),
                      body,
                      smallVerticalSpace(),
                      // const Divider(),
                      button(text: text ?? 'Get Covered', onTap: buttonAction),
                      verticalSpacer(5),
                      Image.asset(myCover,
                          width: 160,
                          fit: BoxFit.fitWidth,
                          package: 'mca_official_flutter_sdk'),
                      smallVerticalSpace(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          verticalSpace(),
        ],
      ),
    );
  }
}
