class ProviderSettings {
  String? logo;
  String? brandColorPrimary;
  String? icon;
  ProviderSettings({
    required this.logo,
    required this.brandColorPrimary,
    required this.icon,
  });

  factory ProviderSettings.fromJson(json) {
    return ProviderSettings(
      logo: json['logo'],
      icon: json['icon'],
      brandColorPrimary: json['brand_color_primary'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logo': logo,
      'icon': icon,
      'brand_color_primary': brandColorPrimary,
    };
  }
}
