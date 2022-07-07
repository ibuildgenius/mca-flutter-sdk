import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../const.dart';
import '../services/services.dart';
import '../theme.dart';
import '../validator.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/dialogs.dart';
import '../widgets/input.dart';
import 'landing.dart';

class FormScreen extends StatefulWidget {
  const FormScreen(
      {Key? key,
      required this.productDetail,
      required this.userId,
      required this.reference,
      required this.typeOfTransaction,
      required this.email})
      : super(key: key);
  final productDetail;
  final String email;
  final String userId;
  final PurchaseStage? typeOfTransaction;
  final String? reference;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  var productDetail;
  var forms;
  File? _image;
  String searchTerm = '';
  String productName = '';
  String accountNumber = '';
  String? reference = '';
  String ussdCode = '';
  String paymentCode = '';
  String bankName = '';
  String email = '';
  String productId = '';
  String businessId = '';
  String price = '';
  String paymentMethod = '';
  String bankCode = '';
  var purchaseData = {};
  String bodyType = 'form';
  PurchaseStage? stage;
  int initialPage = 0;
  var chunks = [];
  var pageData = [];
  bool enabledUssd = false;
  var vehicleList;
  var yearList;
  var titleList;
  var identityList;
  var stateList;
  var ussdProviders = [];
  var searchList = [];

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    productDetail = widget.productDetail;
    setState(() {
      email = widget.email;
      stage = widget.typeOfTransaction ?? PurchaseStage.payment;
      reference = widget.reference ?? '';
      forms = productDetail['data']['productDetails'][0]['form_fields'];
      productName = productDetail['data']['productDetails'][0]['name'] ?? '';
      businessId = productDetail['data']['businessDetails']['id'] ?? '';
      productId = productDetail['data']['productDetails'][0]['id'] ?? '';
      price = productDetail['data']['productDetails'][0]['price'] ?? '';
      paymentMethod = '';
      if (stage == PurchaseStage.purchase) {
        getPurchaseInfo(false);
      }
      splitList();

      getUssdProvider();
    });
  }

  @override
  Widget build(BuildContext context) {
    return selectBody(bodyType);
  }

  openGallery() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 612,
        maxWidth: 816);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      return file;
    }
    return null;
  }

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

  getUssdProvider() async {
    var response = await WebServices.getUssdProvider();
    if (response is String) {
      log(response);
    } else {
      setState(() {
        ussdProviders = response['data'];
        searchList = ussdProviders;
        bankName = searchList[0]['bank_name'];
        bankCode = searchList[0]['type'];
      });
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

  search() {
    if (searchTerm.isEmpty) {
      setState(() => searchList = ussdProviders);
    }
    if (mounted) {
      setState(() {
        searchList = ussdProviders
            .where((i) => i['bank_name']
                .toString()
                .toLowerCase()
                .replaceAll(' ', '')
                .contains(searchTerm.toLowerCase().replaceAll(' ', '')))
            .toList();
      });
    }
  }

  void openUssdProvider() => showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (_) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            decoration: BoxDecoration(
                color: WHITE, borderRadius: BorderRadius.circular(15)),
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                InputFormField(
                    padding: 10.0,
                    onChanged: (value) {
                      searchTerm = value;
                      search();
                    },
                    hint: 'Search for bank of your choice',
                    prefixIcon: const Icon(Icons.search),
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text),
                Expanded(
                    child: ListView.builder(
                        itemCount: searchList.length,
                        shrinkWrap: true,
                        itemBuilder: (c, i) {
                          var item = searchList[i];
                          return ListTile(
                            title: Text(item['bank_name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16)),
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                bankName = item['bank_name'];
                                bankCode = item['type'];
                              });
                            },
                          );
                        })),
              ],
            ),
          );
        },
      );

  getInitialValue(String title) {
    if (title.toLowerCase().contains('email')) {
      return email;
    } else if (title.toLowerCase().contains('product')) {
      return productId;
    } else {
      return '';
    }
  }

  Widget inputBody() {
    return Expanded(
        child: Container(
      decoration:
          BoxDecoration(color: WHITE, borderRadius: BorderRadius.circular(5)),
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
                            itemCount: 1,
                            shrinkWrap: true,
                            itemBuilder: (c, i) {
                              return form(pageData);
                            }),
                      ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: button(
                text: 'Get Covered',
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    if (initialPage < (chunks.length - 1)) {
                      initialPage++;
                      setState(() => pageData = chunks[initialPage]);
                    }
                    //
                    else {
                      if (stage == PurchaseStage.payment) {
                        setState(() => bodyType = 'bank');
                      } else {
                        uploadImage();
                      }
                    }
                  }
                }),
          ),
          getProductName(productName),
        ],
      ),
    ));
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              decoration: BoxDecoration(
                  color: WHITE, borderRadius: BorderRadius.circular(15)),
              height: MediaQuery.of(context).size.height * 0.45,
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  void splitList() {
    if (forms.isNotEmpty) {
      var paymentList = forms.where((i) => i['show_first'] == true).toList();
      var purchaseList = forms.where((i) => i['show_first'] != true).toList();
      List lst = stage == PurchaseStage.payment ? paymentList : purchaseList;
      int chunkSize = 4;
      for (var i = 0; i < lst.length; i += chunkSize) {
        chunks.add(lst.sublist(
            i, i + chunkSize > lst.length ? lst.length : i + chunkSize));
      }
      setState(() => pageData = chunks[initialPage]);
    } else {
      pageData = [];
    }
  }

  form(data) {
    return ListView.separated(
        separatorBuilder: (c, i) => smallVerticalSpace(),
        itemCount: data.length,
        shrinkWrap: true,
        itemBuilder: (c, i) {
          var item = data[i];
          if (item['data_url'].toString() != 'null') {
            getList(item['data_url']);
          }
          purchaseData['product_id'] = productId;
          purchaseData['amount'] = price;

          final controller = _getControllerOf(item['name'],
              initValue: getInitialValue(item['label'].toString()));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textBoxTitle(item['label']),
              InkWell(
                onTap: () async {
                  if (item['data_url'].toString() != 'null') {
                    var listItem;
                    if (item['data_url'].toString().contains('title')) {
                      listItem = titleList;
                    }
                    if (item['data_url'].toString().contains('state')) {
                      listItem = stateList;
                    }
                    if (item['data_url'].toString().contains('identity')) {
                      listItem = identityList;
                    }
                    if (item['data_url'].toString().contains('category')) {
                      listItem = vehicleList;
                    }
                    if (item['data_url'].toString().contains('year')) {
                      listItem = yearList;
                    }
                    if (listItem != null) {
                      pickItem(listItem, item['label'], onSelect: (value) {
                        Navigator.pop(context);
                        controller.text = value;
                        purchaseData[item['name']] = controller.text;
                      });
                    }
                  } else if (item['label']
                      .toString()
                      .toLowerCase()
                      .contains('date')) {
                    _showDialog(CupertinoDatePicker(
                      initialDateTime: DateTime.now(),
                      mode: CupertinoDatePickerMode.date,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() {
                          controller.text = newDate.toString().substring(0, 10);
                          purchaseData[item['name']] = controller.text;
                        });
                      },
                    ));
                  } else if (item['label']
                      .toString()
                      .toLowerCase()
                      .contains('image')) {
                    var selectedImage = await openGallery();
                    if (selectedImage != null) {
                      setState(() {
                        _image = selectedImage;
                        controller.text = _image!.path.toString();
                      });
                    }
                  }
                },
                child: InputFormField(
                    controller: controller,
                    onChanged: (value) {
                      purchaseData[item['name']] = controller.text;
                      if (item['name'].toString().contains('cost')) {
                        purchaseData['vehicle_cost'] =
                            double.parse(controller.text);
                      }
                      if (item['name'].toString().contains('email')) {
                        purchaseData['vehicle_cost'] =
                            double.parse(controller.text);
                        email = controller.text;
                      }
                    },
                    keyboardType: (item['label']
                                .toString()
                                .toLowerCase()
                                .contains('phone') ||
                            item['label']
                                .toString()
                                .toLowerCase()
                                .contains('cost') ||
                            item['label']
                                .toString()
                                .toLowerCase()
                                .contains('price') ||
                            item['label']
                                .toString()
                                .toLowerCase()
                                .contains('bvn'))
                        ? TextInputType.phone
                        : TextInputType.text,
                    textCapitalization: item['label']
                            .toString()
                            .toLowerCase()
                            .contains('number')
                        ? TextCapitalization.characters
                        : TextCapitalization.sentences,
                    inputFormatters: <TextInputFormatter>[
                      (item['label']
                                  .toString()
                                  .toLowerCase()
                                  .contains('phone') ||
                              item['label']
                                  .toString()
                                  .toLowerCase()
                                  .contains('cost') ||
                              item['label']
                                  .toString()
                                  .toLowerCase()
                                  .contains('price') ||
                              item['label']
                                  .toString()
                                  .toLowerCase()
                                  .contains('bvn'))
                          ? FilteringTextInputFormatter.digitsOnly
                          : FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z0-9. ]'))
                    ],
                    enabled: item['data_url'].toString() != 'null' ||
                            item['label']
                                .toString()
                                .toLowerCase()
                                .contains('date') ||
                            item['label']
                                .toString()
                                .toLowerCase()
                                .contains('image')
                        ? false
                        : true,
                    hint: item['description'],
                    prefixIcon: item['label']
                            .toString()
                            .toLowerCase()
                            .contains('image')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 10),
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      border: Border.all(color: GREY)),
                                  child: const Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Text(
                                      'Select Image',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  )),
                              const SizedBox(width: 10),
                            ],
                          )
                        : null,
                    suffixIcon: item['data_url'].toString() != 'null'
                        ? const Icon(Icons.expand_more)
                        : item['label']
                                .toString()
                                .toLowerCase()
                                .contains('date')
                            ? const Icon(Icons.event_note)
                            : null,
                    validator: (value) {
                      var label = item['label'].toString().toLowerCase();
                      if (label.contains('phone')) {
                        return PhoneNumberValidator.validate(value,
                            error: item['errorMsg']);
                      } else if (label.contains('email')) {
                        return EmailValidator.validate(value,
                            error: item['errorMsg']);
                      } else if (label.contains('bvn')) {
                        return BVNValidator.validate(value,
                            error: item['errorMsg']);
                      } else {
                        return FieldValidator.validate(value,
                            error: item['errorMsg']);
                      }
                    }),
              ),
            ],
          );
        });
  }

  selectBody(bodyType) {
    switch (bodyType) {
      case 'form':
        return inputBody();
      case 'bank':
        return payment();
      case 'transfer':
        return bankDetailCard();
      case 'ussd':
        return ussdCard();
    }
  }

  payment() {
    return Expanded(
      child: Container(
        decoration:
            BoxDecoration(color: WHITE, borderRadius: BorderRadius.circular(5)),
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
                          text: productDetail['data']['productDetails'][0]
                                  ['is_dynamic_pricing']
                              ? '$price%'
                              : 'NGN$price',
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
            paymentMethod == 'ussd' && enabledUssd
                ? Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: openUssdProvider,
                        child: const InputFormField(
                            enabled: false,
                            hint: 'Search for bank of your choice',
                            prefixIcon: Icon(Icons.search),
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.text),
                      ),
                      const SizedBox(height: 5),
                      const Text('You want to make payment with USSD',
                          style: TextStyle(
                              fontSize: 13,
                              color: PRIMARY,
                              fontWeight: FontWeight.w600)),
                      verticalSpace(),
                      const Divider(),
                      verticalSpace(),
                      Text(bankName,
                          style: const TextStyle(
                              fontSize: 23,
                              color: DARK,
                              fontWeight: FontWeight.w600)),
                      Text('CODE - $bankCode',
                          style: const TextStyle(
                              fontSize: 20,
                              color: DARK,
                              fontWeight: FontWeight.w400)),
                      verticalSpace(),
                    ],
                  ))
                : Expanded(
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
                      paymentMethodCard(transfer, 'Transfer',
                          'Send to a bank Account', 'bank transfer'),
                      verticalSpace(),
                      paymentMethodCard(ussd, 'USSD',
                          'Select any bank to generate USSD', 'ussd'),
                    ],
                  )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: button(
                  text: 'Proceed',
                  onTap: () async {
                    if (stage == PurchaseStage.payment) {
                      if (paymentMethod != '') {
                        purchaseData['product_id'] = productId;
                        if (paymentMethod == 'ussd' && !enabledUssd) {
                          setState(() => enabledUssd = true);
                        } else {
                          makePayment();
                        }
                      } else {
                        Dialogs.showErrorMessage('Select a payment method');
                      }
                    } else {
                      uploadImage();
                    }
                  }),
            ),
            Center(child: getProductName(productName)),
          ],
        ),
      ),
    );
  }

  bankDetailCard() {
    return Expanded(
      child: Container(
        decoration:
            BoxDecoration(color: WHITE, borderRadius: BorderRadius.circular(5)),
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
                          text: productDetail['data']['productDetails'][0]
                                  ['is_dynamic_pricing']
                              ? '$price%'
                              : 'NGN$price',
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                const Text('Send to the Account No. below',
                    style: TextStyle(
                        fontSize: 13,
                        color: PRIMARY,
                        fontWeight: FontWeight.w600)),
                verticalSpace(),
                const Divider(),
                verticalSpace(),
                Text(bankName,
                    style: const TextStyle(
                        fontSize: 25,
                        color: DARK,
                        fontWeight: FontWeight.w600)),
                const Text('MyCover.ai',
                    style: TextStyle(
                        fontSize: 25,
                        color: DARK,
                        fontWeight: FontWeight.w600)),
                verticalSpace(height: 10.0),
                Text(accountNumber,
                    style: const TextStyle(
                        fontSize: 28,
                        color: DARK,
                        fontWeight: FontWeight.w700)),
                verticalSpace(),
                const Divider(),
              ],
            )),
            const Divider(),
            verticalSpace(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: button(
                  text: 'I have sent the money',
                  onTap: () => verifyPayment(true)),
            ),
            Center(child: getProductName(productName)),
          ],
        ),
      ),
    );
  }

  ussdCard() {
    return Expanded(
      child: Container(
        decoration:
            BoxDecoration(color: WHITE, borderRadius: BorderRadius.circular(5)),
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
                          text: productDetail['data']['productDetails'][0]
                                  ['is_dynamic_pricing']
                              ? '$price%'
                              : 'NGN$price',
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                const Text('Use below USSD Code to make payment',
                    style: TextStyle(
                        fontSize: 13,
                        color: PRIMARY,
                        fontWeight: FontWeight.w600)),
                verticalSpace(),
                const Divider(),
                verticalSpace(),
                Text(bankName,
                    style: const TextStyle(
                        fontSize: 20,
                        color: DARK,
                        fontWeight: FontWeight.w600)),
                Text('CODE - $paymentCode',
                    style: const TextStyle(
                        fontSize: 20,
                        color: DARK,
                        fontWeight: FontWeight.w600)),
                verticalSpace(),
                Text(ussdCode,
                    style: const TextStyle(
                        fontSize: 28,
                        color: DARK,
                        fontWeight: FontWeight.w700)),
                verticalSpace(),
                const Divider(),
              ],
            )),
            const Divider(),
            verticalSpace(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: button(
                  text: 'I have sent the money',
                  onTap: () => verifyPayment(true)),
            ),
            Center(child: getProductName(productName)),
          ],
        ),
      ),
    );
  }

  Widget paymentMethodCard(image, title, subtitle, value) {
    return InkWell(
      onTap: () => setState(() => paymentMethod = value),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: paymentMethod == value
                ? Border.all(color: PRIMARY, width: 1.5)
                : Border.all(color: GREY.withOpacity(0.2), width: 0.7)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
          child: Row(
            children: [
              Image.asset(image,
                  height: 45, fit: BoxFit.fitWidth, package: 'mca_flutter_sdk'),
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
                    Text(subtitle,
                        style: const TextStyle(fontSize: 12, color: DARK)),
                  ],
                ),
              ),
              Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                    color: WHITE,
                    shape: BoxShape.circle,
                    border: paymentMethod == value
                        ? Border.all(color: PRIMARY, width: 4)
                        : Border.all(color: GREY, width: 1)),
              )
            ],
          ),
        ),
      ),
    );
  }

  makePayment() async {
    Dialogs.showLoading(context: context, text: 'Submitting Payment');
    var paymentChannel = {
      "channel": paymentMethod,
      "amount": double.parse(purchaseData['amount'])
    };
    if (paymentMethod.contains('ussd')) {
      paymentChannel['bank_code'] = bankCode;
    }

    if (purchaseData['email'] == null || purchaseData['email'] == '') {
      purchaseData['email'] = email;
    }
    var res = await WebServices.initiatePurchase(
        businessId: businessId,
        userId: widget.userId,
        payload: purchaseData,
        paymentChannel: paymentChannel);

    Navigator.pop(context);
    if (res is String) {
      Dialogs.showErrorMessage(res);
    } else {
      setState(() {
        if (paymentMethod.contains('transfer')) {
          bodyType = 'transfer';
          accountNumber = res['data']['account_number'];
          bankName = res['data']['bank'];
          reference = res['data']['reference'];
        }
        if (paymentMethod.contains('ussd')) {
          bodyType = 'ussd';
          ussdCode = res['data']['ussd_code'];
          paymentCode = res['data']['payment_code'];
          reference = res['data']['reference'];
        }
      });
    }
  }

  completePurchase() async {
    Dialogs.showLoading(context: context, text: 'Submitting Purchase');

    var res = await WebServices.completePurchase(
        businessId: businessId,
        userId: widget.userId,
        payload: purchaseData,
        reference: reference);

    Navigator.pop(context);
    if (res is String) {
      Dialogs.showErrorMessage(res);
    } else {
      Dialogs.successDialog(
          context: context,
          title: 'Purchase Successful',
          message:
              'You have just purchased \n$productName,\nKindly Check your email\nto complete your activation',
          productName: productName,
          onTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          });
    }
  }

  verifyPayment(showLoading) async {
    if (showLoading) {
      Dialogs.showLoading(context: context, text: 'Verifying Payment');
    }

    var res = await WebServices.verifyPayment(reference!, businessId);
    if (res is String) {
      if (res.contains('retry') || res.contains('failed')) {
        Future.delayed(const Duration(seconds: 20), () => verifyPayment(false));
      } else {
        Navigator.pop(context);

        Dialogs.failedDialog(context: context);
      }
    } else {
      Dialogs.successDialog(
          context: context,
          productName: productName,
          reference: reference,
          isContinue: true,
          onTap: () {
            Navigator.pop(context);
            getPurchaseInfo(true);
          });
    }
  }

  getPurchaseInfo(isLoading) async {
    var res = await WebServices.getPurchaseInfo(businessId, reference);

    if (res is String) {
      Navigator.pop(context);

      Dialogs.failedDialog(context: context);
    } else {
      if (isLoading) {
        Navigator.pop(context);
      }

      setState(() {
        stage = PurchaseStage.purchase;
        purchaseData['amount'] = res['data']['amount'];
        purchaseData['vehicle_category'] = res['data']['vehicle_category'];
        purchaseData['date_of_birth'] = res['data']['date_of_birth'];
        purchaseData['phone_number'] = res['data']['phone_number'];
        purchaseData['last_name'] = res['data']['last_name'];
        purchaseData['first_name'] = res['data']['first_name'];
        purchaseData['email'] = res['data']['email'];
        initialPage = 0;
        chunks = [];
        pageData = [];
        splitList();
        bodyType = 'form';
      });
    }
  }

  uploadImage() async {
    if (_image != null) {
      Dialogs.showLoading(context: context, text: 'Uploading Image');
      var res = await WebServices.uploadFile(context, businessId, _image!);
      Navigator.pop(context);
      if (res.statusCode.toString() == '200' ||
          res.statusCode.toString() == '201') {
        res.stream.transform(utf8.decoder).listen((value) {
          setState(() {
            var body = jsonDecode(value);
            purchaseData['image'] = body['data']['file_url'];
            purchaseData['identification_url'] = body['data']['file_url'];
            completePurchase();
          });
        });
      } else {
        Dialogs.showErrorMessage(res);
      }
    } else {
      completePurchase();
    }
  }
}
