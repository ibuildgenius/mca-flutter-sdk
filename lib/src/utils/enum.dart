import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';

enum SdkOptions {
  buy,
  renew,
  manage,
  claim,
}

List<String> getBounceTextName(dynamic step) {
  switch (step) {
    case CarVerificationStep.frontSidePreCapture:
    case CarVerificationStep.frontSideCapture:
    case CarVerificationStep.frontSideVerify:
    case CarVerificationStep.frontSideFailed:
      return ["Ensure to capture the ", 'bumper and windshield'];

    case CarVerificationStep.chasisNumberPreCapture:
    case CarVerificationStep.chasisNumberCapture:
    case CarVerificationStep.chasisNumberVerify:
    case CarVerificationStep.chasisNumberFailed:
      return ["Check ", "driver's side door"];

    case CarVerificationStep.leftSidePreCapture:
    case CarVerificationStep.leftSideCapture:
    case CarVerificationStep.leftSideVerify:
    case CarVerificationStep.leftSideFailed:
      return ["Snap from the ", "driver's side"];
    case CarVerificationStep.backSidePreCapture:
    case CarVerificationStep.backSideCapture:
    case CarVerificationStep.backSideVerify:
    case CarVerificationStep.backSideFailed:
      return ["", ""];

    case CarVerificationStep.rightSidePreCapture:
    case CarVerificationStep.rightSideCapture:
    case CarVerificationStep.rightSideVerify:
    case CarVerificationStep.rightSideFailed:
      return ["Snap from the ", "passenger's side"];

    case CarVerificationStep.dashboardPreCapture:
    case CarVerificationStep.dashboardCapture:
    case CarVerificationStep.dashboardVerify:
    case CarVerificationStep.dashboardFailed:
      return ["", ""];

    case CarVerificationStep.interiorPreCapture:
    case CarVerificationStep.interiorCapture:
    case CarVerificationStep.interiorVerify:
    case CarVerificationStep.interiorFailed:
      return ["", ""];

    case CarVerificationStep.verificationCompleted:
      return ["", ""];

    case PhoneVerificationStep.phoneFrontPreCapture:
    case PhoneVerificationStep.phoneFrontCapture:
    case PhoneVerificationStep.phoneFrontVerify:
      return ["Snap from the ", "passenger's side"];

    case PhoneVerificationStep.phoneBackPreCapture:
    case PhoneVerificationStep.phoneBackCapture:
    case PhoneVerificationStep.phoneBackVerify:
      return ["Snap from the ", "passenger's side"];

    case PhoneVerificationStep.phoneSettingsPreCapture:
    case PhoneVerificationStep.phoneSettingsCapture:
    case PhoneVerificationStep.phoneSettingsVerify:
      return ["Snap from the ", "passenger's side"];

    case PhoneVerificationStep.phoneSidePreCapture:
    case PhoneVerificationStep.phoneSideCapture:
    case PhoneVerificationStep.phoneSideVerify:
      return ["Snap from the ", "passenger's side"];

    default:
      return ["", ""];
  }
}

String getEndpointName(dynamic step) {
  switch (step) {
    case CarVerificationStep.frontSidePreCapture:
    case CarVerificationStep.frontSideCapture:
    case CarVerificationStep.frontSideVerify:
    case CarVerificationStep.frontSideFailed:
    case PhoneVerificationStep.phoneFrontPreCapture:
    case PhoneVerificationStep.phoneFrontCapture:
    case PhoneVerificationStep.phoneFrontVerify:
      return 'front';

    case CarVerificationStep.chasisNumberPreCapture:
    case CarVerificationStep.chasisNumberCapture:
    case CarVerificationStep.chasisNumberVerify:
    case CarVerificationStep.chasisNumberFailed:
      return 'vin';

    case CarVerificationStep.leftSidePreCapture:
    case CarVerificationStep.leftSideCapture:
    case CarVerificationStep.leftSideVerify:
    case CarVerificationStep.leftSideFailed:
      return 'left';
    case CarVerificationStep.backSidePreCapture:
    case CarVerificationStep.backSideCapture:
    case CarVerificationStep.backSideVerify:
    case CarVerificationStep.backSideFailed:
      return 'rear';

    case CarVerificationStep.rightSidePreCapture:
    case CarVerificationStep.rightSideCapture:
    case CarVerificationStep.rightSideVerify:
    case CarVerificationStep.rightSideFailed:
      return 'right';

    case CarVerificationStep.dashboardPreCapture:
    case CarVerificationStep.dashboardCapture:
    case CarVerificationStep.dashboardVerify:
    case CarVerificationStep.dashboardFailed:
      return 'dashboard';

    case CarVerificationStep.interiorPreCapture:
    case CarVerificationStep.interiorCapture:
    case CarVerificationStep.interiorVerify:
    case CarVerificationStep.interiorFailed:
      return 'interior';

    case PhoneVerificationStep.phoneSidePreCapture:
    case PhoneVerificationStep.phoneSideCapture:
    case PhoneVerificationStep.phoneSideVerify:
      return 'side';

    case PhoneVerificationStep.phoneBackPreCapture:
    case PhoneVerificationStep.phoneBackCapture:
    case PhoneVerificationStep.phoneBackVerify:
      return 'back';

    case PhoneVerificationStep.phoneSettingsPreCapture:
    case PhoneVerificationStep.phoneSettingsCapture:
    case PhoneVerificationStep.phoneSettingsVerify:
      return 'settings';

    case CarVerificationStep.verificationCompleted:
    case PhoneVerificationStep.verificationCompleted:
      return 'Completed';

    default:
      return 'Unknown';
  }
}

