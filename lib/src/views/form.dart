import 'dart:developer';

import 'package:flutter/material.dart';

import '../const.dart';
import '../services/services.dart';
import '../theme.dart';
import '../validator.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/dialogs.dart';
import '../widgets/input.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key, required this.productDetail, this.email})
      : super(key: key);
  final productDetail;
  final email;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  var productDetail;
  var forms;
  String productName = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String productId = '';
  String businessId = '';
  String price = '';
  var purchaseData = {};
  String bodyType = 'form';

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    productDetail = widget.productDetail;
    setState(() {
      email = widget.email;
      forms = productDetail['data']['productDetails'][0]['form_fields'];
      log('form length ${forms.length}');
      productName = productDetail['data']['productDetails'][0]['name'] ?? '';
      log('Product name $productName');

      businessId = productDetail['data']['businessDetails']['id'] ?? '';
      productId = productDetail['data']['productDetails'][0]['id'] ?? '';
      price = productDetail['data']['productDetails'][0]['price'] ?? '';
      var name =
          productDetail['data']['businessDetails']['business_name'] ?? '';
      firstName = name.toString().split(' ')[0];
      if (name.split(' ').length > 1) {
        lastName = name.toString().split(' ')[1];
      }
      log('Price $price');
      log('Product ID $productId');
      log('Lastname $lastName');
      log('Firstname $firstName');
      log('Email $email');
      log('Product ID $productId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return selectBody(bodyType);
  }

  var vehicleList;
  var yearList;
  var titleList;
  var identityList;
  var stateList;

  getList(url) async {
    var response = await WebServices.getListData(url);
    if (response['responseText']
        .toString()
        .toLowerCase()
        .contains('vehicle category')) {
      vehicleList = response['data'];
    }
    if (response['responseText'].toString().toLowerCase().contains('state')) {
      stateList = response['data'];
    }
    if (response['responseText'].toString().toLowerCase().contains('title')) {
      titleList = response['data'];
      print(titleList);
    }
    if (response['responseText'].toString().toLowerCase().contains('year')) {
      yearList = response['data'];
    }
    if (response['responseText']
        .toString()
        .toLowerCase()
        .contains('identity')) {
      identityList = response['data'];
    }
  }

  final Map<String, TextEditingController> _controllerMap = Map();

  TextEditingController _getControllerOf(String name, {initValue}) {
    var controller = _controllerMap[name];
    if (controller == null) {
      controller = TextEditingController(text: initValue ?? '');
      _controllerMap[name] = controller;
    }
    return controller;
  }

  void pickItem(list, title, {onSelect}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            decoration: BoxDecoration(
                color: WHITE, borderRadius: BorderRadius.circular(15)),
            height: MediaQuery.of(context).size.height * 0.45,
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text('$title',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16))),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                        children: List.generate(
                            list.length,
                            (i) => ListTile(
                                  title: Text(list[i],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16)),
                                  onTap: () => onSelect(list[i]),
                                ))),
                  ),
                ),
              ],
            )));
  }

  getInitialValue(String title) {
    if (title.toLowerCase().contains('email')) {
      return email;
    } else if (title.toLowerCase().contains('product')) {
      return productId;
    } else if (title.toLowerCase().contains('first name')) {
      return firstName;
    } else if (title.toLowerCase().contains('last name')) {
      return lastName;
    } else {
      return '';
    }
  }

  Widget inputBody() {
    return Expanded(
        child: Container(
      color: WHITE,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Column(
        children: [
          verticalSpace(),
          Container(
            decoration: BoxDecoration(
                color: GREEN.withOpacity(0.05),
                borderRadius: BorderRadius.circular(3)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Row(
                children: const [
                  Icon(Icons.info, color: GREEN),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                        'Enter details as it appear on legal documents.',
                        style: TextStyle(fontSize: 12)),
                  )
                ],
              ),
            ),
          ),
          verticalSpace(),
          Expanded(
            child: productDetail == null
                ? const Center(child: CircularProgressIndicator.adaptive())
                : forms == null
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : Form(
                        key: _formKey,
                        child: ListView.separated(
                            separatorBuilder: (c, i) => smallVerticalSpace(),
                            itemCount: forms.length,
                            shrinkWrap: true,
                            itemBuilder: (c, i) {
                              var item = forms[i];
                              if (item['data_url'].toString() != 'null') {
                                getList(item['data_url']);
                              }

                              final controller = _getControllerOf(item['name'],
                                  initValue: getInitialValue(
                                      item['label'].toString()));

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textBoxTitle(item['description']),
                                  InkWell(
                                    onTap: () async {
                                      if (item['data_url'].toString() !=
                                          'null') {
                                        var listItem;
                                        if (item['data_url']
                                            .toString()
                                            .contains('title')) {
                                          listItem = titleList;
                                        }
                                        if (item['data_url']
                                            .toString()
                                            .contains('state')) {
                                          listItem = stateList;
                                        }
                                        if (item['data_url']
                                            .toString()
                                            .contains('identity')) {
                                          listItem = identityList;
                                        }
                                        if (item['data_url']
                                            .toString()
                                            .contains('category')) {
                                          listItem = vehicleList;
                                        }
                                        if (item['data_url']
                                            .toString()
                                            .contains('year')) {
                                          listItem = yearList;
                                        }
                                        if (listItem != null) {
                                          pickItem(listItem, item['label'],
                                              onSelect: (value) {
                                            Navigator.pop(context);
                                            controller.text = value;
                                            purchaseData[item['name']] =
                                                controller.text;
                                          });
                                        }
                                      } else if (item['label']
                                          .toString()
                                          .toLowerCase()
                                          .contains('date')) {
                                        var pickedDate =
                                            await selectDate(context);

                                        if (pickedDate != null) {
                                          controller.text =
                                              pickedDate.toString();
                                        }
                                      }
                                    },
                                    child: InputFormField(
                                        controller: controller,
                                        onChanged: (value) {
                                          purchaseData[item['name']] =
                                              controller.text;
                                        },
                                        enabled: item['data_url'].toString() !=
                                                    'null' ||
                                                item['label']
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains('date')
                                            ? false
                                            : true,
                                        hint: item['label'],
                                        suffixIcon: item['data_url']
                                                    .toString() !=
                                                'null'
                                            ? const Icon(Icons.expand_more)
                                            : item['label']
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains('date')
                                                ? const Icon(Icons.event_note)
                                                : const SizedBox.shrink(),
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          selectValidator(item['label'],
                                              value: value,
                                              error: item['errorMsg']);
                                        }),
                                  ),
                                ],
                              );
                            }),
                      ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: button(
                text: 'Get Covered',
                onTap: () async {
                  setState(() => bodyType = 'bank');
                }),
          ),
          getProductName(productName),
        ],
      ),
    ));
  }

  selectBody(bodyType) {
    switch (bodyType) {
      case 'form':
        return inputBody();
      case 'bank':
        return payment();
    }
  }

  payment() {
    return Expanded(
      child: Container(
        color: WHITE,
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            verticalSpace(),
            Container(
              decoration: BoxDecoration(
                  color: GREEN.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(3)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(email, style: const TextStyle(fontSize: 12)),
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: 'Pay ',
                          style: TextStyle(fontSize: 12, color: DARK)),
                      TextSpan(
                          text: 'NGN$price',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: PRIMARY))
                    ]))
                  ],
                ),
              ),
            ),
            verticalSpace(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Select Payment method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 5),
                const Text('Choose an option to proceed',
                    style: TextStyle(fontSize: 12, color: DARK)),
                verticalSpace(),
                paymentMethodCard(transfer, 'Transfer'),
                verticalSpace(),
                paymentMethodCard(ussd, 'USSD'),
              ],
            )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: button(
                  text: 'Proceed',
                  onTap: () async {
                    buyProduct();
                  }),
            ),
            Center(child: getProductName(productName)),
          ],
        ),
      ),
    );
  }

  Container paymentMethodCard(image, title) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: GREY.withOpacity(0.3))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
        child: Row(
          children: [
            Image.asset(image,
                height: 45, fit: BoxFit.fitWidth, package: 'my_cover_sdk'),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 3),
                  const Text('Send to a bank',
                      style: TextStyle(fontSize: 12, color: DARK)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // a72c4e3c-e868-4782-bb35-df6e3344ae6c
  buyProduct() async {
    Dialogs.showLoading(context: context, text: 'Submitting Purchase');

    var res = await WebServices.buyProduct(
        apiKey: businessId, userId: WebServices.userId, payload: purchaseData);
    Navigator.pop(context);
    if (res is String) {
      Dialogs.failedDialog(context: context);
    } else {
      Dialogs.successDialog(context: context, productName: productName);
    }
  }

  selectValidator(type, {value, error}) {
    if (type.contains('phone')) {
      return PhoneNumberValidator.validate(value, error: error);
    } else if (type.contains('phone')) {
      EmailValidator.validate(value, error: error);
    } else {
      FieldValidator.validate(value, error: error);
    }
  }
}
