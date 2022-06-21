import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_cover_sdk/my_cover_sdk.dart';

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
      home: const MyHomePage(title: 'Mycover SDK Test'),
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

  initialiseSdk(context, {productId}) {
    var userId = "olakunle@mycovergenius.com";
    final mycover =
        MyCoverLaunch(context: context, userId: userId, productId: productId??'');
    var res = mycover.charge();
  }

  @override
  initState() {
    getAllProducts();
    super.initState();
  }

  static makePostRequest({apiUrl, data, apiKey}) async {
    final uri = Uri.parse(apiUrl);
    final jsonString = json.encode(data);
    print(data);
    print(apiUrl);
    print(apiKey);

    var headers;
    if (apiKey == null) {
      headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
      };
    } else {
      headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        'x-api-id': '$apiKey',
      };
    }
    return await http.post(uri, body: jsonString, headers: headers);
  }

  static const String productUrl =
      'https://staging.api.mycover.ai/v1/sdk/initialize';

  getAllProducts() async {
    var data = {
      "client_id": 'olakunle@mycovergenius.com',
    };
    try {
      var res = await makePostRequest(apiUrl: productUrl, data: data);
      if (res.statusCode! >= 200 && res.statusCode < 300) {
        var body = jsonDecode(res.body);
        setState(() => allProducts = body['data']['productDetails']);
      }else{
        print('Errororororoor CHUCKS oooooooooooo');
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('All products'),
        ),
        body: allProducts == null
            ? const Center(
                child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.green))
            : ListView.separated(
                itemBuilder: (c, i) {
                  var item = allProducts[i];
                  return ListTile(
                      title: Text(item['name']),
                      onTap: () =>
                          initialiseSdk(context));
                },
                separatorBuilder: (c, i) => const SizedBox(height: 5),
                itemCount: allProducts.length));
  }
}
