# The Official MyCover.ai SDK
<div align="center">
      <img title="http://MyCover.ai" height="200" src="https://www.mycover.ai/images/logos/mycover.svg" width="200px"/>
    </div>


A Flutter plugin for buying insurance, supports both iOS and Android platforms .

## Features

Get your insurance and make payment

## Getting started

1. Add package mca_flutter_sdk to your pubspec.yaml file
2. Run flutter pub get
3. Add required permission for the image pickers



## Usage

Initialise the sdk in two ways

1. Input the client ID and also the specific product ID to initialise the SDK, 
This is to initiate a fresh transaction

such as
  initialiseSdk(context, productId:'18kjbsj939923',userId:'dami@mycover.ai'});

This will initialise the SDK and fetch the selected  product with the product ID and continue your purchase.

2. Input the client ID to fetch all products

such as
initialiseSdk(context,userId:'dami@mycover.ai'});

This will initialise the SDK and fetch all products available and you can select a desired product and continue your purchase.


3. Input the Client ID, productID and the typeOfTransaction and reference,
This can be done when a transaction has already been initiated, payment is made and you have the reference number from the payment done.

such as 
  initialiseSdk(context, productId:'18kjbsj939923',userId:'dami@mycover.ai',typeOfTransaction: PurchaseStage.purchase,reference:'BUY-BWBJMPABGFWKB});


```dart
import 'package:mca_flutter_sdk/mca_flutter_sdk.dart';

PurchaseStage typeOfTransaction = PurchaseStage.purchase;String reference = 'BUY-BWBJMPABGFWKB';


initialiseSDK({String? userId, String? productId }) async {
  final myCover = MyCoverAI(context: context, userId: userId, productId: productId,typeOfTransaction: typeOfTransaction,reference: reference);
  var response = await myCover.initialise();
  if (response != null) {
    showLoading('$response');
  }
  else {
    print("No Response!");
  }
} 
```

## Additional information

 Add the required permission for image picker on Android and iOS android manifest and info.plist respectively
 The app depends on image picker

