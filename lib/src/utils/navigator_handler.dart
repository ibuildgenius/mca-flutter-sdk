// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mca_official_flutter_sdk/src/screens/initialization/welcome_screen.dart';

// // UserData userData = locator<LocalCache>().getUserData();
// /// Added a global container for a global riverpod container
// final globalRef = ProviderContainer();
// ////////

// /// Handles navigation
// abstract class NavigationHandler {
//   ///Pushes [destinationRoute] route onto the stack
//   Future<dynamic>? pushNamed(
//     String destinationRoute, {
//     dynamic arg,
//   });

//   ///Pushes [destinationRoute] onto stack and removes stack items until
//   ///[lastRoute] is hit
//   Future<dynamic>? pushNamedAndRemoveUntil(
//     String destinationRoute, {
//     dynamic arg,
//   });

//   ///Pushes [destinationRoute] onto stack with replacement
//   Future<dynamic>? pushReplacementNamed(
//     String destinationRoute, {
//     dynamic arg,
//   });

//   ///Pushes [destinationWidget] onto stack with replacement
//   Future<dynamic>? pushReplacement(
//     Widget destinationWidget, {
//     dynamic arg,
//   });

//   ///Pushes [destinationRoute after popping current route off stack
//   Future<dynamic>? popAndPushNamed(
//     String destinationRoute, {
//     dynamic arg,
//   });

//   ///Pops current route off stack
//   void goBack();

//   ///Pops routes on stack until [destinationRoute] is hit
//   void popUntil(String destinationRoute);

//   ///Exits app
//   void exitApp();

//   late GlobalKey<NavigatorState> navigatorKey;
// }

// class NavigationHandlerImpl implements NavigationHandler {
//   @override
//   late GlobalKey<NavigatorState> navigatorKey;

//   /// Constructs a NavigationHandler instance
//   NavigationHandlerImpl({GlobalKey<NavigatorState>? navigatorKey}) {
//     this.navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();
//   }

//   NavigatorState? get state => navigatorKey.currentState;

//   @override
//   void exitApp() {
//     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//   }

//   @override
//   void goBack() {
//     if (state != null) {
//       return state!.pop();
//     }
//   }

//   @override
//   Future? popAndPushNamed(String destinationRoute, {arg}) {
//     if (state != null) {
//       return state!.popAndPushNamed(destinationRoute, arguments: arg);
//     }
//     return null;
//   }

//   @override
//   void popUntil(String destinationRoute) {
//     if (state != null) {
//       return state!.popUntil(ModalRoute.withName(destinationRoute));
//     }
//   }

//   @override
//   Future? pushNamed(String destinationRoute, {arg}) {
//     if (state != null) {
//       return state!.pushNamed(destinationRoute, arguments: arg);
//     }
//     return null;
//   }

//   @override
//   Future? pushNamedAndRemoveUntil(String destinationRoute, {arg}) {
//     if (state != null) {
//       return state!.pushNamedAndRemoveUntil(destinationRoute, (route) => false,
//           arguments: arg);

//       // return state!.pushNamedAndRemoveUntil(
//       //   destinationRoute,
//       //   ModalRoute.withName(lastRoute),
//       //   arguments: arg,
//       // );
//     }
//     return null;
//   }

//   @override
//   Future? pushReplacementNamed(String destinationRoute, {arg}) {
//     if (state != null) {
//       return state!.pushReplacementNamed(destinationRoute, arguments: arg);
//     }
//     return null;
//   }

//   @override
//   Future? pushReplacement(Widget destinationWidget, {arg}) {
//     if (state != null) {
//       return state!.pushReplacement(MaterialPageRoute(
//         builder: (context) => const WelcomeScreen(),
//       ));
//     }
//     return null;
//   }
// }

// final shouldRebuildProvider = StateProvider.autoDispose<bool>((ref) => false);

// toggleShouldRebuild(WidgetRef ref) {
//   if (ref.watch(shouldRebuildProvider)) {
//     ref.read(shouldRebuildProvider.notifier).state = false;
//   } else {
//     ref.read(shouldRebuildProvider.notifier).state = true;
//   }
// }
