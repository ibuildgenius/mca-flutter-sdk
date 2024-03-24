import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mca_official_flutter_sdk/src/utils/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/utils/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/common.dart';
import 'package:mca_official_flutter_sdk/src/widgets/search_form.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../mca_official_flutter_sdk.dart';
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
      required this.prefixList,
      required this.form})
      : super(key: key);
  final String publicKey;
  final String email;
  final List<String> prefixList;
  final productData;
  final form;
  final PaymentOption? paymentOption;
  final String? reference;

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  final searchController = TextEditingController();

  int selectedIndex = 0;

  var searchList;

  initialiseSdk(context, productId) {
    final mycover = MyCoverAIInitializer(
        context: context,
        form: widget.form,
        productId: [productId],
        publicKey: widget.publicKey,
        paymentOption: widget.paymentOption,
        reference: widget.reference,
        transactionType: TransactionType.purchase,
        email: widget.email);
    runZonedGuarded(() async {
      await Sentry.init(
        (options) {
          options.dsn =
              'https://b38daa0de05c465a9425719e8dccc46c@o1144473.ingest.sentry.io/6617317';
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
        backgroundColor: CustomColors.bgWhiteColor,
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
                              shape: BoxShape.circle,
                              color: RED.withOpacity(0.2)),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.close, color: RED, size: 15),
                          )),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Product Page",
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: CustomColors.deepBlueTextColor,
                      ),
                    ),
                  ),
                  verticalSpacer(15),
                  SearchFormField(
                      padding: 15.0,
                      onChanged: (value) => search(value),
                      hint: 'Search Products',
                      prefixIcon: SizedBox(
                        height: 20,
                        width: 20,
                        child: Center(
                          child: SvgPicture.asset(
                            ConstantString.searchIcon,
                            height: 15,
                            width: 15,
                            package: 'mca_official_flutter_sdk',
                          ),
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.prefixList.length,
                        itemBuilder: (content, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                    if ((widget.prefixList[index])
                                            .toLowerCase() ==
                                        "all") {
                                      searchList = widget.productData;
                                    } else {
                                      searchList = widget.productData
                                          .where((i) => (i['prefix']
                                              .toString()
                                              .toLowerCase()
                                              .replaceAll(' ', '')
                                              .contains(
                                                  (widget.prefixList[index])
                                                      .toLowerCase()
                                                      .replaceAll(' ', ''))))
                                          .toList();
                                    }
                                  });
                                },
                                child: Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 71),
                                  height: 28,
                                  // width: 71,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: selectedIndex == index
                                          ? CustomColors.greenColor
                                          : CustomColors.whiteColor,
                                      border: Border.all(
                                        color: CustomColors.searchBorderColor,
                                      )),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Text(
                                        widget.prefixList[index],
                                        style: GoogleFonts.spaceGrotesk(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: selectedIndex == index
                                              ? CustomColors.whiteColor
                                              : CustomColors.filterTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  verticalSpacer(15),
                  Expanded(
                    child: searchList == null
                        ? const Center(
                            child: CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.green))
                        : ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (c, i) {
                              var item = searchList[i];
                              print(item);
                              print("----->");
                              return GestureDetector(
                                onTap: () => initialiseSdk(context, item['id']),
                                child: Container(
                                    // height: 70,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: CustomColors.blackColor
                                              .withOpacity(
                                                  0.11), // Set the shadow color
                                          spreadRadius:
                                              2, // Spread less on left and right
                                          blurRadius: 7, // Set the blur radius
                                          offset: const Offset(0,
                                              5), // More offset on the bottom
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 15),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                              getImages(item['productCategory']
                                                  ['name']),
                                              height: 40,
                                              width: 40,
                                              package:
                                                  'mca_official_flutter_sdk'),
                                          horizontalSpacer(10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item['name'],
                                                  style:
                                                      GoogleFonts.spaceGrotesk(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: CustomColors
                                                              .gray700Color),
                                                ),
                                                verticalSpacer(10),
                                                Row(
                                                  children: [
                                                    Text(
                                                      item['prefix'],
                                                      style: GoogleFonts
                                                          .spaceGrotesk(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: CustomColors
                                                                  .filterTextColor),
                                                    ),
                                                    horizontalSpacer(5),
                                                    getLogo(item['prefix'])
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          horizontalSpacer(5),
                                          Text(
                                            item['is_dynamic_pricing']
                                                ? '${_formatPrice(item['price'])}%'
                                                : '₦ ${_formatPrice(item['price'])}',
                                            style: GoogleFonts.spaceGrotesk(
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    CustomColors.gray700Color,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ) // Your child widget goes here
                                    ),
                              );
                            },
                            separatorBuilder: (c, i) =>
                                const SizedBox(height: 20),
                            itemCount: searchList.length),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  String _formatPrice(String priceString) {
    double price = double.tryParse(priceString) ?? 0.0;
    String formattedPrice = price.toStringAsFixed(2);

    if (formattedPrice.endsWith('.00')) {
      return formattedPrice.substring(
          0, formattedPrice.length - 3); // Remove the '.00'
    } else {
      return formattedPrice;
    }
  }
}
