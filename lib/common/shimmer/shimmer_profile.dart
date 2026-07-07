import 'package:flutter/material.dart';
import 'shimmer_container.dart';

class ShimmerProfile extends StatelessWidget {
  const ShimmerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const ShimmerContainer(width: 100, height: 100, borderRadius: 50),
          const SizedBox(height: 16),
          const ShimmerContainer(width: 150, height: 20),
          const SizedBox(height: 8),
          const ShimmerContainer(width: 100, height: 14),
          const SizedBox(height: 32),
          ...List.generate(3, (index) => const Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerContainer(width: 100, height: 14),
                SizedBox(height: 8),
                ShimmerContainer(width: double.infinity, height: 50, borderRadius: 8),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
