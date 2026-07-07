import 'package:flutter/material.dart';
import 'shimmer_container.dart';

class ShimmerImage extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final BoxShape shape;

  const ShimmerImage({
    super.key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.borderRadius = 8,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    if (shape == BoxShape.circle) {
      return ShimmerContainer(
        width: width,
        height: height,
        borderRadius: width / 2,
      );
    }
    return ShimmerContainer(
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }
}