String getSideName(dynamic step) {
  switch (step) {
    case CarVerificationStep.frontSidePreCapture:
    case CarVerificationStep.frontSideCapture:
    case CarVerificationStep.frontSideVerify:
    case CarVerificationStep.frontSideFailed:
    case PhoneVerificationStep.phoneFrontPreCapture:
    case PhoneVerificationStep.phoneFrontCapture:
    case PhoneVerificationStep.phoneFrontVerify:
      return 'Front';

    case PhoneVerificationStep.phoneBackPreCapture:
    case PhoneVerificationStep.phoneBackCapture:
    case PhoneVerificationStep.phoneBackVerify:
      return 'Back';

    case PhoneVerificationStep.phoneSettingsPreCapture:
    case PhoneVerificationStep.phoneSettingsCapture:
    case PhoneVerificationStep.phoneSettingsVerify:
      return 'Internal Properties';

    case PhoneVerificationStep.phoneSidePreCapture:
    case PhoneVerificationStep.phoneSideCapture:
    case PhoneVerificationStep.phoneSideVerify:
      return 'Side';

    case CarVerificationStep.chasisNumberPreCapture:
    case CarVerificationStep.chasisNumberCapture:
    case CarVerificationStep.chasisNumberVerify:
    case CarVerificationStep.chasisNumberFailed:
      return 'Chassis Number';

    case CarVerificationStep.leftSidePreCapture:
    case CarVerificationStep.leftSideCapture:
    case CarVerificationStep.leftSideVerify:
    case CarVerificationStep.leftSideFailed:
      return 'Left';
    case CarVerificationStep.backSidePreCapture:
    case CarVerificationStep.backSideCapture:
    case CarVerificationStep.backSideVerify:
    case CarVerificationStep.backSideFailed:
      return 'Back';

    case CarVerificationStep.rightSidePreCapture:
    case CarVerificationStep.rightSideCapture:
    case CarVerificationStep.rightSideVerify:
    case CarVerificationStep.rightSideFailed:
      return 'Right';

    case CarVerificationStep.dashboardPreCapture:
    case CarVerificationStep.dashboardCapture:
    case CarVerificationStep.dashboardVerify:
    case CarVerificationStep.dashboardFailed:
      return 'Dashboard';

    case CarVerificationStep.interiorPreCapture:
    case CarVerificationStep.interiorCapture:
    case CarVerificationStep.interiorVerify:
    case CarVerificationStep.interiorFailed:
      return 'Interior';

    case CarVerificationStep.verificationCompleted:
      return 'Completed';

    default:
      return 'Unknown';
  }
}

String getInspectionSummaryName(String step,
    {InspectionType inspectionType = InspectionType.vehicle}) {
  switch (step) {
    case 'front':
      return inspectionType == InspectionType.gadget
          ? 'Front Image'
          : 'Front side';

    case "back":
      return inspectionType == InspectionType.gadget
          ? "Back Image"
          : 'Back side';

    case "vin":
      return 'Chassis';

    case "left":
      return 'Left side';
    case "rear":
      return inspectionType == InspectionType.gadget
          ? "Back Image"
          : 'Back side';

    case "right":
      return 'Right side';

    case "dashboard":
      return 'Dashboard';

    case "interior":
      return 'Interior';

    case "side":
      return 'Side Image';

    case "settings":
      return 'Internal Properties';

    default:
      return 'Unknown';
  }
}

