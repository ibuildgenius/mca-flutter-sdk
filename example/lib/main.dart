import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          // const ContentForm()
          const MyHomePage(title: 'MyCover SDK Test'),
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
  String userEmail = 'dami@mycovergenius.com';
  String publicKey = 'MCAPUBK_TEST|48c01008-5f01-4705-b63f-e71ef5fc974f';

  initialiseSdk(context, {productId}) async {
    final myCover = MyCoverAI(
        context: context,
        publicKey: publicKey,
        email: userEmail,
        productId: [productId],
        form: {
          'email': userEmail,
          'name': '',
          'phone': ''
        },
        paymentOption: PaymentOption.gateway,
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
    getAllProducts();
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

  getAllProducts() async {
    var data = {"payment_option": 'gateway', "action": "purchase"};

    try {
      var res = await makePostRequest(
          apiUrl: productUrl, data: data, token: publicKey);

      print("Server Responded with $res");

      print(res.body);

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
        appBar: AppBar(title: const Text('Buy product')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
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
                              subtitle: Text(item['name']),
                              trailing: Text(
                                item['is_dynamic_pricing']
                                    ? '${item['price']}%'
                                    : 'NGN ${item['price']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              onTap: () => initialiseSdk(context,
                                  productId: item['id']));
                        },
                        separatorBuilder: (c, i) => const SizedBox(height: 5),
                        itemCount: allProducts.length),
              ),
            ],
          ),
        ));
  }
}

class ContentForm extends StatefulWidget {
  const ContentForm({Key? key}) : super(key: key);

  @override
  State<ContentForm> createState() => _ContentFormState();
}

class _ContentFormState extends State<ContentForm> {
  var contentFormField = <Widget>[];
  final contentTitleController = <TextEditingController>[];
  final contentDescController = <TextEditingController>[];

  Widget contentFormCard() {
    var _contentTitleController = TextEditingController();
    contentTitleController.add(_contentTitleController);
    var _contentDescController = TextEditingController();
    contentDescController.add(_contentDescController);

    return Row(
      children: [
        Expanded(
          child: InputFormField(
            label: "Object",
            controller: _contentTitleController,
            // validator: (value) => FieldValidator.validate(value),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InputFormField(
            label: "How many",
            controller: _contentDescController,
            // validator: (value) => FieldValidator.validate(value),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    contentFormField.add(contentFormCard());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Scrollbar(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: contentFormField.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              Expanded(child: contentFormField[index]),
                              const SizedBox(width: 5),
                              if (contentFormField.length > 1)
                                InkWell(
                                  onTap: () {
                                    contentFormField.removeAt(index);
                                    setState(() {});
                                  },
                                  child: const Icon(Icons.remove_circle,
                                      size: 20, color: Colors.red),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 8,
                      child: InkWell(
                        onTap: () => setState(
                            () => contentFormField.add(contentFormCard())),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(3)),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
                              child: Row(
                                children: const [
                                  Icon(Icons.add_circle,
                                      size: 15, color: Colors.white),
                                  Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Text(
                                        'Add Item',
                                        style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      )),
                                ],
                              ),
                            )),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputFormField extends StatelessWidget {
  const InputFormField({
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.obscure = false,
    this.onChanged,
    this.enabled = true,
    this.controller,
    this.label,
    this.hint,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.padding,
    this.keyboardType,
    this.maxLength,
    this.inputFormatters,
  });

  final suffixIcon;
  final prefixIcon;
  final onChanged;
  final validator;
  final enabled;
  final controller;
  final obscure;
  final label;
  final hint;
  final padding;
  final textCapitalization;
  final keyboardType;
  final inputFormatters;
  final maxLines;
  final maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 12),
      child: TextFormField(
        buildCounter: (context,
                {required currentLength, required isFocused, maxLength}) =>
            null,
        inputFormatters: inputFormatters,
        enabled: enabled,
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        validator: validator,
        onChanged: onChanged,
        obscureText: obscure,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          filled: true,
          border: InputBorder.none,
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
          disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.redAccent, width: 0.3),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          labelText: label,
          hintText: hint,
          contentPadding:
              EdgeInsets.symmetric(vertical: padding ?? 15.0, horizontal: 15.0),
        ),
      ),
    );
  }
}
