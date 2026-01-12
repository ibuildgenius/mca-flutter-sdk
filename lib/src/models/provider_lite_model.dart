import 'package:mca_official_flutter_sdk/src/models/provider_settings.dart';

class ProviderLiteModel {
  String? companyName;
  String? id;
  String? logo;
  String? icon;
  String? brandColorPrimary;
  ProviderSettings? settings;

  ProviderLiteModel({
    required this.companyName,
    required this.id,
    required this.logo,
    required this.icon,
    required this.brandColorPrimary,
    required this.settings,
  });

  factory ProviderLiteModel.fromJson(json) {
    return ProviderLiteModel(
      id: json['id'],
      companyName: json['company_name'],
      logo: json['logo'],
      icon: json['icon'],
      brandColorPrimary: json['brand_color_primary'],
      settings: json['settings'] == null
          ? null
          : ProviderSettings.fromJson(json['settings']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_name': companyName,
      'id': id,
      'logo': logo,
      'icon': icon,
      'brand_color_primary': brandColorPrimary,
      'settings': settings?.toJson(),
    };
  }
}
