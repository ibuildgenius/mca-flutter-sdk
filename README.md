# The Official MyCover.ai SDK
<div align="center">
      <img title="http://MyCover.ai" height="200" src="https://www.mycover.ai/images/logos/mycover.svg" width="200px"/>
    </div>


A Flutter plugin for buying insurance, supports both iOS and Android platforms .

## Features

Get your insurance and make payment

## Getting started

1. Add package mca_flutter_sdk to your pubspec.yaml file
2. run flutter pub get
3. Add required permission for the image pickers


## Usage

Initialise the sdk by

1. passing the client ID to fetch all products

initialiseSdk(context, {userId})

var userId = "platforms@mycover.ai";

2. passing the client ID and also the specific product ID to initialise the SDK
   initialiseSdk(context, {productId,userId})

```dart
import 'package:mca_flutter_sdk/mca_flutter_sdk.dart';

initialiseSDK({String? userId, String? productId }) async {
  final myCover = MyCoverAI(context: context, userId: userId, productId: productId);
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

