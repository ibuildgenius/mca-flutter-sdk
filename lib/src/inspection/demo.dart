import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../const.dart';
import '../theme.dart';
import 'camera_screen.dart';
import 'inspection.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen(
      {Key? key,
      required this.email,
      required this.token,
      required this.policyId,
      required this.reference,
      required this.typeOfInspection})
      : super(key: key);
  final String email, token, policyId,reference;
  final InspectionType typeOfInspection;

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  double _opacity = 0;
  bool go = false;
  var details;

  @override
  void initState() {
    boot();
    super.initState();
  }

  boot() async {
    cameras = await availableCameras();
    Future.delayed(const Duration(seconds: 6), () {
      setState(() {
        _opacity = 1.0;
        go = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY,
      body: Stack(
        children: [
          Container(
            width: width(context),
            height: height(context),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                    colors: [PRIMARY, Color(0xFF00897B)])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset('assets/images/BACKGROUND.png',
                    package: 'mca_flutter_sdk',
                    height: height(context) * 0.25),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(48),
                      child: Image.asset('assets/images/hqvdw.gif',
                          width: height(context) * 0.28,
                          package: 'mca_flutter_sdk'),
                    ),
                  ),
                  SizedBox(height: height(context) * 0.04),
                  const Text('Enjoy Seamless Inspection',
                      style: TextStyle(
                          color: WHITE,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                  const SizedBox(height: 7),
                  const Text(
                      'You are about to start the inspection process.\nKindly note that this process has to be\ncompleted at one go in 1 minute (60s)',
                      style: TextStyle(height: 1.2, color: WHITE),
                      textAlign: TextAlign.center),
                  SizedBox(height: height(context) * 0.012),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: AnimatedOpacity(
                            duration: const Duration(seconds: 7),
                            opacity: _opacity,
                            child: InkWell(
                              onTap: () {
                                if (go){
                                  Navigator.pop(context);
                                  Navigator.pop(context);}
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    'Back',
                                    style: TextStyle(
                                        color: WHITE,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: AnimatedOpacity(
                            duration: const Duration(seconds: 7),
                            opacity: _opacity,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InspectionScreen(
                                              token: widget.token,
                                              policyId: widget.policyId,
                                          reference: widget.reference,
                                              typeOfInspection:
                                                  widget.typeOfInspection,
                                            )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: WHITE,
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Padding(
                                  padding: EdgeInsets.all(14),
                                  child: Center(
                                    child: Text(
                                      'Proceed',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: PRIMARY,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
