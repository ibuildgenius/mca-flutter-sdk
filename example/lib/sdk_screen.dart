// import 'package:example/post_sdk_screen.dart';
// import 'package:example/pre_sdk_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';

// class SdkScreen extends StatefulWidget {
//   final String walletReference;
//   final PaymentOption paymentOption;
//   const SdkScreen({
//     super.key,
//     required this.walletReference,
//     required this.paymentOption,
//   });

//   @override
//   State<SdkScreen> createState() => _SdkScreenState();
// }

// class _SdkScreenState extends State<SdkScreen> {
//   static const stagingMode = "staging";
//   @override
//   Widget build(BuildContext context) {
//     void onComplete(SdkResponse response) {
//       PolicyModel? purchasedPolicy = response.policyModel;
//       Navigator.of(response.context).pushReplacement(MaterialPageRoute(
//         builder: (context) => PostSdkScreen(
//           purchasedPolicy: purchasedPolicy,
//         ),
//       ));
//     }

//     void onClose(dynamic result) {
//       Navigator.of(result['context']).pushReplacement(MaterialPageRoute(
//         builder: (context) => const PreSdkScreen(),
//       ));
//     }

//     return const Scaffold(
//         // appBar: AppBar(),
//         // body: MyCoverAI(
//         //   publicKey:
//         //       // "MCAPUBK_TEST|fdf50694-45b4-4f78-a6f6-421f8da3a2c8",
//         //       "MCAPUBK_TEST|1acf339a-d36f-47e7-8e1b-fd0b76b61b0c",
//         //   // "MCAPUBK_TEST|49303c8b-4fb4-4d8b-a4d3-c2f6f6d0fb62",
//         //   form: const {
//         //     'email': "fuhad@mycovergenius.com",
//         //     'first_name': 'Fuhad',
//         //     'last_name': 'Aminu',
//         //     'phone': '08123232332',
//         //   },
//         //   // productCategory: ProductCategory.health,
//         //   mode: stagingMode,
//         //   onComplete: onComplete,
//         //   onClose: onClose,
//         //   context: context,
//         //   transactionType: TransactionType.inspection,
//         //   policyId: "7780990h",

//         //   //"8021c2d0-a417-425d-9b19-085f6fbca609",

//         //   policyNumber: "jdshds7",

//         //   // "110505492401009",

//         //   email: "fuhad@mycovergenius.comm",

//         //   // https://s3.eu-west-2.amazonaws.com/staging.mycover.ai/2ac5062d-0bbf-458a-bf99-8bcf0d40eecf-VID_2024-07-26%2012-10-34-961212740.mp4

//         //   // isContactFieldsEditable: false,
//         //   paymentOption: widget.paymentOption,
//         //   debitWalletReference: widget.walletReference,
//         //   // productId: const [
//         //   //   "fab6bda1-b870-4648-8704-11c1802a51d0",
//         //   //   // "c1d0f39c-0b8a-452f-a876-78bef8dde1d9",
//         //   //   // "b83d5f4d-e868-4782-bb35-df6e3344ae7d",
//         //   // ],
//         // ),
//         );
//   }
// }
