import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../mca_flutter_sdk.dart';
import '../const.dart';
import '../theme.dart';
import '../widgets/input.dart';

class AllProducts extends StatefulWidget {
  const AllProducts(
      {Key? key,
      required this.productData,
      required this.reference,
      required this.paymentOption,
      required this.publicKey,
      required this.email,
      required this.form})
      : super(key: key);
  final String publicKey;
  final String email;
  final productData;
  final form;
  final PaymentOption? paymentOption;
  final String? reference;

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  final searchController = TextEditingController();
  var searchList;

  initialiseSdk(context, productId) {
    final mycover = MyCoverAI(
        context: context,
        form: widget.form,
        productId: [productId],
        publicKey: '2aa4f6ec-0111-42f4-88f9-466c7ef41727',
        paymentOption: widget.paymentOption,
        reference: widget.reference, transactionType: TransactionType.purchase, email: widget.email);
    runZonedGuarded(() async {
      await Sentry.init(
            (options) {
              options.dsn = 'https://b38daa0de05c465a9425719e8dccc46c@o1144473.ingest.sentry.io/6617317';
              // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
              // We recommend adjusting this value in production.
              options.tracesSampleRate = 0.5;
        },
      );
      // Init your App.
      mycover.initialise();
    }, (exception, stackTrace) async {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    });
  }

  getImages(String category) {
    if (category.toLowerCase().contains('auto') ||
        category.toLowerCase().contains('life')) {
      return auto;
    } else if (category.toLowerCase().contains('health')) {
      return health;
    } else if (category.toLowerCase().contains('travel')) {
      return travel;
    } else if (category.toLowerCase().contains('gadget') ||
        category.toLowerCase().contains('home') |
            category.toLowerCase().contains('content')) {
      return gadget;
    } else {
      return auto;
    }
  }

  search(searchTerm) {
    if (searchTerm.isEmpty) {
      setState(() => searchList = widget.productData);
    }
    if (mounted) {
      setState(() {
        searchList = widget.productData
            .where((i) => (i['productCategory']['name']
                    .toString()
                    .toLowerCase()
                    .replaceAll(' ', '')
                    .contains(searchTerm.toLowerCase().replaceAll(' ', '')) ||
                i['description']
                    .toString()
                    .toLowerCase()
                    .replaceAll(' ', '')
                    .contains(searchTerm.toLowerCase().replaceAll(' ', '')) ||
                i['prefix']
                    .toString()
                    .toLowerCase()
                    .replaceAll(' ', '')
                    .contains(searchTerm.toLowerCase().replaceAll(' ', '')) ||
                i['name']
                    .toString()
                    .toLowerCase()
                    .replaceAll(' ', '')
                    .contains(searchTerm.toLowerCase().replaceAll(' ', ''))))
            .toList();
      });
    }
  }

  @override
  void initState() {
    searchList = widget.productData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: RED.withOpacity(0.2)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.close, color: RED, size: 15),
                      )),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: GREEN.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(3)),
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text('Select a product to buy',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                ),
              ),
              const SizedBox(height: 8),
              InputFormField(
                  padding: 10.0,
                  onChanged: (value) => search(value),
                  hint: 'Search product by name, category and description',
                  prefixIcon: const Icon(Icons.search),
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text),
              Expanded(
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: searchList == null
                      ? const Center(
                          child: CircularProgressIndicator.adaptive(
                              backgroundColor: Colors.green))
                      : ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (c, i) {
                            var item = searchList[i];
                            return ListTile(
                                leading: Image.asset(
                                    getImages(item['productCategory']['name']),
                                    height: 40,
                                    width: 40,
                                    package: 'mca_flutter_sdk'),
                                title: Text(item['name']),
                                trailing: Text(
                                    item['is_dynamic_pricing']
                                        ? '${item['price']}%'
                                        : 'NGN ${item['price']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: DARK)),
                                subtitle: Text(item['productCategory']['name']),
                                onTap: () =>
                                    initialiseSdk(context, item['id']));
                          },
                          separatorBuilder: (c, i) => const SizedBox(height: 5),
                          itemCount: searchList.length),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
