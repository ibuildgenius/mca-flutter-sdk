import 'package:flutter/material.dart';
import '../const.dart';
import '../theme.dart';
import '../widgets/buttons.dart';

class InspectionSummary extends StatefulWidget {
  const InspectionSummary(
      {Key? key,
      required this.imageList1,
      required this.imageList2,
      required this.imageList3,
      required this.imageList4,
      required this.imageList5,
      required this.imageList6,
      required this.imageList7,
      this.onClose,
      this.onConfirm})
      : super(key: key);
  final imageList1;
  final imageList2;
  final imageList3;
  final imageList4;
  final imageList5;
  final imageList6;
  final imageList7;
  final onClose;
  final onConfirm;

  @override
  _InspectionSummaryState createState() => _InspectionSummaryState();
}

class _InspectionSummaryState extends State<InspectionSummary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: height(context) * 0.1),
            Center(
              child: Image.asset(
                'assets/images/checkout.png',
                width: width(context) * 0.2,
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Completed !',
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      color: PRIMARY),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
              child: Text(
                  'Great! You have Completed \nInspection, would you like \nto submit?',
                  style: TextStyle(height: 1.5, fontSize: 16),
                  textAlign: TextAlign.center),
            ),
            const Text('Preview',
                style: TextStyle(
                    height: 1.5, fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center),
            SizedBox(height: height(context) * 0.1),
            Column(children: [
              Row(
                children: [
                  Expanded(child: widget.imageList1),
                  const SizedBox(width: 15),
                  Expanded(child: widget.imageList2),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: widget.imageList3),
                  const SizedBox(width: 15),
                  Expanded(child: widget.imageList4),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: widget.imageList5),
                  const SizedBox(width: 15),
                  Expanded(child: widget.imageList6),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: widget.imageList7),
                  const SizedBox(width: 15),
                  const Expanded(
                      child: SizedBox(
                    width: 1,
                    height: 3,
                  )),
                ],
              ),
            ]),
            const SizedBox(height: 35),
            Row(
              children: const [
                // smallButton(
                //     text: 'Close',
                //     onTap: widget.onClose,
                //     textColor: PRIMARY_COLOR,
                //     color: WHITE),
                // const SizedBox(width: 20),
                // smallButton(
                //     text: 'Continue',
                //     onTap: widget.onConfirm,
                //     textColor: WHITE,
                //     color: PRIMARY_COLOR),
              ],
            )
          ],
        ),
      ),
    );
  }
}

inspectionSummary(context,
    {imageList1,
    imageList2,
    imageList3,
    imageList4,
    imageList5,
    imageList6,
    imageList7,
    onClose,
    onConfirm}) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      children: [
        SizedBox(height: height(context) * 0.03),
        Center(
          child: Image.asset(
            'assets/images/checkout.png',
            width: width(context) * 0.2,
            package: 'mca_official_flutter_sdk',
          ),
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Completed !',
              style: TextStyle(
                  fontSize: 22.0, fontWeight: FontWeight.w600, color: PRIMARY),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
          child: Text(
              'Great! You have Completed \nInspection, would you like \nto submit?',
              style: TextStyle(height: 1.5, fontSize: 16),
              textAlign: TextAlign.center),
        ),
        const Text('Preview',
            style: TextStyle(
                height: 1.5, fontSize: 20, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center),
        SizedBox(height: height(context) * 0.02),
        Column(children: [
          Row(
            children: [
              Expanded(child: imageList1),
              const SizedBox(width: 15),
              Expanded(child: imageList2),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: imageList3),
              const SizedBox(width: 15),
              Expanded(child: imageList4),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: imageList5),
              const SizedBox(width: 15),
              Expanded(child: imageList6),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: imageList7),
              const SizedBox(width: 15),
              const Expanded(
                  child: SizedBox(
                width: 1,
                height: 3,
              )),
            ],
          ),
        ]),
        const SizedBox(height: 35),
        Row(
          children: [
            Expanded(
                child: closeButton(
                    text: 'Restart',
                    onTap: onClose,
                    color: WHITE)),
            const SizedBox(width: 20),
            Expanded(
                child: successButton(
                    text: 'Continue', onTap: onConfirm, color: PRIMARY)),
          ],
        ),
        const SizedBox(height: 35),
      ],
    ),
  );
}
