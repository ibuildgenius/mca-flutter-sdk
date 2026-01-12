import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';

class MockProductListModel {
  String icon, title;
  int total;

  MockProductListModel({
    required this.icon,
    required this.title,
    required this.total,
  });
}

List<MockProductListModel> mockProductLists = [
  MockProductListModel(
    icon: ConstantString.autoIcon,
    title: "Auto Insurance",
    total: 6,
  ),
  MockProductListModel(
    icon: ConstantString.healthIcon,
    title: "Health Insurance",
    total: 8,
  ),
  MockProductListModel(
    icon: ConstantString.gadgetIcon,
    title: "Gadget Insurance",
    total: 2,
  ),
  MockProductListModel(
    icon: ConstantString.creditLifeIcon,
    title: "Credit life Insurance",
    total: 6,
  ),
  MockProductListModel(
    icon: ConstantString.travelIcon,
    title: "Travel Insurance",
    total: 2,
  ),
  MockProductListModel(
    icon: ConstantString.lifeIcon,
    title: "Life Insurance",
    total: 12,
  ),
  MockProductListModel(
    icon: ConstantString.gitIcon,
    title: "GIT Insurance",
    total: 1,
  ),
  MockProductListModel(
    icon: ConstantString.lifeIcon,
    title: "Life Insurance",
    total: 12,
  ),
];
