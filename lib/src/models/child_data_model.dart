// // class ChildDataModel {
// //   int? min;
// //   String? name;
// //   String? label;
// //   int? position;
// //   bool? required;
// //   String? dataType;
// //   String? errorMsg;
// //   String? inputType;
// //   String? productId;
// //   bool? showFirst;
// //   String? dataSource;
// //   String? description;
// //   String? formFieldId;
// //   String? fullDescription;
// //   String? minMaxConstraint;

// //   ChildDataModel({
// //     this.min,
// //     this.name,
// //     this.label,
// //     this.position,
// //     this.required,
// //     this.dataType,
// //     this.errorMsg,
// //     this.inputType,
// //     this.productId,
// //     this.showFirst,
// //     this.dataSource,
// //     this.description,
// //     this.formFieldId,
// //     this.fullDescription,
// //     this.minMaxConstraint,
// //   });

// //   factory ChildDataModel.fromJson(Map<String, dynamic> json) {
// //     return ChildDataModel(
// //       min: json['min'],
// //       name: json['name'],
// //       label: json['label'],
// //       position: json['position'],
// //       required: json['required'],
// //       dataType: json['data_type'],
// //       errorMsg: json['error_msg'],
// //       inputType: json['input_type'],
// //       productId: json['product_id'],
// //       showFirst: json['show_first'],
// //       dataSource: json['data_source'],
// //       description: json['description'],
// //       formFieldId: json['form_field_id'],
// //       fullDescription: json['full_description'],
// //       minMaxConstraint: json['min_max_constraint'],
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'min': min,
// //       'name': name,
// //       'label': label,
// //       'position': position,
// //       'required': required,
// //       'data_type': dataType,
// //       'error_msg': errorMsg,
// //       'input_type': inputType,
// //       'product_id': productId,
// //       'show_first': showFirst,
// //       'data_source': dataSource,
// //       'description': description,
// //       'form_field_id': formFieldId,
// //       'full_description': fullDescription,
// //       'min_max_constraint': minMaxConstraint,
// //     };
// //   }
// // }

// class FormFieldModel {
//   String? id;
//   String? description;
//   String? name;
//   String? label;
//   int? position;
//   String? fullDescription;
//   String? dataType;
//   String? inputType;
//   bool? isCurrency;
//   bool? showFirst;
//   bool? required;
//   bool? hasChild;
//   ChildDataModel? childData;
//   String? errorMsg;
//   String? dataSource;
//   String? dataUrl;
//   dynamic dependsOn;
//   int? min;
//   int? max;
//   String? minMaxConstraint;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   dynamic deletedAt;
//   String? formFieldId;
//   String? productId;
//   final FormFieldDetailsModel? formField;

//   FormFieldModel({
//     required this.id,
//     required this.description,
//     required this.name,
//     required this.label,
//     required this.position,
//     required this.fullDescription,
//     required this.dataType,
//     required this.inputType,
//     required this.isCurrency,
//     required this.showFirst,
//     required this.required,
//     required this.hasChild,
//     required this.childData,
//     required this.errorMsg,
//     required this.dataSource,
//     required this.dataUrl,
//     required this.dependsOn,
//     required this.min,
//     required this.max,
//     required this.minMaxConstraint,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.deletedAt,
//     required this.formFieldId,
//     required this.productId,
//     required this.formField,
//   });

//   factory FormFieldModel.fromJson(json) {
//     return FormFieldModel(
//       id: json['id'],
//       description: json['description'],
//       name: json['name'],
//       label: json['label'],
//       position: json['position'],
//       fullDescription: json['full_description'],
//       dataType: json['data_type'],
//       inputType: json['input_type'],
//       isCurrency: json['is_currency'],
//       showFirst: json['show_first'],
//       required: json['required'],
//       hasChild: json['has_child'],
//       childData: json['child_data'] != null
//           ? ChildDataModel.fromJson(json['child_data'])
//           : null,
//       errorMsg: json['error_msg'],
//       dataSource: json['data_source'],
//       dataUrl: json['data_url'],
//       dependsOn: json['depends_on'],
//       min: json['min'],
//       max: json['max'],
//       minMaxConstraint: json['min_max_constraint'],
//       createdAt: json['created_at'] != null
//           ? DateTime.parse(json['created_at'])
//           : null,
//       updatedAt: json['updated_at'] != null
//           ? DateTime.parse(json['updated_at'])
//           : null,
//       deletedAt: json['deleted_at'] != null
//           ? DateTime.parse(json['deleted_at'])
//           : null,
//       formFieldId: json['form_field_id'],
//       productId: json['product_id'],
//       formField: FormFieldDetailsModel.fromJson(json['form_field']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'description': description,
//       'name': name,
//       'label': label,
//       'position': position,
//       'full_description': fullDescription,
//       'data_type': dataType,
//       'input_type': inputType,
//       'is_currency': isCurrency,
//       'show_first': showFirst,
//       'required': required,
//       'has_child': hasChild,
//       'child_data': childData?.toJson(),
//       'error_msg': errorMsg,
//       'data_source': dataSource,
//       'data_url': dataUrl,
//       'depends_on': dependsOn,
//       'min': min,
//       'max': max,
//       'min_max_constraint': minMaxConstraint,
//       'created_at': createdAt?.toIso8601String(),
//       'updated_at': updatedAt?.toIso8601String(),
//       'deleted_at': deletedAt,
//       'form_field_id': formFieldId,
//       'product_id': productId,
//       'form_field': formField?.toJson(),
//     };
//   }
// }
