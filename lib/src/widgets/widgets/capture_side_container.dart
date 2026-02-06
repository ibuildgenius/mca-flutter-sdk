import 'package:flutter/material.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_colors.dart';

class CaptureSideContainer extends StatelessWidget {
  final void Function()? onTap;
  final bool isLoading;
  const CaptureSideContainer({
    super.key,
    required this.onTap,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.15,
        color: CustomColors.blackColor.withValues(alpha:0.7),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Center(
              child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: CustomColors.whiteColor,
                  width: 4,
                )),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: isLoading
                        ? CustomColors.primaryBrandColor()
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          )

              //  GestureDetector(
              //   onTap: isLoading ? null : onTap,
              //   child: SvgPicture.asset(
              //     isLoading ? ConstantString.cautionIcon : ConstantString.infoIcon,
              //     height: 210,
              //     package: 'mca_official_flutter_sdk',
              //   ),
              // ),
              ),
        ),
      ),
    );
  }
}
