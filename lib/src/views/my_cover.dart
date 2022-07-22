import 'package:flutter/material.dart';

import '../../mca_flutter_sdk.dart';
import '../services/services.dart';
import '../widgets/dialogs.dart';
import 'all_products.dart';
import 'failed.dart';

enum TypeOfProduct { auto, health, gadget, travel }

class MyCoverAI {
  const MyCoverAI(
      {Key? key,
      required this.context,
      this.productId = '',
      this.reference,
      this.paymentOption,
      required this.userId});

  final BuildContext context;
  final PaymentOption? paymentOption;
  final String? reference;

  final String? productId;
  final String userId;

  initialise() async {
    Dialogs.showLoading(context: context, text: 'Initializing MyCover...');
    print(paymentOption);
    var payOption = paymentOption??PaymentOption.gateway;
    print(payOption);
    var response = await WebServices.initialiseSdk(
        userId: userId,
        productId: productId,
        reference:reference,
        paymentOption:
        payOption.toString().replaceAll('PaymentOption.', ''));
    Navigator.pop(context);

    if (response is String) {
      Dialogs.showErrorMessage(response);

      return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Failed(),
        ),
      );
    } else {
      return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => productId == ''
              ? AllProducts(
                  userId: userId,
                  productData: response['data']['productDetails'],
                  reference: reference,
              paymentOption: payOption)
              : MyCover(
                  userId: userId,
                  email: userId,
                  productId: productId,
                  productData: response,
                  reference: reference,
              paymentOption: payOption),
        ),
      );
    }
  }
}
