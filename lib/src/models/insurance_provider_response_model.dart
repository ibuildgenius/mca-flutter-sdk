import 'package:mca_official_flutter_sdk/src/models/provider_model.dart';

class InsuranceProviderResponse {
  final int? totalCount;
  final List<ProviderModel>? providers;

  InsuranceProviderResponse({
    required this.totalCount,
    required this.providers,
  });

  factory InsuranceProviderResponse.fromJson(json) {
    return InsuranceProviderResponse(
      totalCount: json['total_count'],
      providers: json['providers'] != null
          ? (json['providers'] as List)
              .map((e) => ProviderModel.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_count': totalCount,
      'providers': providers?.map((e) => e.toJson()).toList(),
    };
  }
}
