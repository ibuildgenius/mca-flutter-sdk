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

enum TypeOfProduct { auto, health, gadget, travel }

enum TransactionType { purchase, inspection }

class MyCoverAIInitializer {
  const MyCoverAIInitializer(
      {Key? key,
      required this.context,
      this.productId,
      this.reference,
      required this.email,
      this.form,
      required this.publicKey,
      this.transactionType,
      this.paymentOption});

  final BuildContext context;
  final PaymentOption? paymentOption;
  final TransactionType? transactionType;
  final String? reference;
  final String publicKey;
  final String email;
  final List? productId;
  final form;

  Future<String> getProductCat(catID) async {
    var response = await WebServices.getProductCategory(catID, publicKey);

    log("category response $response");

    if (response is Map &&
        (response["responseText"] as String)
            .contains("Product category fetched successfully")) {
      return response["data"]["product_category"]["name"];
    }
    return "";
  }

  initialise() async {
    Dialogs.showLoading(context: context, text: 'Initializing MyCover...');
    var payOption = paymentOption ?? PaymentOption.gateway;
    var inspectionOption = InspectionType.vehicle;
    var transactionOption = transactionType ?? TransactionType.purchase;

    // BUY-JQZEHTEBPUFVE
    if (transactionOption == TransactionType.inspection) {
      var response = await WebServices.getInspectionInfo(reference, publicKey);

      Navigator.pop(context);
      if (response is String) {
        Dialogs.showErrorMessage(response);
        return await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Failed()),
        );
      } else {
        var policyId = response['data']['payload']['policy']['id'];
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DemoScreen(
                      token: publicKey,
                      email: email,
                      reference: reference.toString(),
                      policyId: policyId.toString(),
                      typeOfInspection: inspectionOption,
                    )));
      }
    }
    if (transactionOption == TransactionType.purchase) {
      var response = await WebServices.initialiseSdk(
          productId: productId ?? [],
          publicKey: publicKey,
          reference: reference,
          paymentOption: payOption.toString().replaceAll('PaymentOption.', ''));

      log("Response $response");

      if (response is String) {
        Navigator.pop(context);
        Dialogs.showErrorMessage(response);
        return await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Failed()),
        );
      } else {
        var id = response['data']['productDetails'][0]['product_category_id'];

        var productCat = await getProductCat(id);

        print("Product Cat is " + productCat);
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

        //   response['data']['productDetails']
        //       .forEach((item) => {print(item['prefix'])});
        Navigator.pop(context);
        return await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => (productId == null || productId == [])
                ? AllProducts(
                    productData: response['data']['productDetails'],
                    reference: reference,
                    prefixList: prefixSet.toList(),
                    email: email,
                    publicKey: publicKey,
                    form: form,
                    paymentOption: payOption,
                  )
                : MyCover(
                    form: form,
                    email: email,
                    publicKey: publicKey,
                    productId: productId,
                    productCategory: productCat.toLowerCase(),
                    productData: response,
                    reference: reference,
                    paymentOption: payOption),
          ),
        );
      }
    }
  }
}
