import 'package:flutter/material.dart';

import '../../my_cover_sdk.dart';
import '../const.dart';
import '../theme.dart';
import '../widgets/input.dart';

class AllProducts extends StatefulWidget {
  const AllProducts(
      {Key? key,
      required this.productData,
      this.accentColor = PRIMARY,
      this.primaryColor = FILL_GREEN,
      required this.userId})
      : super(key: key);
  final String userId;
  final productData;
  final primaryColor;
  final accentColor;

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  initialiseSdk(context, {productId}) {
    final mycover =
        MyCoverAI(context: context, userId: widget.userId, productId: productId ?? '');
    var res = mycover.initialise();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
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
                // controller: controller,
                onChanged: (value) {},
                hint: 'Search product',
                prefixIcon: const Icon(Icons.search),
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text),
            Expanded(
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: widget.productData == null
                    ? const Center(
                        child: CircularProgressIndicator.adaptive(
                            backgroundColor: Colors.green))
                    : ListView.separated(
                        itemBuilder: (c, i) {
                          var item = widget.productData[i];
                          return ListTile(
                              leading: Image.asset(
                                  getImages(item['productCategory']['name']),
                                  height: 40,
                                  width: 40,
                                  package: 'my_cover_sdk'),
                              title: Text(item['name']),
                              trailing: Text(
                                'NGN ${item['price']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: DARK),
                              ),
                              subtitle: Text(item['productCategory']['name']),
                              onTap: () => initialiseSdk(context,
                                  productId: item['id']));
                        },
                        separatorBuilder: (c, i) => const SizedBox(height: 5),
                        itemCount: widget.productData.length),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
