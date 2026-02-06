class ApiEndpoints {
  //MATCHES
  static const initialiseSdk = "sdk/initialize";
  static const initialiseSdkFallBack = "distributors/fetch-default-settings";
  static const getInsuranceProviders = "sdk/insurance-providers";
  static const getProductDetails = "sdk/products-with-form-fields";
  static const fetchProductPrice = "sdk/price";
  static const initiatePurchase = "sdk/initiate-purchase";
  static const getUssdProviders = "sdk/ussd-providers";
  static const verifyPayment = "sdk/verify-transaction";
  static const getPurchaseInfo = "sdk/purchase-info";

  static const completePurchase = "sdk/complete-purchase";
  static const uploadFile = "upload-file";

  //INSPECTION
  static const verifyImageAI = "sdk/inspections-ai/vehicle";
  static const submitAutoInspection = "sdk/submit-inspections-ai/vehicle";

  static const submitGadgetInspection = "sdk/submit-gadget-inspection";

  static const submitAutoClaims = "sdk/submit-vehicle-claim-inspection";
  static const submitGadgetClaimsInspection =
      "sdk/submit-gadget-claim-inspection";

  //CLAIMS
  static const submitVehicleClaim = "sdk/submit-vehicle-claim";
  static const submitGadgetClaim = "sdk/submit-gadget-claim";
  static const getClaimsById = "sdk/fetch-claim-with-policy-id";
  static const getPolicyInfo = "sdk/fetch-policy-info";
  static const getClaimInfo = "sdk/fetch-claim-info";
  static const getDamagedPart = "sdk/claims/damage-areas-parts";

  static const verifyClaimImageAI = "sdk/verify-claim-auto-images";
  static const submitVehicleClaimEstimate = "sdk/submit-vehicle-claim-estimate";
  static const submitDevoiceClaimEstimate = "/sdk/submit-gadget-claim-estimate";
  static const getBankList = "sdk/list-banks";
  static const verifyBankAccount = "sdk/verify-bank-account";
  static const acceptClaimOffer = "sdk/accept-claim-offer";
  static const rejectClaimOffer = "sdk/reject-claim-offer";
  static const submitAdditionalInfo = "sdk/submit-additional-info";
  static const submitThirdPartyAutoClaimInspection =
      "sdk/submit-third-party-auto-claim-inspection";
  static const fetchClaimWithPolicyId = "/sdk/fetch-claim-with-policy-id";

  //POLICIES
  static const getPolicyById = "policies";
}
