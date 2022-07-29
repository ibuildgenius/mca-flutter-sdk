import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../mca_flutter_sdk.dart';
import '../const.dart';
import '../services/services.dart';
import '../theme.dart';
import '../validator.dart';
import '../widgets/buttons.dart';
import '../widgets/common.dart';
import '../widgets/dialogs.dart';
import '../widgets/input.dart';

//inspectable

class FormScreen extends StatefulWidget {
  const FormScreen(
      {Key? key,
      required this.productDetail,
      required this.instanceId,
      required this.form,
      required this.reference,
      required this.inspectable,
      required this.email,
      required this.publicKey,
      required this.paymentOption})
      : super(key: key);
  final productDetail;
  final form;
  final String instanceId;
  final String email;
  final String publicKey;
  final bool inspectable;
  final PaymentOption? paymentOption;
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
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String productName = '';
  String accountNumber = '';
  String? reference = '';
  String ussdCode = '';
  String paymentCode = '';
  String bankName = '';
  String productId = '';
  String businessId = '';
  String price = '';
  String paymentMethod = '';
  String bankCode = '';
  var purchaseData = {};
  String bodyType = 'form';
  PaymentOption? paymentOption;
  PurchaseStage? stage;
  int initialPage = 0;
  double _opacity = 0;
  var chunks = [];
  var pageData = [];
  bool enabledUssd = false;
  bool go = false;
  var identityList, titleList, stateList, yearList, vehicleList, genderList;

  var ussdProviders = [];
  var searchList = [];

  @override
  void initState() {
    setData();
    Future.delayed(const Duration(seconds: 6), () {
      setState(() {
        _opacity = 1.0;
        go = true;
      });
    });

    super.initState();
  }

  setData() {
    productDetail = widget.productDetail;
    setState(() {
      paymentOption = widget.paymentOption;
      reference = widget.reference ?? '';
      forms = productDetail['data']['productDetails'][0]['form_fields'];
      productName = productDetail['data']['productDetails'][0]['name'] ?? '';
      businessId = productDetail['data']['businessDetails']['id'] ?? '';
      productId = productDetail['data']['productDetails'][0]['id'] ?? '';
      price = productDetail['data']['productDetails'][0]['price'] ?? '';
      email = widget.email;

      paymentMethod = '';
      if (widget.form != null) {
        var inputForm = widget.form;
        phone = inputForm['phone'] ?? '';
        var name = inputForm['name'] ?? '';
        firstName = name.split(' ').first;
        lastName = name.split(' ')[1];
      }

      if (paymentOption == PaymentOption.gateway && reference != '') {
        stage = PurchaseStage.purchase;
        getPurchaseInfo(false);
      } else {
        stage = PurchaseStage.payment;
      }

      splitList();

      getUssdProvider();
    });
  }

  @override
  Widget build(BuildContext context) {
    return selectBody(bodyType);
  }

