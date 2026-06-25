import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/leavebalance/data/models/leavebalancemodel.dart';

class LeaveBalanceCard extends StatelessWidget {
  final LeaveBalanceModel balance;

  const LeaveBalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    final usedPercent =
        balance.totalAllocated > 0 ? balance.usedLeaves / balance.totalAllocated : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──
          Row(
            children: [
              // Code badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppStyle.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  balance.leaveTypeCode,
                  style: AppStyle.text(
                      size: 11, color: Colors.white, weight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  balance.leaveTypeName,
                  style: AppStyle.text(size: 14, weight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Remaining chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _remainingColor(balance.remainingBalance,
                          balance.totalAllocated)
                      .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${balance.remainingBalance.toStringAsFixed(0)} left',
                  style: AppStyle.text(
                    size: 11,
                    weight: FontWeight.w700,
                    color: _remainingColor(
                        balance.remainingBalance, balance.totalAllocated),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Progress bar ──
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: usedPercent.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AppStyle.borderColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                _progressColor(usedPercent),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ── Stats row ──
          Row(
            children: [
              _StatCell(
                label: 'Allocated',
                value: balance.totalAllocated.toStringAsFixed(0),
                color: AppStyle.accentCyan,
              ),
              _divider(),
              _StatCell(
                label: 'Used',
                value: balance.usedLeaves.toStringAsFixed(1),
                color: _progressColor(usedPercent),
              ),
              _divider(),
              _StatCell(
                label: 'Remaining',
                value: balance.remainingBalance.toStringAsFixed(1),
                color: _remainingColor(
                    balance.remainingBalance, balance.totalAllocated),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 28,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        color: AppStyle.borderColor,
      );

  Color _progressColor(double used) {
    if (used >= 0.9) return const Color(0xFFEF4444);
    if (used >= 0.6) return const Color(0xFFF59E0B);
    return AppStyle.accentCyan;
  }

  Color _remainingColor(double remaining, double total) {
    if (total == 0) return Colors.grey;
    final ratio = remaining / total;
    if (ratio <= 0.1) return const Color(0xFFEF4444);
    if (ratio <= 0.4) return const Color(0xFFF59E0B);
    return const Color(0xFF22C55E);
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCell(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style:
                  AppStyle.text(size: 16, weight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: AppStyle.text(size: 11, color: AppStyle.hintColor)),
        ],
      ),
    );
  }
}