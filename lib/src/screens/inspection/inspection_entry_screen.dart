// import 'package:flutter/material.dart';
// import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
// import 'package:mca_official_flutter_sdk/src/globals.dart';
// import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';

// class InspectionEntryScreen extends StatefulWidget {
//   final ClaimModel claim;
//   const InspectionEntryScreen({
//     super.key,
//     required this.claim,
//   });

//   @override
//   State<InspectionEntryScreen> createState() => _InspectionEntryScreenState();
// }

// class _InspectionEntryScreenState extends State<InspectionEntryScreen> {
//   @override
//   Widget build(BuildContext context) {
//     // void onComplete(SdkResponse response) {
//     //   PolicyModel? purchasedPolicy = response.policyModel;
//     //   Navigator.of(response.context).pushReplacement(MaterialPageRoute(
//     //     builder: (context) => PostSdkScreen(
//     //       purchasedPolicy: purchasedPolicy,
//     //     ),
//     //   ));
//     // }

//     // void onClose(dynamic result) {
//     //   Navigator.of(result['context']).pushReplacement(MaterialPageRoute(
//     //     builder: (context) => const PreSdkScreen(),
//     //   ));
//   //   // }

//   //   return Scaffold(
//   //     // appBar: AppBar(),
//   //     body: MyCoverAI(
//   //       publicKey: Global.publicKey,
//   //       // "MCAPUBK_TEST|49303c8b-4fb4-4d8b-a4d3-c2f6f6d0fb62",
//   //       onComplete: Global.onComplete,

//   //       mode: Global.mode,
//   //       context: context,
//   //       transactionType: TransactionType.inspection,
//   //       policyId: widget.claim.policyId,
//   //     ),
//   //   );
//   // }
// }
//   // required String? policyId,
//   // required List<String>? productId,
//   // required String? debitWalletReference,
//   // required Map<String, dynamic>? form,
//   // required TransactionType? transactionType,
//   // required PaymentOption? paymentOption,
//   // required bool? isContactFieldsEditable,
//   // required Function? onComplete,
//   // required Function? onClose,
//   // required String mode,
//   // required ProductCategory? productCategory,
//   // required String? policyNumber,
//   // required String? email,