import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/utils/spacers.dart';
import 'package:mca_official_flutter_sdk/src/widgets/custom_text_widget.dart';

void showPrivacyPolicyBottomSheet(
  BuildContext context, {
  required String title,
  String? okText,
  String? cancelText,
  Color? iconColor,
  Widget? customIcon,
  Function()? onOkPressed,
  Function()? onCancelPressed,
  bool isDismissible = true,
  bool enableDrag = true,
  bool showButton = false,
}) {
  showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      // scrollControlDisabledMaxHeightRatio: 300,
      // barrierColor: Colors.white,

      context: context,
      builder: (context) {
        return PopScope(
          canPop: isDismissible ? false : true,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
          },
          child: LayoutBuilder(builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height *
                    0.8, // max height constraint
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    verticalSpacer(30.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          semiBoldText(title, fontSize: 16.sp),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: SvgPicture.asset(
                              ConstantString.xMark,
                              package: 'mca_official_flutter_sdk',
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpacer(30.h),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              regularText(
                                "Wherever the name \"MyCover.ai\" is used in this policy, it implies one or more of the following MyCoverGenius Ltd subsidiaries, which may offer products or services on the website. Further details can be found on the respective company's website.",
                                fontSize: 15.sp,
                              ),
                              verticalSpacer(20.sp),
                              regularText(
                                "MyCoverGenius Ltd trading as \"Cover Genius\" is a private company limited by shares and registered with the Corporate Affairs Commission, with RC No. 1918634",
                                fontSize: 15.sp,
                              ),
                              verticalSpacer(30.sp),
                              semiBoldText("Information Collection And Use",
                                  fontSize: 16.sp),
                              verticalSpacer(10.sp),
                              regularText(
                                "This Data Privacy Policy stipulates the basis for the collection, use and disclosure of personal information from users of the website by MyCoverGenius Ltd and its subsidiaries in line with applicable data protection laws. Personal Data comprises all the details we hold or collect on our employees, customers, stakeholders vendors and other interested parties, directly or indirectly and includes any offline or online data that makes a person identifiable such as names, addresses, phone numbers, passport ID, usernames, passwords, digital footprints, photographs, financial data, assets and liabilities, insurance, savings and investments, health and high-risk information about products and services purchased from us (which are all collectively referred to as “Personal Information”. This information may be received from third parties or collected using our website(s), mobile app and other digital channels. We use your personal information only for providing services to you and for improving the website. By using the website, you agree to the collection and use of information in accordance with this policy. By abiding by this policy, we gather, store and handle data fairly, transparently and with respect towards individual rights. For the purposes of this Privacy Policy, references to \"we\" or \"us\" shall refer to MyCover.ai and its entities/subsidiaries.",
                                fontSize: 15.sp,
                              ),
                              verticalSpacer(5.sp),
                              regularText(
                                "The Personal Data you provide to us is:",
                                fontSize: 15.sp,
                              ),
                              verticalSpacer(5.sp),
                              const PrivacyDotContainer(
                                title:
                                    "processed fairly, lawfully and in a transparent manner;",
                              ),
                              const PrivacyDotContainer(
                                title:
                                    "collected for a specific purpose and is not processed in a way which is incompatible with the purpose which MyCover.ai collected it;",
                              ),
                              const PrivacyDotContainer(
                                title:
                                    "adequate, relevant and limited to what is necessary in relation to the purposes for which it is processed;",
                              ),
                              const PrivacyDotContainer(
                                title:
                                    "kept accurate, secure and, where necessary kept up to date;",
                              ),
                              const PrivacyDotContainer(
                                title:
                                    "kept no longer than is necessary for the purposes for which the Personal Data is processed;",
                              ),
                              const PrivacyDotContainer(
                                title:
                                    "processed in accordance with your rights;",
                              ),
                              verticalSpacer(10),
                              regularText(
                                "We will only transfer your Personal Data to another country or an international organization outside the European Economic Area where we have taken the required steps to ensure that your Personal Data is protected. Such steps may include placing the party we are transferring information to under contractual obligations to protect it to adequate standards; MyCover.ai and its subsidiaries will not sell your Personal Data and we also will not permit the selling of customer data by any companies who provide a service to us.",
                                fontSize: 15.sp,
                              ),
                              semiBoldText("Collection Of Personal Data?",
                                  fontSize: 16.sp),
                              verticalSpacer(10.sp),
                              regularText(
                                "We collect Personal Data: directly from you;",
                                fontSize: 15.sp,
                              ),
                              verticalSpacer(10.sp),
                              const PrivacyDotContainer(
                                title:
                                    "via enquiry, registration, claim forms, feedback forms and forums;",
                              ),
                              const PrivacyDotContainer(
                                title:
                                    "when you purchase any of our products or services;",
                              ),
                              const PrivacyDotContainer(
                                title:
                                    "when you fill out a survey, or vote in a poll on our website;",
                              ),
                              const PrivacyDotContainer(
                                title: "through quotes and application forms;",
                              ),
                              const PrivacyDotContainer(
                                title:
                                    "via cookies. You can find out more about this in our cookies policy;",
                              ),
                              const PrivacyDotContainer(
                                title:
                                    "via our telephone calls with you, which may be recorded;",
                              ),
                              const PrivacyDotContainer(
                                title: "via live chat, chatbot and profilers;",
                              ),
                              const PrivacyDotContainer(
                                title: "through web analytics tags;",
                              ),
                              const PrivacyDotContainer(
                                title:
                                    "From several different sources including:",
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 25.0),
                                child: Column(
                                  children: [
                                    PrivacyDotContainer(
                                      title:
                                          "directly from an individual or employer who has a policy with us under which you are insured, for example you are a named driver on your partner's motor insurance policy;",
                                    ),
                                    PrivacyDotContainer(
                                      title:
                                          "directly from an employer which funds a Health Insurance policy that we administer where you are a beneficiary;",
                                    ),
                                    PrivacyDotContainer(
                                      title:
                                          "from social media, when fraud is suspected; and",
                                    ),
                                    PrivacyDotContainer(
                                      title: "Other third parties including:",
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 25.0),
                                      child: Column(
                                        children: [
                                          PrivacyDotContainer(
                                            title:
                                                "your family members where you may be incapacitated or unable to provide information relevant to your policy;",
                                          ),
                                          PrivacyDotContainer(
                                            title:
                                                "contractors, consultants, business partners who sell our products and services via their platforms and channels",
                                          ),
                                          PrivacyDotContainer(
                                            title:
                                                "medical professionals and hospitals;",
                                          ),
                                          PrivacyDotContainer(
                                            title:
                                                "third parties such as companies who provide consumer classification for marketing purposes e.g. market segmentation data.",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // verticalSpacer(30.h),
                    // verticalSpacer(20),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20.w),
                    //   child: Row(
                    //     children: [
                    //       // Expanded(
                    //       //   flex: 1,
                    //       //   child: CustomButton(
                    //       //     title: "Go back",
                    //       //     buttonColor: CustomColors.dividerGreyColor,
                    //       //     textColor: CustomColors.backTextColor,
                    //       //     fontSize: 14.sp,
                    //       //     onTap: () {
                    //       //       Navigator.pop(context);
                    //       //     },
                    //       //   ),
                    //       // ),
                    //       // horizontalSpacer(10.w),
                    //       Expanded(
                    //         flex: 2,
                    //         child: CustomButton(
                    //           title: "Accept",
                    //           onTap: () {},
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    verticalSpacer(MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
            );
          }),
        );
      });
}

class PrivacyDotContainer extends StatelessWidget {
  final String title;
  final Widget? titleChild;
  const PrivacyDotContainer({
    super.key,
    required this.title,
    this.titleChild,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0, left: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Icon(
              Icons.circle,
              size: 6,
            ),
          ),
          horizontalSpacer(6),
          Expanded(
            child: titleChild ??
                regularText(
                  title,
                  fontSize: 15,
                ),
          ),
        ],
      ),
    );
  }
}
