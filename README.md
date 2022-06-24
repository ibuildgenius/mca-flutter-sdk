<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->


TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

Initialise the sdk by

1. passing the client ID to fetch all products

initialiseSdk(context, {productId}) async {
var userId = "olakunle@mycovergenius.com";

2. passing the client ID and also the specific product ID to 

initialise the SDK

initialiseSDK({String userId, String productId })async{
final myCover =  MyCoverAI(context: context, userId: userId, productId: productId );
  var response = await myCover.initialise();
if (response != null) {
    showLoading('$response');
    } else {
      print("No Response!");
   }
  }
}


## Add image picker to you permission on Android and iOS
## The app depends on image picker


```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
