import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

class CustomToast {
  static void showToastMessage(
      BuildContext context, String message, ToastStatus status) {
    OverlayEntry overlayEntry;
    var duration = const Duration(seconds: 4);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: _buildToastContent(message, duration, status),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay after the duration
    Timer(duration, () {
      overlayEntry.remove();
    });
  }

  static void showErrorMessage(BuildContext context, String message,
      {ToastStatus status = ToastStatus.failed}) {
    message = message.replaceAll('[', '').replaceAll(']', '');
    OverlayEntry overlayEntry;
    const duration = Duration(seconds: 4);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: _buildToastContent(message, duration, status),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay after the duration
    Timer(duration, () {
      overlayEntry.remove();
    });
  }

  static Widget _buildToastContent(
      String message, Duration duration, ToastStatus status) {
    return ToastContent(
      message: message,
      duration: duration,
      status: status,
    );
  }
}

class ToastContent extends StatefulWidget {
  const ToastContent({
    required this.message,
    required this.duration,
    required this.status,
    super.key,
  });
  final String message;
  final Duration duration;
  final ToastStatus status;

  @override
  State<ToastContent> createState() => _ToastContentState();
}

class _ToastContentState extends State<ToastContent> {
  double progress = 1.0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startProgress();
  }

  void startProgress() {
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        progress -= 10 / widget.duration.inMilliseconds;
        if (progress <= 0) {
          progress = 0;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: Container(
        // padding: const EdgeInsets.only(left: 24.0, right: 24, top: 12.0),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: widget.status == ToastStatus.success
              ? CustomColors.toastGreenColor
              : widget.status == ToastStatus.pending
                  ? CustomColors.toastOrangeColor
                  : CustomColors.toastRedColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            verticalSpacer(5),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10.0),
              child: mediumText(
                widget.message,
                fontSize: 14.sp,
                color: CustomColors.whiteColor,
              ),

              //  Text(
              //   widget.message,
              //   style: const TextStyle(
              //     color: Colors.white,
              //     fontSize: 16.0,
              //   ),
              // ),
            ),
            const SizedBox(height: 15.0),
            LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.status == ToastStatus.success
                    ? CustomColors.toastGreenColor.withOpacity(0.7)
                    : widget.status == ToastStatus.pending
                        ? CustomColors.toastOrangeColor.withOpacity(0.7)
                        : CustomColors.toastRedColor.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
