import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/home/data/quickactionmodel.dart';

class CheckInList extends StatelessWidget {
  final List<CheckInStaffData> checkIns;
  const CheckInList({required this.checkIns});
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: checkIns
          .map(
            (staff) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _CheckInCard(data: staff),
            ),
          )
          .toList(),
    );
  }
}
class _CheckInCard extends StatelessWidget {
  final CheckInStaffData data;
  const _CheckInCard({required this.data});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              data.imagePath,
              width: 46,
              height: 46,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 46,
                height: 46,
                color: Colors.grey.shade200,
                child: const Icon(Icons.person, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
 
          // Name & branch info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: AppStyle.text(
                    size: 14,
                    weight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      data.branch,
                      style: AppStyle.text(
                        size: 11,
                        color: AppStyle.accentCyan,
                        weight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      ' • ${data.staffId}',
                      style: AppStyle.text(
                        size: 11,
                        color: AppStyle.hintColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
 
          // Status badge
          _StatusBadge(isOnDuty: data.isOnDuty),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isOnDuty;
  const _StatusBadge({required this.isOnDuty});
 
  @override
  Widget build(BuildContext context) {
    final color = isOnDuty ? const Color(0xFF22C55E) : AppStyle.hintColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        isOnDuty ? 'On Duty' : 'Off Duty',
        style: AppStyle.text(
          size: 11,
          color: color,
          weight: FontWeight.w600,
        ),
      ),
    );
  }
}