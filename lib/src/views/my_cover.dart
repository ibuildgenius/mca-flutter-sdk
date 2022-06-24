import 'package:flutter/material.dart';
import 'package:my_cover_sdk/src/services/services.dart';
import 'package:my_cover_sdk/src/views/all_products.dart';

import '../widgets/dialogs.dart';
import 'failed.dart';
import 'landing.dart';

enum TypeOfProduct { auto, health, gadget, travel }

class MyCoverAI {
  const MyCoverAI(
      {Key? key,
      required this.context,
      required this.productId,
      required this.userId});

  final BuildContext context;
  final String productId;
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
                  productData: response['data']['productDetails'])
              : MyCover(
                  userId: userId,
                  email: userId,
                  productId: productId,
                  productData: response),
        ),
      );
    }
  }
}
