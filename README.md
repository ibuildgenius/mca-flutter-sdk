# The Official MyCover.ai SDK
<div align="center">
      <img title="http://MyCover.ai" height="200" src="https://www.mycover.ai/images/logos/mycover.svg" width="200px"/>
    </div>


A Flutter plugin for buying insurance, supports both iOS and Android platforms .

## Features

Get your insurance and make payment

## Getting started
1. Add package mca_official_flutter_sdk to your pubspec.yaml file
2. Run flutter pub get
3. Add required permission for the image pickers and camera
4. Add required permission for the geolocation


## Usage
Initialise the sdk in two ways

Some parameters are required to initialise the SDK, namely:

* [publicKey]: this is from your distributor's dashboard and it is always required to initialise purchase
* [transactionType]: this can be either inspection or purchase 
  this is not required only if payment option default as gateway
* [paymentOption]: paymentOption is also required in the case of payment with the wallet, you are expected to supply the payment reference number.
  this is not required only if payment option default as gateway
* [reference]: either it is an uncompleted purchase made from gateway or wallet fresh initialisation reference is required.
  this is not required only if it is a new/fresh purchase and payment method is default (gateway)
* [productId]: this is an array/list of product ID, if it is only one productId, then a product purchase of that single product is initialised, if it is more
  than one or it is empty, all the products are initialised and you can select a product to purchase
* [form]: this takes basic information you will like to pass into the initialisation

1. Input the client ID and also the specific product ID to initialise the SDK, 
This is to initiate a fresh transaction

such as
  initialiseSdk(context, productId:'18k858-jbsj939923',publicKey:'2aa4f6ec-0111-42f4-88f9-466c7ef41727'});

This will initialise the SDK and fetch the selected  product with the product ID and continue your purchase.

2. Input the client ID to fetch all products

such as
initialiseSdk(context,userId:'dami@mycover.ai'});

This will initialise the SDK and fetch all products available and you can select a desired product and continue your purchase.


3. Input the Client ID, productID and the typeOfTransaction and reference,
This can be done when a transaction has already been initiated, payment is made and you have the reference number from the payment done.

such as 
  initialiseSdk(context, productId:'18kjbsj939923',email:'dami@mycover.ai',typeOfTransaction: PurchaseStage.purchase,reference:'BUY-BWBJMPABGFWKB});


```dart
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';

PurchaseStage typeOfTransaction = PurchaseStage.purchase;String reference = 'BUY-BWBJMPABGFWKB';


final myCover = MyCoverAI(
    context: context,
    publicKey: '2aa4f6ec-0111-42f4-88f9-466c7ef41727',
    email: userEmail,
    productId: [productId],
    form: {
      'email': userEmail,
      'name': 'Damilare Peter',
      'phone': '08108257228'
    },
    paymentOption: PaymentOption.gateway,
    reference: 'BUY-SMRCECMNYKMHV',
    transactionType: TransactionType.purchase);
```

## Additional information

 Add the required permission for image picker on Android and iOS android manifest and info.plist respectively
 The app depends on image picker

