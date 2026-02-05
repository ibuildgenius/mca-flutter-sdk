import 'package:dio/dio.dart';
import 'package:example/post_sdk_screen.dart';
import 'package:flutter/material.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';

class PreSdkScreen extends StatefulWidget {
  const PreSdkScreen({super.key});

  @override
  State<PreSdkScreen> createState() => _PreSdkScreenState();
}

class _PreSdkScreenState extends State<PreSdkScreen> {
  Future<Map<String, dynamic>>? futureData;
  PaymentOption selectedPaymentOption = PaymentOption.wallet;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  void onComplete(SdkResponse response) {
    PolicyModel? purchasedPolicy = response.policyModel;
    Navigator.of(response.context).pushReplacement(MaterialPageRoute(
      builder: (context) => PostSdkScreen(
        purchasedPolicy: purchasedPolicy,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background design
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Top design element
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Bottom design element
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Centered button
          FutureBuilder<Map<String, dynamic>>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.white,
                    ),
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  // return
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildOptionContainer(
                              label: 'Wallet',
                              isSelected:
                                  selectedPaymentOption == PaymentOption.wallet,
                              onTap: () {
                                setState(() {
                                  selectedPaymentOption = PaymentOption.wallet;
                                });
                              },
                            ),
                            const SizedBox(width: 20),
                            _buildOptionContainer(
                              label: 'Gateway',
                              isSelected: selectedPaymentOption ==
                                  PaymentOption.gateway,
                              onTap: () {
                                setState(() {
                                  selectedPaymentOption = PaymentOption.gateway;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  // Handle button press
                                  // setState(() {
                                  //   isLoading = true;
                                  // });

                                  
                                //   Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         // SdkScreen(
                                //         //       walletReference: data,
                                //         //       paymentOption:
                                //         //           selectedPaymentOption,
                                //         //     )

                                //         MyCoverAI(
                                //       publicKey:
                                //           // "MCAPUBK_TEST|fdf50694-45b4-4f78-a6f6-421f8da3a2c8",
                                //           "MCAPUBK_TEST|1acf339a-d36f-47e7-8e1b-fd0b76b61b0c",
                                //       // "MCAPUBK_TEST|49303c8b-4fb4-4d8b-a4d3-c2f6f6d0fb62",
                                //       form: const {
                                //         'email': "fuhad@mycovergenius.com",
                                //         'first_name': 'Fuhad',
                                //         'last_name': 'Aminu',
                                //         'phone': '08123232332',
                                //       },
                                //       // productCategory: ProductCategory.health,
                                //       mode: 'staging',
                                //       onComplete: onComplete,
                                //       // onClose: onClose,
                                //       context: context,
                                //       // transactionType:
                                //       //     TransactionType.inspection,
                                //       policyId:
                                //           "b677c915-b198-4f0a-86b0-bb5522858c42",
                                //       // "8021c2d0-a417-425d-9b19-085f6fbca609",

                                //       policyNumber: "ACC/AR/08/2024/HQ/0678",

                                //       email: "fuhad@mycovergenius.com",

                                //       // https://s3.eu-west-2.amazonaws.com/staging.mycover.ai/2ac5062d-0bbf-458a-bf99-8bcf0d40eecf-VID_2024-07-26%2012-10-34-961212740.mp4

                                //       // isContactFieldsEditable: false,
                                //       // paymentOption: widget.paymentOption,
                                //       // debitWalletReference:
                                //       //     widget.walletReference,
                                //       // productId: const [
                                //       //   "fab6bda1-b870-4648-8704-11c1802a51d0",
                                //       //   // "c1d0f39c-0b8a-452f-a876-78bef8dde1d9",
                                //       //   // "b83d5f4d-e868-4782-bb35-df6e3344ae7d",
                                //       // ],
                                //     ),
                                //     settings: const RouteSettings(
                                //         arguments: 'YourWidgetKey'),
                                //   ));
                                //   // setState(() {
                                //   //   isLoading = false;
                                //   // });
                                },
                          style: ElevatedButton.styleFrom(
                            // primary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                            shadowColor: Colors.black.withOpacity(0.5),
                          ),
                          child: const Text(
                            'Click to open SDK',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  //  SuccessScreen(walletReference: data);
                } else {
                  return const Center(child: Text('No data'));
                }
              }),
        ],
      ),
    );
  }

  Widget _buildOptionContainer(
      {required String label,
      required bool isSelected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.lightBlueAccent
              : Colors.grey[
                  300], // Light blue for selected, light gray for unselected
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                      color: Colors.lightBlue, blurRadius: 10, spreadRadius: 1)
                ]
              : [
                  const BoxShadow(
                      color: Colors.grey, blurRadius: 5, spreadRadius: 1)
                ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> fetchData() async {
  final Dio dio = Dio();
  const String url =
      "https://staging.api.mycover.ai/v1/distributors/create-debit-wallet-reference";
  final Map<String, String> headers = {
    "Authorization": "Bearer MCASECK_TEST|5a571e24-f938-4f14-945c-40ea3cfbc468",
    "Content-Type": "application/json",
  };

  try {
    final response = await dio.post(url, options: Options(headers: headers));
    if (response.statusCode != null && response.statusCode! ~/ 100 == 2) {
      final responseBody = response.data;
      final responseCode = responseBody['responseCode'];
      final responseText = responseBody['responseText'];
      final data = responseBody['data'];

      return {
        'responseCode': responseCode,
        'responseText': responseText,
        'data': data,
      };
    } else {
      throw Exception('Failed to load data');
    }
  } on DioException catch (e) {
    final errorMessage = e.response?.data['responseText'] ?? 'Unknown error';
    throw Exception(errorMessage);
  }
}



