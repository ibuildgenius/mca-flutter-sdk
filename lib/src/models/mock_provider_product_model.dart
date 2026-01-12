import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';

class MockProviderListModel {
  String imageUrl, title;
  bool hasDiscount;

  MockProviderListModel({
    required this.imageUrl,
    required this.title,
    this.hasDiscount = true,
  });
}

List<MockProviderListModel> mockProviderProductLists = [
  MockProviderListModel(
    imageUrl: ConstantString.leadwayLogo,
    title: "Compr. Auto",
  ),
  MockProviderListModel(
    imageUrl: ConstantString.aiicoLogo,
    title: "Monthly compr.",
  ),
  MockProviderListModel(
      imageUrl: ConstantString.sovereignLogo,
      title: "3rd party Auto",
      hasDiscount: false),
  MockProviderListModel(
    imageUrl: ConstantString.aiicoLogo,
    title: "Monthly compr.",
  ),
];
