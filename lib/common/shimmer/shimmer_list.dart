import 'package:flutter/material.dart';
import 'shimmer_container.dart';

class ShimmerListItem extends StatelessWidget {
  const ShimmerListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerContainer(width: 50, height: 50, borderRadius: 25),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerContainer(width: double.infinity, height: 16),
              SizedBox(height: 8),
              ShimmerContainer(width: 150, height: 14),
            ],
          ),
        ),
      ],
    );
  }
}

class ShimmerList extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry padding;

  const ShimmerList({
    super.key,
    this.itemCount = 6,
    this.padding = const EdgeInsets.all(16.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: List.generate(
          itemCount,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: index == itemCount - 1 ? 0 : 16.0),
            child: const ShimmerListItem(),
          ),
        ),
      ),
    );
  }
}
