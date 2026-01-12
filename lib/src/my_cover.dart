// // ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:mca_official_flutter_sdk/locator.dart';
// import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
// import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
// import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
// import 'package:mca_official_flutter_sdk/src/globals.dart';
// import 'package:mca_official_flutter_sdk/src/screens/initialization/initialization_view_model.dart';
// import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
// import 'package:mca_official_flutter_sdk/src/utils/provider_utils.dart';
// import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
// import 'package:mca_official_flutter_sdk/src/widgets/custom_appbar.dart';
// import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

// final GlobalKey<NavigatorState> packageNavigatorKey =
//     GlobalKey<NavigatorState>();

// class MyCoverAI extends StatefulHookConsumerWidget {
//   final BuildContext context;
//   final PaymentOption? paymentOption;
//   final String? policyId;
//   final String? policyNumber;
//   final String? email;

//   final TransactionType? transactionType;
//   final String? debitWalletReference;
//   final String publicKey;
//   final String? mode;
//   final List<String>? productId;
//   final Function? onComplete;
//   final Function? onClose;
//   final bool? isContactFieldsEditable;
//   final ProductCategory? productCategory;
//   final Map<String, dynamic>? form;
//   final String? progress;

//   const MyCoverAI({
//     super.key,
//     required this.context,
//     required this.publicKey,
//     this.policyId,
//     this.policyNumber,
//     this.email,
//     this.productId,
//     this.debitWalletReference,
//     this.form,
//     this.transactionType,
//     this.paymentOption,
//     this.isContactFieldsEditable,
//     this.productCategory,
//     required this.onComplete,
//     this.onClose,
//     this.mode = ConstantString.liveMode,
//     this.progress,
//   });

//   @override
//   ConsumerState<MyCoverAI> createState() => _MyCoverAIState();
// }

// class _MyCoverAIState extends ConsumerState<MyCoverAI> {
// //  late Future<void> _future;

//   static initializeSDKFlow(
//       BuildContext context,
//       PaymentOption? paymentOption,
//       String? policyId,
//       String? policyNumber,
//       String? email,
//       TransactionType? transactionType,
//       String? debitWalletReference,
//       String publicKey,
//       String? mode,
//       List<String>? productId,
//       Function? onComplete,
//       Function? onClose,
//       bool? isContactFieldsEditable,
//       ProductCategory? productCategory,
//       Map<String, dynamic>? form,
//       String? progress) {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => MyCoverAI(
//                 context: context,
//                 publicKey: publicKey,
//                 transactionType: transactionType,
//                 paymentOption: paymentOption,
//                 email: email,
//                 productId: productId,
//                 policyNumber: policyNumber,
//                 form: form,
//                 debitWalletReference: debitWalletReference,
//                 mode: mode,
//                 isContactFieldsEditable: isContactFieldsEditable,
//                 productCategory: productCategory,
//                 progress: progress,
//                 policyId: policyId,
//                 onClose: onClose,

//                 onComplete: onComplete)));
//   }

//   @override
//   void initState() {
//     super.initState();
//     onSDKNotifier.value = true;
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       initialise(
//         context: widget.context,
//         publicKey: widget.publicKey,
//         policyId: widget.policyId,
//         ref: ref,
//         productId: widget.productId,
//         debitWalletReference: widget.debitWalletReference,
//         form: widget.form,
//         transactionType: widget.transactionType,
//         paymentOption: widget.paymentOption,
//         isContactFieldsEditable: widget.isContactFieldsEditable,
//         onComplete: widget.onComplete,
//         onClose: widget.onClose,
//         mode: widget.mode ?? ConstantString.liveMode,
//         productCategory: widget.productCategory,
//         policyNumber: widget.policyNumber,
//         email: widget.email,
//         progress: widget.progress,
//       );
//     });
//   }

//   // BuildContext? newContext;
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 973),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: ValueListenableBuilder(
//             valueListenable: onSDKNotifier,
//             builder: (context, onSDK, child) {
//               // if (!onSDK) {
//               //   WidgetsBinding.instance.addPostFrameCallback((_) {
//               //     Navigator.pop(context);
//               //   });
//               //   return SizedBox();
//               // }
//               return Material(
//                 child: Center(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Padding(
//                         padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                         child: SpinKitFadingCircle(
//                           color: CustomColors.primaryBrandColor(),
//                           size: 35.0,
//                         ),
//                       ),
//                       // Builder(builder: (context) {
//                       //   newContext = context;
//                       //   return Container(
//                       //     height: 30,
//                       //   );
//                       // }),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           semiBoldText("Welcome", fontSize: 16.sp),
//                           horizontalSpacer(10),
//                           const SpinKitThreeBounce(
//                             color: Colors.black,
//                             size: 10.0,
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             }),
//       ),
//     );
//   }
// }

