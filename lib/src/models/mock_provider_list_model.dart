import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';

class MockProviderListModel {
  String imageUrl, title;

  MockProviderListModel({
    required this.imageUrl,
    required this.title,
  });
}

List<MockProviderListModel> mockProviderLists = [
  MockProviderListModel(
    imageUrl: "",
    title: "All",
  ),
  MockProviderListModel(
    imageUrl: ConstantString.aiicoLogo,
    title: "AIICO",
  ),
  MockProviderListModel(
    imageUrl: ConstantString.leadwayLogo,
    title: "Leadway",
  ),
  MockProviderListModel(
    imageUrl: ConstantString.sovereignLogo,
    title: "Sovereign Trust",
  ),
];
