import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/branch/data/model/branchmodel.dart';

class BranchDetailsSheet extends StatelessWidget {
  final BranchModel branch;
  const BranchDetailsSheet({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, MediaQuery.of(context).padding.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header row
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF00BCD4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.account_tree_outlined,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(branch.name,
                        style: AppStyle.text(
                            size: 16, weight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: branch.isActive
                                ? const Color(0xFFE8F5E9)
                                : const Color(0xFFFFF0F0),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            branch.isActive ? 'Active' : 'Inactive',
                            style: AppStyle.text(
                              size: 11,
                              color: branch.isActive
                                  ? const Color(0xFF22C55E)
                                  : const Color(0xFFE53935),
                              weight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(branch.branchCode,
                            style: AppStyle.text(
                                size: 12, color: AppStyle.hintColor)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Details
          _DetailRow(
            icon: Icons.location_on_outlined,
            label: 'Address',
            value: branch.address,
          ),
          _DetailRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: branch.phone.isNotEmpty ? branch.phone : '--',
          ),
          _DetailRow(
            icon: Icons.radar_outlined,
            label: 'Punch-in Radius',
            value: '${branch.allowedRadiusMeter} meters',
          ),
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Created On',
            value: branch.formattedDate,
            isLast: true,
          ),

          const SizedBox(height: 24),

          // Close button
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: AppStyle.primaryGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: Text('Close',
                  style: AppStyle.text(
                      size: 15,
                      color: Colors.white,
                      weight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 16, color: AppStyle.hintColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: AppStyle.text(
                            size: 11, color: AppStyle.accentCyan)),
                    const SizedBox(height: 3),
                    Text(value,
                        style: AppStyle.text(
                            size: 14, weight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, thickness: 0.5, indent: 28),
      ],
    );
  }
}