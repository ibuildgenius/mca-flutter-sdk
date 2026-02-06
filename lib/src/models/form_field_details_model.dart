class FormFieldDetailsModel {
  factory FormFieldDetailsModel.fromJson(json) {
    return FormFieldDetailsModel(
      id: json['id'],
      name: json['name'],
      label: json['label'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  FormFieldDetailsModel({
    required this.id,
    required this.name,
    required this.label,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });
  final String? id;
  final String? name;
  final String? label;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'label': label,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
