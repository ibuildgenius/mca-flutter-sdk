import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/services/services.dart';

import '../const.dart';
import '../theme.dart';
import '../widgets/body_scaffold.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/dialogs.dart';
import 'auto.dart';
import 'form.dart';
import 'gadget.dart';
import 'health.dart';
import 'travel.dart';

enum BodyType { introPage, detail, success }

enum PaymentOption { wallet, gateway }

enum PurchaseStage { payment, purchase }

class MyCover extends StatefulWidget {
  const MyCover(
      {Key? key,
      required this.productData,
      required this.productId,
      required this.email,
      required this.publicKey,
      required this.reference,
      required this.paymentOption,
      required this.form})
      : super(key: key);
  final List? productId;
  final String publicKey;
  final String email;
  final PaymentOption? paymentOption;
  final String? reference;
  final productData;
  final form;

  @override
  State<MyCover> createState() => _MyCoverState();
}

class _MyCoverState extends State<MyCover> with AfterLayoutMixin<MyCover> {
  var productDetail;
  String productName = '';
  String provider = '';
  String businessName = '';
  String businessId = '';

  String productId = '';
  String logo = '';
  String instanceId = '';
  BodyType bodyType = BodyType.introPage;
  bool inspectable = false;

  String productCat = 'health';

  @override
  void initState() {
    getProductCat();
    fetchProductDetail();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getProductCat() async {
    var response = await WebServices.getProductCategory(
        widget.productData['data']['productDetails'][0]['product_category_id'],
        widget.publicKey);

    log("category response $response");

    if (response is Map &&
        (response["responseText"] as String)
            .contains("Product category fetched successfully")) {
      productCat = response["data"]["product_category"]["name"];
    }
  }

  Future fetchProductDetail() async {
    setState(() {
      productDetail = widget.productData;

      productName = productDetail['data']['productDetails'][0]['name'] ?? '';
      inspectable =
          productDetail['data']['productDetails'][0]['inspectable'] ?? false;
      provider = productDetail['data']['productDetails'][0]['prefix'] ?? '';

      businessName =
          productDetail['data']['businessDetails']['trading_name'] ?? '';
      logo = productDetail['data']['businessDetails']['logo'] ?? '';
      instanceId =
          productDetail['data']['businessDetails']['instance_id'] ?? '';
      businessId = productDetail['data']['businessDetails']['id'] ?? '';
      productId = productDetail['data']['productDetails'][0]['id'] ?? '';
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: selectBody(bodyType),
        ),
      ),
    );
  }

  selectBody(BodyType bodyType) {
    switch (bodyType) {
      case BodyType.introPage:
        return introBodyScreen();
      case BodyType.detail:
        return FormScreen(
          productDetail: widget.productData,
          publicKey: widget.publicKey,
          paymentOption: widget.paymentOption,
          reference: widget.reference,
          instanceId: instanceId,
          form: widget.form,
          provider: provider,
          inspectable: inspectable,
          email: widget.email,
        );
      case BodyType.success:
        return successScreen();
    }
  }

  Widget introBodyScreen() {
    return BodyScaffold(
      logo: logo,
      text: 'Get Covered',
      buttonAction: () {
        setState(() => bodyType = BodyType.detail);
      },
      backAction: () {
        bodyType == BodyType.introPage
            ? Dialogs.confirmClose(context)
            : setState(() => bodyType = BodyType.introPage);
      },
      body: openIntro(productCat),
    );

    /* Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // selectBody(bodyType),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      bodyType == BodyType.introPage
                          ? Dialogs.confirmClose(context)
                          : setState(() => bodyType = BodyType.introPage);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: WHITE.withOpacity(0.7)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child:
                          Icon(Icons.arrow_back, color: BLACK, size: 15),
                        )),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logo == ''
                    ? Image.asset(mca,
                    height: 30, package: 'mca_official_flutter_sdk')
                    : Image.network(
                  logo,
                  height: 30,
                ),
              ],
            ),
            const SizedBox(height: 10),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration:
                  BoxDecoration(color: WHITE, borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        verticalSpace(),

                        openIntro(productCategory),
                        smallVerticalSpace(),
                        const Divider(),
                        button(
                            text: 'Get Covered',
                            onTap: () => setState(() => bodyType = BodyType.detail)),
                        smallVerticalSpace(),
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

    ); */
  }

  openIntro(String productType) {
    if (productType.contains('auto') ||
        productType.toLowerCase().contains('life')) {
      return const AutoScreen();
    } else if (productType.contains('health') ||
        productType.contains('hospital')) {
      return const HealthScreen();
    } else if (productType.contains('travel')) {
      return const TravelScreen();
    } else if (productType.contains('gadget') ||
        productType.contains('home') ||
        productType.contains('content')) {
      return const GadgetScreen();
    } else {
      Navigator.pop(context);
    }
  }

  successScreen() {
    return Center(
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
                          color: FILL_GREEN, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(checkOut,
                            height: 55, width: 55, package: 'mca_official_flutter_sdk'),
                      ))),
              verticalSpace(),
              const Center(
                child: Text(
                  'Purchase Successful',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                ),
              ),
              verticalSpace(),
              const Text(
                  'You have just purchase Auto\nProduct, Kindly Check your email\nto complete your activation',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16)),
              verticalSpace(),
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: successButton(
                    text: 'Done',
                    onTap: () => setState(() => bodyType = BodyType.introPage)),
              ),
              smallVerticalSpace(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    //getProductCat();
  }
}
