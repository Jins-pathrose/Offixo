import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class StaffCard extends StatelessWidget {
  final String name;
  final String branch;
  final String staffId;
  final String image;
  final bool isOnDuty;

  const StaffCard({
    super.key,
    required this.name,
    required this.branch,
    required this.staffId,
    required this.image,
    required this.isOnDuty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(image),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppStyle.text(
                    size: 16,
                    weight: FontWeight.w600,
                  ),
                ),
                Text(
                  "$branch • $staffId",
                  style: AppStyle.text(
                    color: AppStyle.hintColor,
                    size: 13,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: isOnDuty
                    ? Colors.green
                    : Colors.red,
              ),
              borderRadius:
                  BorderRadius.circular(30),
            ),
            child: Text(
              isOnDuty ? "On Duty" : "Leave",
              style: AppStyle.text(
                size: 12,
                color: isOnDuty
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}