// initialise(
//     {required String publicKey,
//     required WidgetRef ref,
//     required BuildContext context,
//     required String? policyId,
//     required List<String>? productId,
//     required String? debitWalletReference,
//     required Map<String, dynamic>? form,
//     required TransactionType? transactionType,
//     required PaymentOption? paymentOption,
//     required bool? isContactFieldsEditable,
//     required Function? onComplete,
//     required Function? onClose,
//     required String mode,
//     required ProductCategory? productCategory,
//     required String? policyNumber,
//     required String? email,
//     String? progress}) async {
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     ProviderUtils.resetAllProviders(ref);
//   });

//   //

//   Global.publicKey = publicKey;
//   Global.context = context;
//   Global.paymentOption = paymentOption ?? PaymentOption.gateway;
//   Global.form = form != null ? Map<String, dynamic>.from(form) : {};
//   Global.productId = productId ?? [];
//   Global.reference = debitWalletReference ?? "";
//   Global.onComplete = onComplete;
//   Global.onClose = onClose;
//   Global.isContactFieldsEditable = isContactFieldsEditable ?? true;
//   Global.email = Global.form.containsKey('email') ? Global.form['email'] : null;
//   Global.phone = Global.form.containsKey('phone') ? Global.form['phone'] : null;
//   Global.mode = mode;
//   Global.policyId = policyId ?? "";
//   Global.policyNumber = policyNumber;
//   Global.inspectionEmail = email;
//   Global.progress = progress;
//   Global.productCategory = productCategory;

// // Check if the Global.form contains the key 'phone'
//   if (Global.form.containsKey('phone')) {
//     // Add the 'phone_number' key with the same value as 'phone'
//     Global.form['phone_number'] = Global.form['phone'];
//   }

//   await setupLocator();
//   ref.read(paymentOptionProvider.notifier).state =
//       paymentOption ?? PaymentOption.gateway;

//   Global.transactionType = transactionType;

//   ref.read(publicKeyProvider.notifier).state = publicKey;

//   ref.read(onCompleteProvider.notifier).state = onComplete;
//   ref.read(onCloseProvider.notifier).state = onClose;
//   ref.read(isContactFieldsEditableProvider.notifier).state =
//       isContactFieldsEditable ?? true;

//   //  i

//   // Navigator.pushReplacement(context,
//   //     MaterialPageRoute(builder: (context) => const CarInspectionPageView()));

//   if (transactionType == TransactionType.inspection) {
//     await InitViewModel().initialiseInspectionSdk(
//       ref,
//       context,
//     );
//   } else if (transactionType == TransactionType.claim) {
//     log('my claim');
//     await InitViewModel().initialiseClaimSdk(
//       ref,
//       context,
//     );
//   } else {
//     log('this is ut');
//     await InitViewModel().initialiseSdk(
//       ref,
//       context,
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mca_official_flutter_sdk/locator.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';
import 'package:mca_official_flutter_sdk/src/screens/initialization/initialization_view_model.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import 'package:mca_official_flutter_sdk/src/utils/provider_utils.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

// Global key for the SDK's internal navigator
final GlobalKey<NavigatorState> packageNavigatorKey =
    GlobalKey<NavigatorState>();

