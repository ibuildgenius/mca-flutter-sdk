class FormDataUrlResponse {
  final String? name;
  final String? id;

  FormDataUrlResponse({
    required this.name,
    required this.id,
  });

  factory FormDataUrlResponse.fromJson(json) {
    return FormDataUrlResponse(
      name: json['name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}
