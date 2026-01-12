import 'package:mca_official_flutter_sdk/src/models/form_field_details_model.dart';

class FormFieldModel {
  factory FormFieldModel.fromJson(json) {
    return FormFieldModel(
      id: json['id'],
      description: json['description'],
      name: json['name'],
      label: json['label'],
      position: json['position'],
      fullDescription: json['full_description'],
      dataType: json['data_type'],
      inputType: json['input_type'],
      isCurrency: json['is_currency'],
      showFirst: json['show_first'],
      required: json['required'],
      hasChild: json['has_child'],
      childData: (json['child_data'] != null &&
              (json['child_data'] as List).isNotEmpty)
          ? (json['child_data'] as List)
              .map((item) => FormFieldModel.fromJson(item))
              .toList()
          : null,
      errorMsg: json['error_msg'],
      dataSource: json['data_source'],
      dataUrl: json['data_url'],
      // dependsOn: json['depends_on'],
      dependsOn: (json['depends_on'] != null && json['depends_on'].isNotEmpty)
          ? json['depends_on']
          : null,

      min: json['min'],
      max: json['max'],
      minMaxConstraint: json['min_max_constraint'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
      formFieldId: json['form_field_id'],
      productId: json['product_id'],
      formField: json['child_data'] == null
          ? null
          : FormFieldDetailsModel.fromJson(json['form_field']),
    );
  }

  FormFieldModel({
    required this.id,
    required this.description,
    required this.name,
    required this.label,
    required this.position,
    required this.fullDescription,
    required this.dataType,
    required this.inputType,
    required this.isCurrency,
    required this.showFirst,
    required this.required,
    required this.hasChild,
    required this.errorMsg,
    required this.dataSource,
    required this.dataUrl,
    required this.dependsOn,
    required this.min,
    required this.max,
    required this.minMaxConstraint,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.formFieldId,
    required this.productId,
    required this.formField,
    this.childData,
  });
  String? id;
  String? description;
  String? name;
  String? label;
  int? position;
  String? fullDescription;
  String? dataType;
  String? inputType;
  bool? isCurrency;
  bool? showFirst;
  bool? required;
  bool? hasChild;
  final List<FormFieldModel>? childData;
  String? errorMsg;
  String? dataSource;
  String? dataUrl;
  dynamic dependsOn;
  int? min;
  int? max;
  String? minMaxConstraint;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? formFieldId;
  String? productId;
  final FormFieldDetailsModel? formField;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'name': name,
      'label': label,
      'position': position,
      'full_description': fullDescription,
      'data_type': dataType,
      'input_type': inputType,
      'is_currency': isCurrency,
      'show_first': showFirst,
      'required': required,
      'has_child': hasChild,
      'child_data': childData?.map((item) => item.toJson()).toList(),
      'error_msg': errorMsg,
      'data_source': dataSource,
      'data_url': dataUrl,
      'depends_on': dependsOn,
      'min': min,
      'max': max,
      'min_max_constraint': minMaxConstraint,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt,
      'form_field_id': formFieldId,
      'product_id': productId,
      'form_field': formField?.toJson(),
    };
  }
}

FormFieldModel beneficiaryFormField = FormFieldModel(
  id: "75cefe9c-e1db-47d2-8974-76d0f775577c",
  description: "Add details for those you want to add as beneficiaries",
  name: "beneficiaries",
  label: "Beneficiaries",
  position: 11,
  fullDescription: "Add details for those you want to add as beneficiaries",
  dataType: "array",
  inputType: "text",
  isCurrency: false,
  showFirst: false,
  required: false,
  hasChild: true,
  childData: [
    FormFieldModel(
      min: 3,
      name: "first_name",
      label: "First name",
      position: 1,
      required: true,
      dataType: "string",
      errorMsg: "Please provide first name",
      inputType: "text",
      productId: "fab6bda1-b870-4648-8704-11c1802a51d0",
      showFirst: true,
      dataSource: "user_defined",
      description: "Beneficiary first name",
      formFieldId: "1",
      fullDescription: "Your first name",
      minMaxConstraint: "day",
      id: '',
      isCurrency: null,
      hasChild: null,
      childData: null,
      dataUrl: '',
      dependsOn: null,
      max: null,
      createdAt: null,
      updatedAt: null,
      deletedAt: null,
      formField: null,
    ),
    FormFieldModel(
      min: 3,
      name: "last_name",
      label: "Last name",
      position: 2,
      required: true,
      dataType: "string",
      errorMsg: "Please provide last name",
      inputType: "text",
      productId: "fab6bda1-b870-4648-8704-11c1802a51d0",
      showFirst: true,
      dataSource: "user_defined",
      description: "Beneficiary last name",
      formFieldId: "1",
      fullDescription: "Beneficiary last name",
      minMaxConstraint: "day",
      id: '',
      isCurrency: null,
      hasChild: null,
      childData: null,
      dataUrl: '',
      dependsOn: null,
      max: null,
      createdAt: null,
      updatedAt: null,
      deletedAt: null,
      formField: null,
    ),
    FormFieldModel(
      name: "date_of_birth",
      label: "Date of birth",
      position: 3,
      required: true,
      dataType: "string",
      errorMsg: "Please provide a valid date",
      inputType: "date",
      productId: "f8b5bca1-b870-4648-8704-11c1802a51d0",
      showFirst: true,
      dataSource: "user_defined",
      description: "Date of birth",
      formFieldId: "1",
      fullDescription: "Date of birth",
      id: '',
      isCurrency: null,
      hasChild: null,
      childData: null,
      dataUrl: '',
      dependsOn: null,
      max: null,
      createdAt: null,
      updatedAt: null,
      deletedAt: null,
      formField: null,
      min: null,
      minMaxConstraint: '',
    ),
    FormFieldModel(
      name: "gender",
      label: "Gender",
      dataUrl: "/sdk/get-tangerine-gender",
      position: 4,
      required: true,
      dataType: "string",
      errorMsg: "Please provide a valid gender",
      inputType: "text",
      productId: "fab6bda1-b870-4648-8704-11c1802a51d0",
      showFirst: false,
      dataSource: "api",
      description: "Your gender",
      formFieldId: "2",
      fullDescription: "Your gender",
      id: '',
      isCurrency: null,
      hasChild: null,
      childData: null,
      dependsOn: null,
      max: null,
      createdAt: null,
      updatedAt: null,
      deletedAt: null,
      formField: null,
      minMaxConstraint: '',
      min: null,
    ),
  ],
  errorMsg: "Please provide a value",
  dataSource: "user_defined",
  dataUrl: null,
  dependsOn: "number_of_beneficiaries",
  min: 2,
  max: null,
  minMaxConstraint: "length",
  createdAt: DateTime.parse("2023-06-08T18:33:44.519Z"),
  updatedAt: DateTime.parse("2023-06-08T18:33:44.519Z"),
  deletedAt: null,
  formFieldId: "1",
  productId: "fab6bda1-b870-4648-8704-11c1802a51d0",
  formField: null,
);
