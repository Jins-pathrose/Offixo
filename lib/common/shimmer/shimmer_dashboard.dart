import 'package:flutter/material.dart';
import 'shimmer_container.dart';
import 'shimmer_card.dart';

class ShimmerDashboard extends StatelessWidget {
  const ShimmerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerContainer(width: 200, height: 24),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: ShimmerCard(height: 100, margin: EdgeInsets.only(right: 8))),
              Expanded(child: ShimmerCard(height: 100, margin: EdgeInsets.only(left: 8))),
            ],
          ),
          const SizedBox(height: 24),
          const ShimmerContainer(width: 150, height: 20),
          const SizedBox(height: 16),
          const ShimmerCard(height: 200, margin: EdgeInsets.zero),
          const SizedBox(height: 24),
          const ShimmerContainer(width: 150, height: 20),
          const SizedBox(height: 16),
          ...List.generate(3, (index) => const Padding(
            padding: EdgeInsets.only(bottom: 12.0),
            child: ShimmerContainer(width: double.infinity, height: 70, borderRadius: 12),
          )),
        ],
      ),
    );
  }
}
