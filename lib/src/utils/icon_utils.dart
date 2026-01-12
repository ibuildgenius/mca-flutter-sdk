import 'package:mca_official_flutter_sdk/src/constants/custom_string.dart';

class IconUtils {
  static String getIcon(String category) {
    final Map<String, String> categoryIconMap = {
      'package': ConstantString.packageIcon,
      'gadget': ConstantString.gadgetIcon,
      'life': ConstantString.lifeIcon,
      'credit life': ConstantString.creditLifeIcon,
      'auto': ConstantString.autoIcon,
      'health': ConstantString.healthIcon,
      'content': ConstantString.contentIcon,
      'travel': ConstantString.travelIcon,
    };

    // Define the default icon
    const String defaultIcon = ConstantString.lifeIcon;

    // Return the corresponding icon or the default icon if not found
    return categoryIconMap[category.toLowerCase()] ?? defaultIcon;
  }
}
