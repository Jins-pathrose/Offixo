import 'package:flutter/material.dart';
import 'shimmer_container.dart';

class ShimmerForm extends StatelessWidget {
  final int fieldsCount;

  const ShimmerForm({
    super.key,
    this.fieldsCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: fieldsCount,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerContainer(width: 100, height: 14),
            SizedBox(height: 8),
            ShimmerContainer(width: double.infinity, height: 50, borderRadius: 8),
          ],
        );
      },
    );
  }
}
