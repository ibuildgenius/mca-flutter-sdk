import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/inspection_view_model.dart';
import 'package:mca_official_flutter_sdk/src/screens/inspection/vehicle/vehicle_inspection_summary.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';
import 'package:mca_official_flutter_sdk/src/utils/enum.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_button.dart';
import 'package:mca_official_flutter_sdk/src/widgets/powered_by_footer.dart';
import 'package:video_compress/video_compress.dart';

class GadgetInspectionSummaryScreen extends StatefulHookConsumerWidget {
  final XFile videoFile;
  static const routeName = '/GadgetInspectionSummaryScreen';
  const GadgetInspectionSummaryScreen({
    super.key,
    required this.videoFile,
  });

  @override
  ConsumerState<GadgetInspectionSummaryScreen> createState() =>
      _GadgetInspectionSummaryScreenState();
}

class _GadgetInspectionSummaryScreenState
    extends ConsumerState<GadgetInspectionSummaryScreen> {
  late Subscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = VideoCompress.compressProgress$.subscribe((progress) {
  
      ref.read(progressProvider.notifier).state = progress;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    final inspectionVM = ref.watch(inspectionVmProvider);
    final progress = ref.watch(progressProvider);
    return PopScope(
      canPop: false,
      child: Scaffold(
        // backgroundColor: CustomColors.whiteColor,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          verticalSpacer(40),
                          semiBoldText("Inspection Summary", fontSize: 20),
                          verticalSpacer(20),
                          regularText(
                              "See below the summary of your inspection",
                              fontSize: 14,
                              textAlign: TextAlign.center),
                          verticalSpacer(30),
                          Row(
                            children: [
                              InspectionSummaryContainer(
                                ref: ref,
                                sideName: "front",
                                imageProvider: gadgetImageProvider,
                                inspectionType: InspectionType.gadget,
                              ),
                              horizontalSpacer(10),
                              InspectionSummaryContainer(
                                ref: ref,
                                sideName: "back",
                                imageProvider: gadgetImageProvider,
                                inspectionType: InspectionType.gadget,
                              ),
                            ],
                          ),
                          verticalSpacer(20),
                          Row(
                            children: [
                              InspectionSummaryContainer(
                                ref: ref,
                                sideName: "side",
                                imageProvider: gadgetImageProvider,
                                inspectionType: InspectionType.gadget,
                              ),
                              horizontalSpacer(10),
                              InspectionSummaryContainer(
                                ref: ref,
                                sideName: "settings",
                                imageProvider: gadgetImageProvider,
                                inspectionType: InspectionType.gadget,
                              ),
                            ],
                          ),
                          verticalSpacer(20),
                          verticalSpacer(15),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          ref.watch(showProgressProvider)
                              ? SizedBox(
                                  // height: MediaQuery.of(context).size.height,
                                  // color: CustomColors.blackColor.withOpacity(0.4),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        semiBoldText(
                                            'Progress: ${progress.toInt()}%',
                                            color: CustomColors
                                                .primaryBrandColor(),
                                            fontSize: 14),
                                        const SizedBox(height: 20),
                                        LinearProgressIndicator(
                                          value: progress / 100,
                                          minHeight: 10,
                                          color:
                                              CustomColors.primaryBrandColor(),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          CustomButton(
                            title: "Submit Inspection",
                            isLoading: inspectionVM.isLoading,
                            onTap: () {
                              File file = File(widget.videoFile.path);
                              inspectionVM.uploadGadgetVideo(
                                ref: ref,
                                context: context,
                                videoFile: file,
                              );
                            },
                          ),
                          verticalSpacer(15),
                          const PoweredByFooter()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class InspectionSummaryContainer extends StatelessWidget {
//   final WidgetRef ref;
//   final String sideName;
//   const InspectionSummaryContainer({
//     super.key,
//     required this.ref,
//     required this.sideName,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//         child: Container(
//       height: 150,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           border: Border.all(
//             color: CustomColors.productBorderColor,
//             width: 0.4,
//           )),
//       child: Column(
//         children: [
//           SizedBox(
//             height: 120,
//             width: double.infinity,
//             child: ref.watch(vehicleImageProvider)[sideName] == null
//                 ? Container()
//                 : Image.file(
//                     ref.watch(vehicleImageProvider)[sideName]!,
//                     fit: BoxFit.cover,
//                   ),
//           ),
//           verticalSpacer(5),
//           RichText(
//             text: TextSpan(
//               children: [
//                 TextSpan(
//                   text: "Vehicle ",
//                   style: CustomTextStyles.regular(
//                     fontSize: 14,
//                     color: CustomColors.greyTextColor,
//                   ),
//                 ),
//                 TextSpan(
//                   text: getInspectionSummaryName(sideName),
//                   style: CustomTextStyles.w500(
//                     fontSize: 14,
//                     color: CustomColors.primaryBrandColor(),
//                   ),
//                 ),
//                 TextSpan(
//                   text: sideName == 'vin' ? " number" : " view",
//                   style: CustomTextStyles.regular(
//                     fontSize: 14,
//                     color: CustomColors.greyTextColor,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ));
//   }
// }

// final progressProvider = StateProvider<double>((ref) => 0);
// final showProgressProvider = StateProvider<bool>((ref) => false);
