import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LandscapeModeWrapper extends StatefulWidget {
  final Widget child;

  const LandscapeModeWrapper({super.key, required this.child});

  @override
  State<LandscapeModeWrapper> createState() => _LandscapeModeWrapperState();
}

class _LandscapeModeWrapperState extends State<LandscapeModeWrapper> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
