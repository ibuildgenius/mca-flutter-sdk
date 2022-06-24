import 'package:flutter/material.dart';

import '../const.dart';
import '../theme.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import 'auto.dart';
import 'form.dart';
import 'gadget.dart';
import 'health.dart';
import 'travel.dart';

enum BodyType { introPage, detail, success }

class MyCover extends StatefulWidget {
  const MyCover(
      {Key? key,
      required this.productData,
      required this.productId,
      required this.email,
      this.accentColor = PRIMARY,
      this.primaryColor = FILL_GREEN,
      required this.userId})
      : super(key: key);
  final String productId;
  final String userId;
  final String email;
  final productData;
  final primaryColor;
  final accentColor;

  @override
  State<MyCover> createState() => _MyCoverState();
}

class _MyCoverState extends State<MyCover> {
  var productDetail;
  String productName = '';
  String businessName = '';
  String businessId = '';
  String productCategory = '';
  String productId = '';
  String logo = '';
  BodyType bodyType = BodyType.introPage;

  @override
  void initState() {
    fetchProductDetail();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  fetchProductDetail() async {
    setState(() {
      productDetail = widget.productData;

      productName = productDetail['data']['productDetails'][0]['name'] ?? '';
      productCategory = productDetail['data']['productDetails'][0]
              ['productCategory']['name']
          .toString()
          .toLowerCase();

      businessName =
          productDetail['data']['businessDetails']['trading_name'] ?? '';
      logo = productDetail['data']['businessDetails']['logo'] ?? '';
      businessId = productDetail['data']['businessDetails']['id'] ?? '';
      productId = productDetail['data']['productDetails'][0]['id'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND,
      body: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    logo == ''
                        ? Image.asset(mca, height: 30, package: 'my_cover_sdk')
                        : Image.network(
                            logo,
                            height: 30,
                          ),
                  ],
                ),
                const SizedBox(height: 10),
                selectBody(bodyType),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Image.asset(myCover,
                      width: 170, fit: BoxFit.fitWidth, package: 'my_cover_sdk'),
                ),
              ],
            ),
          ),
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
            productDetail: widget.productData, email: widget.email);
      case BodyType.success:
        return successScreen();
    }
  }

  Widget introBodyScreen() {
    return Expanded(
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
              getProductName(productName),
              smallVerticalSpace(),
            ],
          ),
        ),
      ),
    );
  }

  openIntro(String productType) {
    print('product type - $productType');

    if (productType.contains('auto') || productType.contains('life')) {
      return const AutoScreen();
    }
   else if (productType.contains('health')) {
      return const HealthScreen();
    }
   else if (productType.contains('travel')) {
      return const TravelScreen();
    }
  else  if (productType.contains('gadget') ||
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
                            height: 55, width: 55, package: 'my_cover_sdk'),
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
}
