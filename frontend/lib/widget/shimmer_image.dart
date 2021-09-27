import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

class ShimmerNetworkImage extends StatelessWidget {
  const ShimmerNetworkImage(
    this.url, {
    Key? key,
    this.boxFit,
    this.height,
    this.width,
  }) : super(key: key);

  final String url;
  final BoxFit? boxFit;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return FancyShimmerImage(
      imageUrl: url,
      boxFit: boxFit ?? BoxFit.cover,
      height: height ?? 300,
      width: width ?? 300,
    );
  }
}
