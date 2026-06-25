// lib/features/home/presentation/widgets/quickactiongrid.dart
import 'package:flutter/material.dart';
import 'package:offixoadmin/features/home/data/quickactionmodel.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class QuickActionsGrid extends StatelessWidget {
  final List<QuickActionData> actions;

  const QuickActionsGrid({super.key, required this.actions});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3.2, // wide pill shape
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return GestureDetector(
          onTap: action.onTap,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppStyle.primaryGradient,
              borderRadius: BorderRadius.circular(50), // pill shape
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  action.label,
                  style: AppStyle.text(
                    size: 13,
                    color: Colors.white,
                    weight: FontWeight.w600,
                  ),
                ),
                Container(
                  width: 50,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}