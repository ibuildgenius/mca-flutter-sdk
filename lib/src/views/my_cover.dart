import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';

import '../../mca_official_flutter_sdk.dart';
import '../inspection/demo.dart';
import '../inspection/inspection.dart';
import '../services/services.dart';
import '../widgets/dialogs.dart';
import 'all_products.dart';
import 'failed.dart';
import 'homeForm.dart';

// enum TypeOfProduct { auto, health, gadget, travel }

// enum TransactionType { purchase, inspection }

class MyCoverAI extends StatefulWidget {
  final BuildContext context;
  final PaymentOption? paymentOption;
  final TransactionType? transactionType;
  final String? reference;
  final String publicKey;
  final String email;
  final List? productId;
  final Function? onComplete;
  final form;
  const MyCoverAI({
    Key? key,
    required this.context,
    this.productId,
    this.reference,
    required this.email,
    this.form,
    required this.publicKey,
    this.transactionType,
    this.onComplete,
    this.paymentOption,
  }) : super(key: key);

  @override
  State<MyCoverAI> createState() => _MyCoverAIState();
}

class _MyCoverAIState extends State<MyCoverAI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: initialise(),
        builder: (context, rideSnapshot) {
          if (rideSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
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
                              const Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 15.0,
                                      top: 20),
                                  child: Center(
                                      child: CircularProgressIndicator.adaptive(
                                          backgroundColor: Colors.green))),
                              Container(
                                height: 10,
                              ),
                              const Text(
                                  "Initializing MyCover..." ?? 'Please wait...',
                                  style: TextStyle(color: Colors.black))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );

            // return const CircularProgressIndicator();
          } else if (rideSnapshot.hasError) {
            return Text('Error loading ride: ${rideSnapshot.error}');
          } else if (rideSnapshot.hasData) {
            var driverRides = rideSnapshot.data!;
            print(driverRides);
            var newdd = driverRides;

            return Container();
          } else {
            return const Text('No data available');
          }
        },
      ),
    );
  }

  Future<String> getProductCat(catID) async {
    var response =
        await WebServices.getProductCategory(catID, widget.publicKey);

    log("category response $response");

    if (response is Map &&
        (response["responseText"] as String)
            .contains("Product category fetched successfully")) {
      return response["data"]["product_category"]["name"];
    }
    return "";
  }

  initialise() async {
    // Dialogs.showLoading(context: context, text: 'Initializing MyCover...');

    var payOption = widget.paymentOption ?? PaymentOption.gateway;
    var inspectionOption = InspectionType.vehicle;
    var transactionOption = widget.transactionType ?? TransactionType.purchase;
    String productCat = "";

    // BUY-JQZEHTEBPUFVE
    if (transactionOption == TransactionType.inspection) {
      var response = await WebServices.getInspectionInfo(
          widget.reference, widget.publicKey);

      // Navigator.pop(context);
      if (response is String) {
        Dialogs.showErrorMessage(response);
        return await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Failed()),
        );
      } else {
        var policyId = response['data']['payload']['policy']['id'];
        await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DemoScreen(
                      token: widget.publicKey,
                      email: widget.email,
                      reference: widget.reference.toString(),
                      policyId: policyId.toString(),
                      typeOfInspection: inspectionOption,
                    )));
      }
    }
    if (transactionOption == TransactionType.purchase) {
      var response = await WebServices.initialiseSdk(
          productId: widget.productId ?? [],
          publicKey: widget.publicKey,
          reference: payOption == PaymentOption.gateway ? "" : widget.reference,
          paymentOption: payOption.toString().replaceAll('PaymentOption.', ''));

      log("Response $response");

      // Navigator.pop(context);

      if (response is String) {
        Dialogs.showErrorMessage(response);
        return await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Failed()),
        );
      } else {
        if (response['data']['productDetails'].isNotEmpty) {
          var id = response['data']['productDetails'][0]['product_category_id'];

          productCat = await getProductCat(id);

          var instanceId = response['data']['businessDetails']['instance_id'];

          Global.instanceId = instanceId;

          print("Product Cat is " + productCat);
          // print(response['data']['productDetails']);
          Set<String> prefixSet = {};

          // Adding "All" to the set
          prefixSet.add("All");

          // Loop through the list of maps and add the 'prefix' values to the set
          for (var item in response['data']['productDetails']) {
            prefixSet.add(item['prefix']);
          }
          print(1111);
          print(prefixSet);
          Global.prefixList = prefixSet.toList();
          Global.test = widget.publicKey;
          Global.onComplete = widget.onComplete;
          print(widget.onComplete);

          //   response['data']['productDetails']
          //       .forEach((item) => {print(item['prefix'])});

          // }
//PUSH REPLACEMENT BELOW HERE
          return await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  (widget.productId == null || widget.productId == [])
                      ? AllProducts(
                          productData: response['data']['productDetails'],
                          prefixList: prefixSet.toList(),
                          reference: payOption == PaymentOption.gateway
                              ? ""
                              : widget.reference,
                          email: widget.email,
                          publicKey: widget.publicKey,
                          form: widget.form,
                          paymentOption: payOption,
                        )
                      : MyCover(
                          form: widget.form,
                          email: widget.email,
                          publicKey: widget.publicKey,
                          productId: widget.productId,
                          productCategory: productCat.toLowerCase(),
                          productData: response,
                          reference: payOption == PaymentOption.gateway
                              ? ""
                              : widget.reference,
                          paymentOption: payOption,
                        ),
            ),
          );
        }
      }
    }
  }
}