  initialiseSdk(context) {
    final mycover = MyCoverAI(
        context: context,
        form: widget.form,
        productId: [productId],
        publicKey: '2aa4f6ec-0111-42f4-88f9-466c7ef41727',
        paymentOption: widget.paymentOption,
        reference: reference,
        transactionType: TransactionType.inspection,
        email: widget.email);
    mycover.initialise();
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

  getList(url, {listName}) async {
    if (url != null) {
      var response = await WebServices.getListData(url, widget.publicKey);
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
      if (response['responseText']
          .toString()
          .toLowerCase()
          .contains('gender')) {
        genderList = response['data'];
      }
    }
  }

  getUssdProvider() async {
    var response = await WebServices.getUssdProvider(widget.publicKey);
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
    } else if (title.toLowerCase().contains('first') &&
        title.toLowerCase().contains('name')) {
      return firstName;
    } else if (title.toLowerCase().contains('last') &&
        title.toLowerCase().contains('name')) {
      return lastName;
    } else if (title.toLowerCase().contains('phone')) {
      return phone;
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
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState!.validate()) {
                    if (initialPage < (chunks.length - 1)) {
                      initialPage++;
                      setState(() => pageData = chunks[initialPage]);
                    } else {
                      if (stage == PurchaseStage.payment &&
                          paymentOption == PaymentOption.gateway) {
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
      forms.sort((a, b) => (b['position'] < a['position'] ? 1 : 0));

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
                    if (item['data_url']
                        .toString()
                        .toLowerCase()
                        .contains('gender')) {
                      listItem = genderList;
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
                        email = controller.text;
                      }
                      if (item['name'].toString().contains('first_name')) {
                        firstName = controller.text;
                      }
                      if (item['name'].toString().contains('phone')) {
                        phone = controller.text;
                      }
                      if (item['name'].toString().contains('last_name')) {
                        lastName = controller.text;
                      }
                      if (item['data_type'] == 'number') {
                        if (controller.text.isNotEmpty) {
                          purchaseData['payment_plan'] =
                              int.parse(controller.text);
                        }
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
                            item['data_type']
                                .toString()
                                .toLowerCase()
                                .contains('number') ||
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
                          : FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))
                    ],
                    enabled: item['data_url'].toString() != 'null' ||
                            item['label']
                                .toString()
                                .toLowerCase()
                                .contains('date') ||
                            item['label']
                                .toString()
                                .toLowerCase()
                                .contains('image') ||
                            item['label']
                                .toString()
                                .toLowerCase()
                                .contains('product')
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
                        : item['label'].toString().toLowerCase().contains('date')
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
        child: SingleChildScrollView(
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
                  ? Column(
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
                    )
                  : Column(
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
                    ),
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
              child:  AnimatedOpacity(
                duration: const Duration(seconds: 7),
                opacity: _opacity,
                child: button(
                    text: 'I have sent the money',
                    onTap: () => verifyPayment(true)),
              ),
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
    var paymentChannel;
    var debitWalletReference;
    if (paymentOption == PaymentOption.gateway) {
      paymentChannel = {
        "channel": paymentMethod,
        "amount": double.parse(purchaseData['amount'])
      };
      if (paymentMethod.contains('ussd')) {
        paymentChannel['bank_code'] = bankCode;
      }
    } else {
      debitWalletReference = widget.reference;
    }
    if (purchaseData['email'] == null || purchaseData['email'] == '') {
      purchaseData['email'] = email;
    }
    if (purchaseData['first_name'] == null ||
        purchaseData['first_name'] == '') {
      purchaseData['first_name'] = firstName;
    }
    if (purchaseData['last_name'] == null || purchaseData['last_name'] == '') {
      purchaseData['last_name'] = lastName;
    }
    if (purchaseData['phone_number'] == null ||
        purchaseData['phone_number'] == '') {
      purchaseData['phone_number'] = phone;
    }
    if (purchaseData['phone'] == null || purchaseData['phone'] == '') {
      purchaseData['phone'] = phone;
      purchaseData['phone'] = phone;
    }
    var res = await WebServices.initiatePurchase(
        publicKey: widget.publicKey,
        businessId: businessId,
        instanceId: widget.instanceId,
        payload: purchaseData,
        debitWalletReference: debitWalletReference,
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

  // getInspectionInfo
  completePurchase() async {
    print('======>');
    Dialogs.showLoading(context: context, text: 'Submitting Purchase');

    if (purchaseData['title'] == null || purchaseData['title'] == '') {
      purchaseData['title'] = 'Chief';
    }

    var res = await WebServices.completePurchase(
        businessId: businessId,
        publicKey: widget.publicKey,
        payload: purchaseData,
        reference: reference);

    Navigator.pop(context);
    if (res is String) {
      Dialogs.showErrorMessage(res);
    } else {
      Dialogs.successDialog(
          context: context,
          title: 'Purchase Successful',
          message: !widget.inspectable
              ? 'You have just purchased \n$productName,\nKindly Check your email\nfor purchase detail'
              : 'You have just purchased \n$productName,\nContinue to inspection',
          productName: productName,
          isContinue: widget.inspectable ? true : false,
          onCancel: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          onTap: () {
            Navigator.pop(context);
            if (widget.inspectable) {
              initialiseSdk(context);
            } else {
              Navigator.pop(context);
            }
          });
    }
  }

  verifyPayment(showLoading) async {
    if (showLoading) {
      Dialogs.showLoading(context: context, text: 'Verifying Payment');
    }
    var res = await WebServices.verifyPayment(
        reference!, businessId, widget.publicKey);
    if (res is String) {
      if (res.contains('retry') ||
          res.contains('failed') ||
          res.contains('error')||
          res.toLowerCase().contains('format')) {
        Future.delayed(const Duration(seconds: 15), () => verifyPayment(false));
      } else {
        Navigator.pop(context);

        Dialogs.failedDialog(context: context, message: res);
      }
    } else {
      Dialogs.successDialog(
          context: context,
          message:
              'You paid for $productName\nKindly Continue to complete your purchase',
          onTap: () {
            Navigator.pop(context);
            getPurchaseInfo(true);
          });
    }
  }

  getPurchaseInfo(isLoading) async {
    var res = await WebServices.getPurchaseInfo(
        businessId, reference, widget.publicKey);
    if (res is String) {
      Navigator.pop(context);

      Dialogs.failedDialog(context: context);
    } else if (res['responseText'] == 'purchase has been completed' ||
        res['data'].isEmpty) {
      Navigator.pop(context);
      Dialogs.showErrorMessage(res['responseText']);
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
        purchaseData['phone'] = res['data']['phone'];
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
      var res = await WebServices.uploadFile(
          context, businessId, _image!, widget.publicKey);

      Navigator.pop(context);
      if (res.statusCode.toString() == '200' ||
          res.statusCode.toString() == '201') {
        res.stream.transform(utf8.decoder).listen((value) {
          setState(() {
            var body = jsonDecode(value);
            purchaseData['image'] = body['data']['file_url'];
            purchaseData['identification_url'] = body['data']['file_url'];
            purchaseData['image_url'] = body['data']['file_url'];
            completePurchase();
          });
        });
      } else {
        res.stream.transform(utf8.decoder).listen((value) {
          var body = jsonDecode(value);
          print(body['responseText']);
          Dialogs.showErrorMessage(res.reas);

        });
      }
    } else {
      completePurchase();
    }
  }
}