//HELP
String getSideImage(dynamic step) {
  switch (step) {
    case CarVerificationStep.frontSidePreCapture:
    case CarVerificationStep.frontSideCapture:
    case CarVerificationStep.frontSideVerify:
    case CarVerificationStep.frontSideFailed:
      return ConstantString.frontViewNoBg;

    case CarVerificationStep.chasisNumberPreCapture:
    case CarVerificationStep.chasisNumberCapture:
    case CarVerificationStep.chasisNumberVerify:
    case CarVerificationStep.chasisNumberFailed:
      return ConstantString.chassisNumberNoBg;

    case CarVerificationStep.leftSidePreCapture:
    case CarVerificationStep.leftSideCapture:
    case CarVerificationStep.leftSideVerify:
    case CarVerificationStep.leftSideFailed:
      return ConstantString.leftViewNoBg;

    case CarVerificationStep.backSidePreCapture:
    case CarVerificationStep.backSideCapture:
    case CarVerificationStep.backSideVerify:
    case CarVerificationStep.backSideFailed:
      return ConstantString.backViewNoBg;

    case CarVerificationStep.rightSidePreCapture:
    case CarVerificationStep.rightSideCapture:
    case CarVerificationStep.rightSideVerify:
    case CarVerificationStep.rightSideFailed:
      return ConstantString.rightViewNoBg;

    case CarVerificationStep.dashboardPreCapture:
    case CarVerificationStep.dashboardCapture:
    case CarVerificationStep.dashboardVerify:
    case CarVerificationStep.dashboardFailed:
      return ConstantString.dashboardViewNoBg;

    case CarVerificationStep.interiorPreCapture:
    case CarVerificationStep.interiorCapture:
    case CarVerificationStep.interiorVerify:
    case CarVerificationStep.interiorFailed:
      return ConstantString.interiorViewNobg;

    case PhoneVerificationStep.phoneFrontPreCapture:
    case PhoneVerificationStep.phoneFrontCapture:
    case PhoneVerificationStep.phoneFrontVerify:
      return Global.gadgetType == GadgetType.laptop
          ? ConstantString.laptopFrontImg
          : ConstantString.phoneFrontImg;

    case PhoneVerificationStep.phoneBackPreCapture:
    case PhoneVerificationStep.phoneBackCapture:
    case PhoneVerificationStep.phoneBackVerify:
      return Global.gadgetType == GadgetType.laptop
          ? ConstantString.laptopBackImg
          : ConstantString.phoneBackImg;

    case PhoneVerificationStep.phoneSidePreCapture:
    case PhoneVerificationStep.phoneSideCapture:
    case PhoneVerificationStep.phoneSideVerify:
      return Global.gadgetType == GadgetType.laptop
          ? ConstantString.laptopOtherImg
          : ConstantString.phoneSideImg;

    case PhoneVerificationStep.phoneSettingsPreCapture:
    case PhoneVerificationStep.phoneSettingsCapture:
    case PhoneVerificationStep.phoneSettingsVerify:
      return Global.gadgetType == GadgetType.laptop
          ? ConstantString.laptopSettingsImg
          : ConstantString.phoneSettingsImg;

    case PhoneVerificationStep.phoneBackPreCapture:
    case PhoneVerificationStep.phoneBackCapture:
    case PhoneVerificationStep.phoneBackVerify:
      return Global.gadgetType == GadgetType.laptop
          ? ConstantString.laptopBackImg
          : ConstantString.phoneBackImg;

    case CarVerificationStep.verificationCompleted:
      return ConstantString.leftViewSample;

    default:
      return ConstantString.leftViewSample;
  }
}

