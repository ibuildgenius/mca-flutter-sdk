import 'package:example/home_screen.dart';
import 'package:flutter/material.dart';
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
      home: const HomeScreen(),
      // )
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var allProducts;
  String userEmail = 'fuhad@mycovergenius.com';
  String publicKey = 'MCAPUBK_TEST|44d8c41c-b436-40f6-bfc9-b0d52f0253bb';

  void _onComplete() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const MyHomePage(title: "title"),
    ));
  }

  @override
  initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Buy product')),
        body: MyCoverAI(
            context: context,
            publicKey:
                "MCAPUBK_TEST|1acf339a-d36f-47e7-8e1b-fd0b76b61b0c", //publicKey,
            email: userEmail,
            // productId: const ["e6b4bca1-b870-4648-8704-11c1802a51d0"],
            form: const {
              'email': "fuhad@mycovergenius.com",
              'first_name': 'Fuhad',
              'last_name': 'Aminu',
              'phone': '08123232332',
            },
            onComplete: _onComplete,
            // reference: "BUY-DRIPDM1713463188225-WR",
            paymentOption: PaymentOption.gateway,
            transactionType: TransactionType.purchase));
  }
}
