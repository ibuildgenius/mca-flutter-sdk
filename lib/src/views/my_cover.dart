import 'package:flutter/material.dart';
import 'package:my_cover_sdk/src/services/services.dart';

import '../theme.dart';
import '../widgets/dialogs.dart';
import 'landing.dart';

enum TypeOfProduct { auto, health, gadget, travel }


class MyCoverLaunch {
  const MyCoverLaunch({Key? key,
    required this.context,
    required this.productId,
    this.primaryColor = PRIMARY,
    this.accentColor = FILL_GREEN,
    required this.userId});

  final BuildContext context;
  final String productId;
  final String userId;
  final accentColor;
  final primaryColor;

  /// Starts Standard Transaction


  charge() async {
    Dialogs.showLoading(context: context, text: 'Initializing MyCover...');

    var response = await
    WebServices.initialiseSdk(userId: userId, productId: productId);
    print(response);
    Navigator.pop(context);

    if (response is String) {
      Navigator.pop(context);
      print('failed to initialise');

    }
    else {
      return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MyCover(
                userId: userId,
                productId: productId,
                productData: response,
                primaryColor: primaryColor,
                accentColor: accentColor,
              ),
        ),
      );
    }
  }
}