VerificationStage getVerificationStage(dynamic step) {
  switch (step) {
    case CarVerificationStep.frontSidePreCapture:
    case CarVerificationStep.chasisNumberPreCapture:
    case CarVerificationStep.leftSidePreCapture:
    case CarVerificationStep.backSidePreCapture:
    case CarVerificationStep.rightSidePreCapture:
    case CarVerificationStep.dashboardPreCapture:
    case CarVerificationStep.interiorPreCapture:
    case PhoneVerificationStep.phoneFrontPreCapture:
    case PhoneVerificationStep.phoneBackPreCapture:
    case PhoneVerificationStep.phoneSettingsPreCapture:
    case PhoneVerificationStep.phoneSidePreCapture:
      return VerificationStage.preCapture;

    case CarVerificationStep.frontSideCapture:
    case CarVerificationStep.chasisNumberCapture:
    case CarVerificationStep.leftSideCapture:
    case CarVerificationStep.backSideCapture:
    case CarVerificationStep.rightSideCapture:
    case CarVerificationStep.dashboardCapture:
    case CarVerificationStep.interiorCapture:
    case PhoneVerificationStep.phoneFrontCapture:
    case PhoneVerificationStep.phoneBackCapture:
    case PhoneVerificationStep.phoneSettingsCapture:
    case PhoneVerificationStep.phoneSideCapture:
      return VerificationStage.capture;

    case CarVerificationStep.frontSideVerify:
    case CarVerificationStep.chasisNumberVerify:
    case CarVerificationStep.leftSideVerify:
    case CarVerificationStep.backSideVerify:
    case CarVerificationStep.rightSideVerify:
    case CarVerificationStep.dashboardVerify:
    case CarVerificationStep.interiorVerify:
    case PhoneVerificationStep.phoneFrontVerify:
    case PhoneVerificationStep.phoneBackVerify:
    case PhoneVerificationStep.phoneSettingsVerify:
    case PhoneVerificationStep.phoneSideVerify:
      return VerificationStage.verify;

    case CarVerificationStep.frontSideFailed:
    case CarVerificationStep.chasisNumberFailed:
    case CarVerificationStep.leftSideFailed:
    case CarVerificationStep.backSideFailed:
    case CarVerificationStep.rightSideFailed:
    case CarVerificationStep.dashboardFailed:
    case CarVerificationStep.interiorFailed:
      return VerificationStage.failed;

    case CarVerificationStep.verificationLoading:
    case PhoneVerificationStep.verificationLoading:
      return VerificationStage.loading;

    default:
      return VerificationStage.unknown;
  }
}

enum VerificationStage {
  unknown,
  preCapture,
  capture,
  verify,
  failed,
  loading,
}

enum PhoneVerificationStep {
  phoneFrontPreCapture,
  phoneFrontCapture,
  phoneFrontVerify,
  phoneBackPreCapture,
  phoneBackCapture,
  phoneBackVerify,
  phoneSettingsPreCapture,
  phoneSettingsCapture,
  phoneSettingsVerify,
  phoneSidePreCapture,
  phoneSideCapture,
  phoneSideVerify,
  verificationLoading,
  verificationCompleted,
}

VerificationStage getPhoneVerificationStage(PhoneVerificationStep step) {
  switch (step) {
    case PhoneVerificationStep.phoneFrontPreCapture:
    case PhoneVerificationStep.phoneBackPreCapture:
    case PhoneVerificationStep.phoneSettingsPreCapture:
    case PhoneVerificationStep.phoneSidePreCapture:
      return VerificationStage.preCapture;

    case PhoneVerificationStep.phoneFrontCapture:
    case PhoneVerificationStep.phoneBackCapture:
    case PhoneVerificationStep.phoneSettingsCapture:
    case PhoneVerificationStep.phoneSideCapture:
      return VerificationStage.capture;

    case PhoneVerificationStep.phoneFrontVerify:
    case PhoneVerificationStep.phoneBackVerify:
    case PhoneVerificationStep.phoneSettingsVerify:
    case PhoneVerificationStep.phoneSideVerify:
      return VerificationStage.verify;

    case PhoneVerificationStep.verificationLoading:
      return VerificationStage.loading;

    default:
      return VerificationStage.unknown;
  }
}
enum DamagePreviewAction { removed, confirmed, dismissed }

enum CarVerificationStep {
  frontSidePreCapture,
  frontSideCapture,
  frontSideVerify,
  frontSideFailed,
  chasisNumberPreCapture,
  chasisNumberCapture,
  chasisNumberVerify,
  chasisNumberFailed,
  leftSidePreCapture,
  leftSideCapture,
  leftSideVerify,
  leftSideFailed,
  backSidePreCapture,
  backSideCapture,
  backSideVerify,
  backSideFailed,
  rightSidePreCapture,
  rightSideCapture,
  rightSideVerify,
  rightSideFailed,
  dashboardPreCapture,
  dashboardCapture,
  dashboardVerify,
  dashboardFailed,
  interiorPreCapture,
  interiorCapture,
  interiorVerify,
  interiorFailed,
  roofPrecaputer,
  roofCapture,
  verificationLoading,
  verificationCompleted,

}

