import 'package:flutter/material.dart';
import '../const.dart';
import '../widgets/buttons.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({Key? key}) : super(key: key);

  @override
  _CompletedScreenState createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: height(context) * 0.1),
            Image.asset(
              'assets/images/completed.png',
              width: width(context) * 0.8,
            ),
            const SizedBox(height: 20),
            const Text('Great job',
                style: TextStyle(
                    height: 1.5, fontSize: 24, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
            const Text(
                'Thank you for completing inspection process. Verification is on the way! This may take 2 to 7 working days.',
                style: TextStyle(height: 1.5, fontSize: 16),
                textAlign: TextAlign.center),
            SizedBox(height: height(context) * 0.1),
            button(
                text: 'Go Home',
                onTap: () {
                  // Get.offAll(() => HomeNavigationBar(page: 0));
                })
          ],
        ),
      ),
    );
  }
}
