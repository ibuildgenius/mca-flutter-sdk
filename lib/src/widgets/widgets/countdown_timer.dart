import 'package:flutter/material.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

// class CountdownTimer extends StatefulWidget {
//   const CountdownTimer({super.key});

//   @override
//   _CountdownTimerState createState() => _CountdownTimerState();
// }

// class _CountdownTimerState extends State<CountdownTimer>
//     with TickerProviderStateMixin {
//   late AnimationController controller;

// Create a GlobalKey
// final countdownTimerKey = GlobalKey<CountdownTimerState>();

class CountdownTimer extends StatefulWidget {
  // final GlobalKey<CountdownTimerState>? timerKey;
  final AnimationController controller;
  final String timerString;
  final Color timerColor;

  const CountdownTimer({
    super.key,
    required this.controller,
    required this.timerString,
    required this.timerColor,
  });

  @override
  CountdownTimerState createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer> {
  String get timerString {
    Duration duration = widget.controller.duration! * widget.controller.value;
    return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Color get timerColor {
    if (widget.controller.value == 0) {
      return CustomColors.blackColor;
    } else if (widget.controller.value > 0.4) {
      return CustomColors.primaryBrandColor();
    } else if (widget.controller.value > 0.33) {
      return CustomColors.lightOrangeBgColor;
    } else {
      return CustomColors.redColor;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: widget.controller,
          builder: (BuildContext context, Widget? child) {
            // controller.reverse(
            //     from: controller.value == 0.0 ? 1.0 : controller.value);
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: const BoxDecoration(
                      color: CustomColors.whiteColor, shape: BoxShape.circle),
                  child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                    valueColor: AlwaysStoppedAnimation(timerColor),
                    value: widget.controller.value,
                    backgroundColor: CustomColors.blackColor.withOpacity(0.05),
                  ),
                ),
                mediumText(timerString,
                    textAlign: TextAlign.center,
                    fontSize: 13,
                    color: timerColor)
              ],
            );
          },
        ),
        const SizedBox(height: 5),
        // ElevatedButton(
        //   onPressed: startTimer,
        //   child: const Text('Start Timer'),
        // ),
      ],
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';

// class CountdownTimer extends StatefulWidget {
//   const CountdownTimer({super.key});

//   @override
//   _CountdownTimerState createState() => _CountdownTimerState();
// }

// class _CountdownTimerState extends State<CountdownTimer>
//     with TickerProviderStateMixin {
//   late AnimationController controller;

//   String get timerString {
//     Duration duration = controller.duration! * controller.value;
//     return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
//   }

//   @override
//   void initState() {
//     super.initState();
//     controller = AnimationController(
//       vsync: this,
//       duration: const Duration(minutes: 5),
//     );
//   }

//   @override
//   // Disposing the AnimationController
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//         animation: controller,
//         builder: (BuildContext context, Widget? child) {
//           // controller.reverse(
//           //     from: controller.value == 0.0 ? 1.0 : controller.value);
//           return AnimatedBuilder(
//               animation: controller,
//               builder: (BuildContext context, Widget? child) {
//                 return Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Container(
//                       height: 40,
//                       width: 40,
//                       decoration: const BoxDecoration(
//                           color: CustomColors.whiteColor,
//                           shape: BoxShape.circle),
//                       child: CircularProgressIndicator(
//                         strokeWidth: 7.0,
//                         valueColor:
//                             const AlwaysStoppedAnimation(CustomColors.redColor),
//                         value: controller.value,
//                         backgroundColor: Colors.transparent,
//                       ),
//                     ),
//                     Text(
//                       timerString,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: CustomColors.redColor),
//                     ),
//                   ],
//                 );
//               });
//         });
//   }
// }