// Main SDK Entry Point Class
class MyCoverAI {
  /// Main method to start the SDK flow - this is what host apps will call
  static Future<Map<String, dynamic>?> startFlow({
    required BuildContext context,
    required String publicKey,
    PaymentOption? paymentOption,
    String? policyId,
    String? policyNumber,
    String? email,
    TransactionType? transactionType,
    String? debitWalletReference,
    String? mode,
    List<String>? productId,
    Function? onComplete,
    Function? onClose,
    bool? isContactFieldsEditable,
    ProductCategory? productCategory,
    Map<String, dynamic>? form,
    String? progress,
    String? claimId,
  }) async {
    return await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => MyCoverAINavigatorWrapper(
          publicKey: publicKey,
          paymentOption: paymentOption,
          policyId: policyId,
          policyNumber: policyNumber,
          email: email,
          transactionType: transactionType,
          debitWalletReference: debitWalletReference,
          mode: mode,
          claimId: claimId,
          productId: productId,
          onComplete: onComplete,
          onClose: onClose,
          isContactFieldsEditable: isContactFieldsEditable,
          productCategory: productCategory,
          form: form,
          progress: progress,
        ),
      ),
    );
  }

  /// Method to exit the SDK from anywhere within the flow
  static void exitSDK(
    BuildContext context,
  ) {
    // Reset SDK state
    // onSDKNotifier.value = false;
    Navigator.of(context, rootNavigator: false)
        .popUntil((route) => route.isFirst);

    Navigator.of(context, rootNavigator: true).pop();
  }
}

// Navigator Wrapper - Contains the entire SDK flow
class MyCoverAINavigatorWrapper extends StatelessWidget {
  final PaymentOption? paymentOption;
  final String? policyId;
  final String? policyNumber;
  final String? email;
  final TransactionType? transactionType;
  final String? debitWalletReference;
  final String publicKey;
  final String? mode;
  final List<String>? productId;
  final Function? onComplete;
  final Function? onClose;
  final bool? isContactFieldsEditable;
  final ProductCategory? productCategory;
  final Map<String, dynamic>? form;
  final String? progress;
  final String? claimId;

  const MyCoverAINavigatorWrapper({
    super.key,
    required this.publicKey,
    this.policyId,
    this.policyNumber,
    this.email,
    this.productId,
    this.debitWalletReference,
    this.form,
    this.transactionType,
    this.paymentOption,
    this.isContactFieldsEditable,
    this.productCategory,
    this.onComplete,
    this.onClose,
    this.mode = ConstantString.liveMode,
    this.progress,
    this.claimId,
  });

