import 'package:flutter/material.dart';

import '../../mca_flutter_sdk.dart';
import '../widgets/dialogs.dart';
import 'all_products.dart';
import 'failed.dart';
import 'landing.dart';

enum TypeOfProduct { auto, health, gadget, travel }

class MyCoverAI {
  const MyCoverAI(
      {Key? key,
      required this.context,
      this.productId = '',
      this.reference = '',
      this.typeOfTransaction = PurchaseStage.payment,
      required this.userId});

  final BuildContext context;
  final PurchaseStage? typeOfTransaction;
  final String ? reference;

  final String? productId;
  final String userId;

  initialise() async {
    Dialogs.showLoading(context: context, text: 'Initializing MyCover...');

    var response =
        await WebServices.initialiseSdk(userId: userId, productId: productId);
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
                  typeOfTransaction: typeOfTransaction)
              : MyCover(
                  userId: userId,
                  email: userId,
                  productId: productId,
                  productData: response,
                  reference: reference,
                  typeOfTransaction: typeOfTransaction),
        ),
      );
    }
  }
}
