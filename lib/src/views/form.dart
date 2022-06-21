import 'dart:developer';

import 'package:flutter/material.dart';

import '../services/services.dart';
import '../theme.dart';
import '../validator.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/dialogs.dart';
import '../widgets/input.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key, required this.productDetail}) : super(key: key);
  final productDetail;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  var productDetail;
  var forms;
  String productName = '';
  String businessId = '';
  var purchaseData = {};

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    productDetail = widget.productDetail;
    setState(() {
      forms = productDetail['data']['productDetails'][0]['form_fields'];
      log('form length ${forms.length}');
      productName = productDetail['data']['productDetails'][0]['name'] ?? '';
      log('Product name $productName');

      businessId = productDetail['data']['businessDetails']['id'] ?? '';
      log('Business ID $businessId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return inputBody();
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

  TextEditingController _getControllerOf(String name) {
    var controller = _controllerMap[name];
    if (controller == null) {
      controller = TextEditingController(text: '');
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
                                  title: Text(
                                      title.contains('designation')
                                          ? list[i]['name']
                                          : list[i],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16)),
                                  onTap: () => onSelect(
                                      title.contains('designation')
                                          ? list[i]['name']
                                          : list[i]),
                                ))),
                  ),
                ),
              ],
            )));
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

                              final controller = _getControllerOf(item['name']);

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
                                          });
                                        }
                                      } else if (item['label']
                                          .toString()
                                          .toLowerCase()
                                          .contains('date')) {
                                        var pickedDate =
                                            await selectDate(context);
                                        print(pickedDate.toString());

                                        if (pickedDate != null) {
                                          controller.text =
                                              pickedDate.toString();
                                        }
                                      }
                                    },
                                    child: InputFormField(
                                        controller: controller,
                                        onChanged: (value) {
                                          print(controller.text);
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
                  print(purchaseData);
                  buyProduct();
                }),
          ),
          getProductName(productName),
        ],
      ),
    ));
  }

  buyProduct() async {
    Dialogs.showLoading(context: context, text: 'Submitting Purchase');

    var res = await WebServices.buyProduct(
        apiKey: businessId, userId: WebServices.userId, payload: purchaseData);
    Navigator.pop(context);
    if (res is String) {
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