  @override
  Widget build(BuildContext context) {
    log('my mode ${mode}');
    return ScreenUtilInit(
      designSize: const Size(375, 973),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Material(
          child: Navigator(
            key: packageNavigatorKey,
            onGenerateRoute: (settings) {
              // Default route - return the initialization screen
              return MaterialPageRoute(
                builder: (context) => MyCoverAIInitializationScreen(
                  publicKey: publicKey,
                  paymentOption: paymentOption,
                  policyId: policyId,
                  policyNumber: policyNumber,
                  email: email,
                  transactionType: transactionType,
                  debitWalletReference: debitWalletReference,
                  mode: mode,
                  productId: productId,
                  onComplete: onComplete,
                  onClose: onClose,
                  claimId: claimId,
                  isContactFieldsEditable: isContactFieldsEditable,
                  productCategory: productCategory,
                  form: form,
                  progress: progress,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleSDKExit(
    BuildContext context, {
    bool cancelled = false,
    Map<String, dynamic>? result,
  }) {
    // Call the onClose callback if provided
    if (cancelled && onClose != null) {
      onClose!();
    } else if (!cancelled && onComplete != null) {
      onComplete!(result);
    }

    // Exit the SDK
    MyCoverAI.exitSDK(
      context,
    );
  }
}

// Initialization Screen (formerly the main MyCoverAI widget)
class MyCoverAIInitializationScreen extends StatefulHookConsumerWidget {
  final PaymentOption? paymentOption;
  final String? policyId;
  final String? policyNumber;
  final String? email;
  final TransactionType? transactionType;
  final String? debitWalletReference;
  final String publicKey;
  final String? mode;
  final List<String>? productId;
  final Function? onComplete;
  final Function? onClose;
  final bool? isContactFieldsEditable;
  final ProductCategory? productCategory;
  final Map<String, dynamic>? form;
  final String? progress;
  final String? claimId;

  const MyCoverAIInitializationScreen(
      {super.key,
      required this.publicKey,
      this.policyId,
      this.policyNumber,
      this.email,
      this.productId,
      this.debitWalletReference,
      this.form,
      this.transactionType,
      this.paymentOption,
      this.isContactFieldsEditable,
      this.productCategory,
      this.onComplete,
      this.onClose,
      this.mode = ConstantString.liveMode,
      this.progress,
      this.claimId});

  @override
  ConsumerState<MyCoverAIInitializationScreen> createState() =>
      _MyCoverAIInitializationScreenState();
}

class _MyCoverAIInitializationScreenState
    extends ConsumerState<MyCoverAIInitializationScreen> {
  @override
  void initState() {
    super.initState();
    // onSDKNotifier.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialise(
        context: context, // Use the nested navigator context
        publicKey: widget.publicKey,
        policyId: widget.policyId,
        ref: ref,
        productId: widget.productId,
        debitWalletReference: widget.debitWalletReference,
        form: widget.form,
        transactionType: widget.transactionType,
        paymentOption: widget.paymentOption,
        isContactFieldsEditable: widget.isContactFieldsEditable,
        onComplete: widget.onComplete,
        onClose: widget.onClose,
        claimId: widget.claimId,
        mode: widget.mode ?? ConstantString.liveMode,
        productCategory: widget.productCategory,
        policyNumber: widget.policyNumber,
        email: widget.email,
        progress: widget.progress,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: Icon(Icons.close, color: Colors.black),
      //     onPressed: () {
      //       // Exit the entire SDK
      //       MyCoverAI.exitSDK(
      //         context,
      //       );
      //     },
      //   ),
      // ),
      body: Material(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: SpinKitFadingCircle(
                  color: CustomColors.primaryBrandColor(),
                  size: 35.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  semiBoldText("Welcome", fontSize: 16.sp),
                  horizontalSpacer(10),
                  const SpinKitThreeBounce(
                    color: Colors.black,
                    size: 10.0,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Modified initialization function
initialise({
  required String publicKey,
  required WidgetRef ref,
  required BuildContext context,
  required String? policyId,
  required List<String>? productId,
  required String? debitWalletReference,
  required Map<String, dynamic>? form,
  required TransactionType? transactionType,
  required PaymentOption? paymentOption,
  required bool? isContactFieldsEditable,
  required Function? onComplete,
  required Function? onClose,
  required String mode,
  required ProductCategory? productCategory,
  required String? policyNumber,
  required String? email,
  String? claimId,
  String? progress,
}) async {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ProviderUtils.resetAllProviders(ref);
  });

  // Set all global variables (same as before)
  Global.publicKey = publicKey;
  Global.context = context;
  Global.paymentOption = paymentOption ?? PaymentOption.gateway;
  Global.form = form != null ? Map<String, dynamic>.from(form) : {};
  Global.productId = productId ?? [];
  Global.reference = debitWalletReference ?? "";
  Global.onComplete = onComplete;
  Global.onClose = onClose;
  Global.isContactFieldsEditable = isContactFieldsEditable ?? true;
  Global.email = Global.form.containsKey('email') ? Global.form['email'] : null;
  Global.phone = Global.form.containsKey('phone') ? Global.form['phone'] : null;
  Global.mode = mode;
  Global.policyId = policyId ?? "";
  Global.policyNumber = policyNumber;
  Global.inspectionEmail = email;
  Global.progress = progress;
  Global.productCategory = productCategory;
  Global.claimId = claimId ?? '';

  // Check if the Global.form contains the key 'phone'
  if (Global.form.containsKey('phone')) {
    Global.form['phone_number'] = Global.form['phone'];
  }

  await setupLocator();
  ref.read(paymentOptionProvider.notifier).state =
      paymentOption ?? PaymentOption.gateway;

  Global.transactionType = transactionType;
  ref.read(publicKeyProvider.notifier).state = publicKey;
  ref.read(onCompleteProvider.notifier).state = onComplete;
  ref.read(onCloseProvider.notifier).state = onClose;
  ref.read(isContactFieldsEditableProvider.notifier).state =
      isContactFieldsEditable ?? true;

  // Navigation within the nested navigator
  if (transactionType == TransactionType.inspection) {
    log('isnpecc');
    await CustomerInitConfig().initialiseDefaultConfig(ref, context);
    await InitViewModel().initialiseInspectionSdk(ref, context);
  } else if (transactionType == TransactionType.claim) {
    log('my claim$mode');
    await CustomerInitConfig().initialiseDefaultConfig(ref, context);
    await InitViewModel().initialiseClaimSdk(ref, context);
  } else {
    log('this is ut');
    await CustomerInitConfig().initialiseDefaultConfig(ref, context);
    await InitViewModel().initialiseSdk(ref, context);
  }
}
