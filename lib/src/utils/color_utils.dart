import 'package:flutter/material.dart';

class ColorUtils {
  static Color getColorFromHex(String? hexColor,
      {String defaultColor = "FF3BAA90"}) {
    // Check if the hexColor is null or empty, and return the default color
    if (hexColor == null || hexColor.isEmpty) {
      return Color(int.parse(defaultColor, radix: 16));
    }

    // Remove the "#" if it's present
    hexColor = hexColor.toUpperCase().replaceAll("#", "");

    // If the length is 6, prepend "FF" to make it fully opaque
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }

    // If the length is not 8, return the default color
    if (hexColor.length != 8) {
      return Color(int.parse(defaultColor, radix: 16));
    }

    try {
      // Parse the hex string and return the Color object
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      // In case of an error, return the default color
      return Color(int.parse(defaultColor, radix: 16));
    }
  }
}
