import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mca_flutter_sdk/mca_flutter_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'MyCover SDK Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var allProducts;
  String userEmail = 'olakunle@mycovergenius.com';

  initialiseSdk(context, {userId, productId, paymentOption, reference}) async {
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
        paymentOption: paymentOption,
        reference: reference,
        transactionType: TransactionType.purchase);
    var response = await myCover.initialise();
    if (response != null) {
      showLoading('$response');
    } else {
      print("No Response!");
    }
  }

  @override
  initState() {
    super.initState();
    getAllProducts(userEmail);
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }

  static makePostRequest({apiUrl, data, token}) async {
    final uri = Uri.parse(apiUrl);
    final jsonString = json.encode(data);
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    return await http.post(uri, body: jsonString, headers: headers);
  }

  static const String productUrl =
      'https://staging.api.mycover.ai/v1/sdk/initialize';

  static const String _generateRefUrl =
      'https://staging.api.mycover.ai/v1/distributors/create-debit-wallet-reference';

  // static getRef(businessId, reference) async {
  //   var requestUrl = _generateRefUrl;
  //   return await ApiScheme.initialiseGetRequest(
  //       url: requestUrl,
  //       apiKey: businessId,
  //       token: '575b0498-24b1-4a75-9446-546640b778c6'
  //   );
  // }

  getAllProducts(clientId) async {
    var data = {"client_id": clientId, "payment_option": 'gateway'};
    try {
      // Bearer 575b0498-24b1-4a75-9446-546640b778c6
      var res = await makePostRequest(
          apiUrl: productUrl,
          data: data,
          token: '2aa4f6ec-0111-42f4-88f9-466c7ef41727');
      if (res.statusCode! >= 200 && res.statusCode < 300) {
        var body = jsonDecode(res.body);
        setState(() => allProducts = body['data']['productDetails']);
      }
    } catch (e) {
      return e.toString();
    }
  }

  getRef(clientId) async {
    var data = {"client_id": clientId, "payment_option": 'gateway'};
    try {
      // Bearer 575b0498-24b1-4a75-9446-546640b778c6
      var res = await makePostRequest(
          apiUrl: _generateRefUrl,
          data: data,
          token: '575b0498-24b1-4a75-9446-546640b778c6');
      if (res.statusCode! >= 200 && res.statusCode < 300) {
        var body = jsonDecode(res.body);
        setState(() => allProducts = body['data']['productDetails']);
      }
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Buy products')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: allProducts == null
              ? const Center(
                  child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.green))
              : ListView.separated(
                  itemBuilder: (c, i) {
                    var item = allProducts[i];
                    return ListTile(
                        leading: const Icon(Icons.store_mall_directory),
                        title: Text(item['name']),
                        subtitle: Text(item['productCategory']['name']),
                        trailing: Text(
                          item['is_dynamic_pricing']
                              ? '${item['price']}%'
                              : 'NGN ${item['price']}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        onTap: () => initialiseSdk(context,
                            userId: userEmail,
                            productId: item['id'],
                            paymentOption: PaymentOption.gateway));
                  },
                  separatorBuilder: (c, i) => const SizedBox(height: 5),
                  itemCount: allProducts.length),
        ));
  }
}
