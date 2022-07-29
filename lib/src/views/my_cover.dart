import 'package:flutter/material.dart';

import '../../mca_flutter_sdk.dart';
import '../inspection/demo.dart';
import '../inspection/inspection.dart';
import '../services/services.dart';
import '../widgets/dialogs.dart';
import 'all_products.dart';
import 'failed.dart';

enum TypeOfProduct { auto, health, gadget, travel }
enum TransactionType { purchase, inspection }

class MyCoverAI {
  const MyCoverAI(
      {Key? key,
      required this.context,
      this.productId,
      this.reference,
      required this.email,
      this.form,
      this.typeOfInspection,
      required this.publicKey,
      required this.transactionType,
      this.paymentOption});

  final BuildContext context;
  final PaymentOption? paymentOption;
  final TransactionType? transactionType;
  final InspectionType? typeOfInspection;
  final String? reference;
  final String publicKey;
  final String email;
  final List? productId;
  final form;

  initialise() async {
    Dialogs.showLoading(context: context, text: 'Initializing MyCover...');
    var payOption = paymentOption ?? PaymentOption.gateway;
    var inspectionOption = typeOfInspection ?? InspectionType.vehicle;

    if (transactionType == TransactionType.inspection) {
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
    if (transactionType == TransactionType.purchase) {
      var response = await WebServices.initialiseSdk(
          productId: productId ?? [],
          publicKey: publicKey,
          reference: reference,
          paymentOption: payOption.toString().replaceAll('PaymentOption.', ''));
      Navigator.pop(context);

      if (response is String) {
        Dialogs.showErrorMessage(response);
        return await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Failed()),
        );
      } else {
        return await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => (productId == null || productId == [])
                ? AllProducts(
                    productData: response['data']['productDetails'],
                    reference: reference,
                    email: email,
                    publicKey: publicKey,
                    form: form,
                    paymentOption: payOption)
                : MyCover(
                    form: form,
                    email: email,
                    publicKey: publicKey,
                    productId: productId,
                    productData: response,
                    reference: reference,
                    paymentOption: payOption),
          ),
        );
      }
    }
  }
}
