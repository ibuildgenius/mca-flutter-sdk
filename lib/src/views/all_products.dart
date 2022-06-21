import 'package:flutter/material.dart';

import '../../my_cover_sdk.dart';
import '../theme.dart';

class AllProducts extends StatefulWidget {
  const AllProducts( {Key? key,
    required this.productData,
    required this.productId,
    required this.email,
    this.accentColor = PRIMARY,
    this.primaryColor = FILL_GREEN,
    required this.userId})
      : super(key: key);
  final String productId;
  final String userId;
  final String email;
  final productData;
  final primaryColor;
  final accentColor;

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {




  initialiseSdk(context, {productId}) {
    var userId = "olakunle@mycovergenius.com";
    final mycover =
    MyCoverLaunch(context: context, userId: userId, productId: productId??'');
    var res = mycover.charge();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            title: Text('All products'),
          ),
          body: widget.productData == null
              ? const Center(
              child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.green))
              : ListView.separated(
              itemBuilder: (c, i) {
                var item = widget.productData[i];
                return ListTile(
                    title: Text(item['name']),
                    onTap: () =>
                        initialiseSdk(context, productId: item['id']));
              },
              separatorBuilder: (c, i) => const SizedBox(height: 5),
              itemCount: widget.productData.length));
  }
}
