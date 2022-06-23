import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  File? _image;
  String productName = '';
  String accountNumber = '';
  String bankName = '';
  String email = '';
  String productId = '';
  String businessId = '';
  String price = '';
  String paymentMethod = '';
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
      productName = productDetail['data']['productDetails'][0]['name'] ?? '';
      businessId = productDetail['data']['businessDetails']['id'] ?? '';
      productId = productDetail['data']['productDetails'][0]['id'] ?? '';
      price = productDetail['data']['productDetails'][0]['price'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return selectBody(bodyType);
  }

  Future<dynamic> showImagePickers(context, {onSelect}) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
            // height: height(context) * 0.3,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  var selectedImage = await openCamera();
                                  if (selectedImage != null) {
                                    setState(() {
                                      _image = selectedImage;
                                    });
                                    print(_image);
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const <Widget>[
                                    Expanded(child: Text("Take a Photo")),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.camera_alt,
                                        size: 25,
                                        color: PRIMARY,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () async {
                                  Navigator.pop(context);

                                  var selectedImage = await openGallery();
                                  if (selectedImage != null) {
                                    setState(() {
                                      // iDImage = selectedImage.path;
                                      _image = selectedImage;
                                    });
                                    print(_image);
                                  }
                                },
                                child: Row(
                                  children: const <Widget>[
                                    Expanded(child: Text("Photo Library")),
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Icon(
                                        Icons.collections,
                                        size: 25,
                                        color: PRIMARY,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 65,
                        decoration: const BoxDecoration(
                            color: WHITE,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: const Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  openCamera() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxHeight: 612,
        maxWidth: 816);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      return file;
    }

    return null;
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
                            itemCount: forms.length,
                            shrinkWrap: true,
                            itemBuilder: (c, i) {
                              var item = forms[i];
                              if (item['data_url'].toString() != 'null') {
                                getList(item['data_url']);
                              }
                              purchaseData['product_id'] = productId;
                              purchaseData['amount'] = price;

                              final controller = _getControllerOf(item['name'],
                                  initValue: getInitialValue(
                                      item['label'].toString()));

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textBoxTitle(item['label']),
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
                                          controller.text = pickedDate
                                              .toString()
                                              .substring(0, 10);
                                          purchaseData[item['name']] =
                                              controller.text;
                                        }
                                      } else if (item['label']
                                          .toString()
                                          .toLowerCase()
                                          .contains('image')) {
                                        var selectedImage = await openGallery();
                                        if (selectedImage != null) {
                                          setState(() {
                                            _image = selectedImage;
                                            controller.text =
                                                _image!.path.toString();
                                          });
                                        }
                                      }
                                    },
                                    child: InputFormField(
                                        controller: controller,
                                        onChanged: (value) {
                                          purchaseData[item['name']] =
                                              controller.text;
                                          if (item['name']
                                              .toString()
                                              .contains('cost')) {
                                            purchaseData['vehicle_cost'] =
                                                double.parse(controller.text);
                                          }
                                        },
                                        enabled: item['data_url'].toString() !=
                                                    'null' ||
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
                                        suffixIcon: item['data_url']
                                                    .toString() !=
                                                'null'
                                            ? const Icon(Icons.expand_more)
                                            : item['label']
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains('date')
                                                ? const Icon(Icons.event_note)
                                                : item['label']
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains('image')
                                                    ? const Icon(Icons.image)
                                                    : const SizedBox.shrink(),
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        keyboardType: TextInputType.text,
                                        validator: (value) =>
                                            FieldValidator.validate(value,
                                                error: item['errorMsg'])

                                        // {
                                        // selectValidator(item['label'],
                                        //     value: value,
                                        //     error: item['errorMsg']);
                                        // }
                                        ),
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
                  // if (_image != null) {
                  if (_formKey.currentState!.validate()) {
                    setState(() => bodyType = 'bank');
                  }
                  // } else {
                  //   Dialogs.showErrorMessage(
                  //       'Kindly select an image to upload');
                  // }
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
      case 'transfer':
        return bankDetailCard();
      case 'ussd':
        return ussdCard();
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
                paymentMethodCard(transfer, 'Transfer',
                    'Send to a bank Account', 'bank transfer'),
                verticalSpace(),
                paymentMethodCard(
                    ussd, 'USSD', 'Select any bank to generate USSD', 'ussd'),
              ],
            )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: button(
                  text: 'Proceed',
                  onTap: () async {
                    if (paymentMethod != '') {
                      purchaseData['product_id'] = productId;
                      purchaseData['email'] = email;
                      uploadImage();
                    } else {
                      Dialogs.showErrorMessage('Select a payment method');
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
                        fontSize: 28,
                        color: DARK,
                        fontWeight: FontWeight.w600)),
                const Text('MyCover.ai',
                    style: TextStyle(
                        fontSize: 25,
                        color: DARK,
                        fontWeight: FontWeight.w600)),
                Text(accountNumber,
                    style: const TextStyle(
                        fontSize: 28,
                        color: DARK,
                        fontWeight: FontWeight.w600)),
              ],
            )),
            const Divider(),
            verticalSpace(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: button(
                  text: 'I have sent the money',
                  onTap: () async {
                    Dialogs.successDialog(
                        context: context, productName: productName);
                  }),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InputFormField(
                    // controller: controller,
                    onChanged: (value) {},
                    hint: 'Search for bank of your choice',
                    prefixIcon: const Icon(Icons.search),
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.text),
                const SizedBox(height: 5),
                const Text('Use below USSD Code to make payment',
                    style: TextStyle(
                        fontSize: 13,
                        color: PRIMARY,
                        fontWeight: FontWeight.w600)),
                verticalSpace(),
                const Divider(),
                verticalSpace(),
                const Text('Access bank',
                    style: TextStyle(
                        fontSize: 20,
                        color: DARK,
                        fontWeight: FontWeight.w400)),
                verticalSpace(),
                const Text('*990*44834839938#',
                    style: TextStyle(
                        fontSize: 28,
                        color: DARK,
                        fontWeight: FontWeight.w600)),
              ],
            )),
            const Divider(),
            verticalSpace(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: button(
                  text: 'I have sent the money',
                  onTap: () async {
                    Dialogs.successDialog(
                        context: context, productName: productName);
                  }),
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

  // a72c4e3c-e868-4782-bb35-df6e3344ae6c

  buyProduct() async {
    Dialogs.showLoading(context: context, text: 'Submitting Purchase');
    var paymentChannel = {
      "channel": paymentMethod,
      "amount": double.parse(purchaseData['amount'])
    };
    if (paymentMethod.contains('ussd')) {
      paymentChannel['bank_code'] = '082';
    }

    var res = await WebServices.buyProduct(
        apiKey: businessId,
        userId: WebServices.userId,
        payload: purchaseData,
        paymentChannel: paymentChannel);
    Navigator.pop(context);
    if (res is String) {
      Dialogs.showErrorMessage(res);
    } else {
      setState(() {
        bodyType = paymentMethod.contains('transfer') ? 'transfer' : 'ussd';
        accountNumber = res['data']['account_number'];
        bankName = res['data']['bank'];
      });
    }
  }

  uploadImage() async {
    Dialogs.showLoading(context: context, text: 'Uploading Image');
    var res = await WebServices.uploadFile(context, businessId, _image!);
    Navigator.pop(context);
    if (res.statusCode.toString() == '200' ||
        res.statusCode.toString() == '201') {
      res.stream.transform(utf8.decoder).listen((value) {
        setState(() {
          var body = jsonDecode(value);
          purchaseData['image'] = body['data']['file_url'];
          buyProduct();
        });
      });
    } else {
      Dialogs.showErrorMessage(res);

      print('Error!');
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
