import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget customImagenetwork({
  required String imageUrl,
  required Widget loaderWidget,
  BoxFit? fit,
  double? height,
  // required Widget errorWidget
}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    placeholder: (context, url) => loaderWidget,
    fit: fit,
    height: height,
    // errorWidget: (context, url, error) => errorWidget,
  );
}
