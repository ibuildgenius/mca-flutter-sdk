import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class SelectedImageContainer extends StatelessWidget {
  const SelectedImageContainer({
    super.key,
    required this.imageFile,
    required this.controller,
    this.height,
    this.width,
  });

  final File? imageFile;
  final double? height, width;
  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'imagePreview',
        child: Center(
          child: Container(
            // height: height ?? MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 5),
            ),
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: Image.file(
                imageFile!,
                fit: BoxFit.contain,
              ),
            ),
          ),
        )

        // Container(
        //   height: height ?? MediaQuery.of(context).size.height * 0.7,
        //   // width: width ?? MediaQuery.of(context).size.width * 0.7,
        //   decoration: BoxDecoration(
        //     border: Border.all(color: CustomColors.whiteColor, width: 5),
        //   ),
        //   child: Image.file(
        //     imageFile!,
        //     fit: BoxFit.cover,
        //   ),
        // ),

        // DottedBorder(
        //   strokeWidth: 3,
        //   padding: EdgeInsets.zero,
        //   borderPadding: EdgeInsets.zero,
        //   borderType: BorderType.RRect,
        //   radius: const Radius.circular(8),
        //   dashPattern: const [15, 13],
        //   child: Container(
        //     height: height ?? MediaQuery.of(context).size.height * 0.7,
        //     width: width ?? MediaQuery.of(context).size.width * 0.6,
        //     decoration: BoxDecoration(
        //         border: Border.all(color: CustomColors.whiteColor, width: 5),
        //         borderRadius: BorderRadius.circular(8)),
        //     child: Image.file(
        //       imageFile!,
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        // ),
        );
  }
}