enum PageViewContent {
  firstAutoPage,
  secondAutoPage,
  thirdAutoPage,
  fourthAutoPage,
  displayPlainColor,
  displayGreenColor,
  displayTextAndList
}

enum PaymentOption {
  wallet,
  gateway,
}

enum PaymentMethod {
  transfer,
  ussd,
}

enum ToastStatus {
  success,
  pending,
  failed,
}

enum SdkResponseStatus {
  success,
  failed,
}

extension PaymentMethodName on PaymentMethod {
  String get getName {
    switch (this) {
      case PaymentMethod.transfer:
        return 'bank transfer';
      case PaymentMethod.ussd:
        return 'ussd';
      default:
        return "";
    }
  }
}

extension PaymentOptionName on PaymentOption {
  String get getName {
    switch (this) {
      case PaymentOption.wallet:
        return 'wallet';
      case PaymentOption.gateway:
        return 'gateway';
      default:
        return "";
    }
  }
}

enum TransactionType {
  purchase,
  inspection,
  claim,
}

enum SdkLayout {
  grid,
  list,
}

enum InspectionType { vehicle, gadget, home }

enum GadgetType { phone, laptop, other }

extension SdkLayoutName on SdkLayout {
  String get getName {
    switch (this) {
      case SdkLayout.grid:
        return 'grid';
      case SdkLayout.list:
        return 'list';
      default:
        return "grid";
    }
  }
}

enum ProductCategory {
  package,
  gadget,
  life,
  creditLife,
  auto,
  health,
  content,
  travel,
}

String getProductCategoryText(ProductCategory category) {
  switch (category) {
    case ProductCategory.package:
      return 'package';
    case ProductCategory.gadget:
      return 'gadget';
    case ProductCategory.life:
      return 'life';
    case ProductCategory.creditLife:
      return 'credit life';
    case ProductCategory.auto:
      return 'auto';
    case ProductCategory.health:
      return 'health';
    case ProductCategory.content:
      return 'content';
    case ProductCategory.travel:
      return 'travel';
  }
}

ProductCategory? getProductCategoryFromString(String value) {
  switch (value.toLowerCase()) {
    case 'package':
      return ProductCategory.package;
    case 'gadget':
      return ProductCategory.gadget;
    case 'life':
      return ProductCategory.life;
    case 'credit life':
      return ProductCategory.creditLife;
    case 'auto':
      return ProductCategory.auto;
    case 'vehicle':
      return ProductCategory.auto;
    case 'health':
      return ProductCategory.health;
    case 'content':
      return ProductCategory.content;
    case 'travel':
      return ProductCategory.travel;
    default:
      return null; // or throw if you prefer strict handling
  }
}

enum ClaimStatus {
  pending('Pending'),
  inspectionSubmitted('Inspection submitted'),
  approved('Approved'),
  declined('Declined'),
  repairEstimateSubmitted('Repair estimate submitted'),
  offerSent('Offer sent'),
  offerAccepted('Offer accepted'),
  offerRejected('Offer rejected'),
  paid('Paid'),
  settled('Settled'),
  requestedAdditionalInfo('Requested additional information');
  final String label;

  const ClaimStatus(this.label);
}

enum ClaimSubmissionStep {
  claimLodged,
  repairEstimate,
  offerAccepted,
  offerRejected,
  thirdPartyClaimLodged,
  thirdPartyInspected,
  theft,
  none,
}

String getClaimStatusDescription(ClaimStatus type) {
  switch (type) {
    case ClaimStatus.pending:
      return "Pending";
    case ClaimStatus.inspectionSubmitted:
      return "Inspection Submitted";
    case ClaimStatus.approved:
      return "Approved";
    case ClaimStatus.declined:
      return "Declined";
    case ClaimStatus.repairEstimateSubmitted:
      return "Repair Estimate Submitted";
    case ClaimStatus.offerSent:
      return "Offer Sent";
    case ClaimStatus.offerAccepted:
      return "Offer Accepted";
    case ClaimStatus.offerRejected:
      return "Offer Rejected";
    case ClaimStatus.paid:
      return "Paid";
    case ClaimStatus.requestedAdditionalInfo:
      return "Requested additional info";
    case ClaimStatus.settled:
      return "Settled";

    default:
      return "assets/animations/success_animation.json";
  }
}

GadgetType getGadgetType(String gadgetType) {
  switch (gadgetType) {
    case 'laptop':
      return GadgetType.laptop;

    case "phone":
      return GadgetType.phone;

    default:
      return GadgetType.other;
  }
}
