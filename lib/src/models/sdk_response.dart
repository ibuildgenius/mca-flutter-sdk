import 'package:flutter/material.dart';
import 'package:mca_official_flutter_sdk/mca_official_flutter_sdk.dart';
import 'package:mca_official_flutter_sdk/src/models/claims_model.dart';
import 'package:mca_official_flutter_sdk/src/models/inspection_model.dart';

class SdkResponse {
  SdkResponseStatus status;
  PolicyModel? policyModel;
  InspectionModel? inspection;
  ClaimModel? claim;
  BuildContext context;

  SdkResponse({
    required this.status,
    this.policyModel,
    this.inspection,
    this.claim,
    required this.context,
  });
}
