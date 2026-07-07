import 'package:flutter/material.dart';
import 'shimmer_container.dart';

class ShimmerCard extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const ShimmerCard({
    super.key,
    this.width = double.infinity,
    this.height = 120,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerContainer(
      width: width,
      height: height,
      borderRadius: 12,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
