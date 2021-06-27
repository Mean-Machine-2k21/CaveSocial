import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class ShimmerNetworkImage extends StatelessWidget {
  const ShimmerNetworkImage(
    this.url, {
    Key? key,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return FancyShimmerImage(
      imageUrl: url,
    );
  }
}
