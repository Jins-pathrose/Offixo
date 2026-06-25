import 'package:flutter/material.dart';
import 'package:offixoadmin/features/leave/presentation/provider/leaverequestprovider.dart';
import 'package:offixoadmin/features/leave/presentation/widgets/leavesummarybadge.dart';

class SummaryRow extends StatelessWidget {
  final LeaveRequestProvider provider;
  const SummaryRow({required this.provider});
 
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SummaryBadge(
          count: provider.pendingCount,
          label: 'Pending',
          icon: Icons.pending_outlined,
          iconColor: const Color(0xFFFF9800),
          borderColor: const Color(0xFFFFE0B2),
          isActive: provider.activeFilter == LeaveFilter.pending,
          onTap: () => provider.setFilter(LeaveFilter.pending),
        ),
        const SizedBox(width: 10),
        SummaryBadge(
          count: provider.approvedCount,
          label: 'Approved',
          icon: Icons.check_circle_outline,
          iconColor: const Color(0xFF22C55E),
          borderColor: const Color(0xFF22C55E),
          isActive: provider.activeFilter == LeaveFilter.approved,
          onTap: () => provider.setFilter(LeaveFilter.approved),
        ),
        const SizedBox(width: 10),
        SummaryBadge(
          count: provider.rejectedCount,
          label: 'Rejected',
          icon: Icons.cancel_outlined,
          iconColor: const Color(0xFFE53935),
          borderColor: const Color(0xFFFFCDD2),
          isActive: provider.activeFilter == LeaveFilter.rejected,
          onTap: () => provider.setFilter(LeaveFilter.rejected),
        ),
      ],
    );
  }
}