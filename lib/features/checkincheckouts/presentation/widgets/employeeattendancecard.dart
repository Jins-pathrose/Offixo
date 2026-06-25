import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/checkincheckouts/data/attendancemodel.dart';

class EmployeeAttendanceCard extends StatelessWidget {
  final AttendanceRecord record;

  const EmployeeAttendanceCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(record.status);

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
          // ── Top row: avatar + name + status chip ──
          Row(
            children: [
              _Avatar(name: record.employeeName),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.employeeName,
                      style:
                          AppStyle.text(size: 14, weight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          record.empNo,
                          style: AppStyle.text(
                              size: 12, color: AppStyle.hintColor),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: AppStyle.hintColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          record.branchName,
                          style: AppStyle.text(
                              size: 12, color: AppStyle.hintColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Status chip
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  record.status,
                  style: AppStyle.text(
                      size: 11,
                      color: statusColor,
                      weight: FontWeight.w700),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          Divider(color: AppStyle.borderColor, height: 1),
          const SizedBox(height: 14),

          // ── Check-in / Check-out / Hours row ──
          Row(
            children: [
              _TimeCell(
                icon: Icons.login_rounded,
                label: 'Check In',
                time: record.checkinTime ?? '--:--',
                color: const Color(0xFF22C55E),
              ),
              _verticalDivider(),
              _TimeCell(
                icon: Icons.logout_rounded,
                label: 'Check Out',
                time: record.checkoutTime ?? '--:--',
                color: const Color(0xFFEF4444),
              ),
              _verticalDivider(),
              _TimeCell(
                icon: Icons.access_time_rounded,
                label: 'Hours',
                time: record.workingHours,
                color: AppStyle.accentCyan,
              ),
            ],
          ),

          // ── Break info (show only if breaks exist) ──
          if (record.totalBreaksTaken > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.coffee_rounded,
                      size: 14, color: Color(0xFFF59E0B)),
                  const SizedBox(width: 6),
                  Text(
                    '${record.totalBreaksTaken} break${record.totalBreaksTaken > 1 ? 's' : ''}',
                    style: AppStyle.text(
                        size: 12,
                        color: const Color(0xFFF59E0B),
                        weight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    'Total: ${record.totalBreakDuration}',
                    style: AppStyle.text(
                        size: 12, color: const Color(0xFFF59E0B)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _verticalDivider() => Container(
        width: 1,
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: AppStyle.borderColor,
      );

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PRESENT':
        return const Color(0xFF22C55E);
      case 'ABSENT':
        return const Color(0xFFEF4444);
      case 'LATE':
        return const Color(0xFFF59E0B);
      case 'HALF_DAY':
        return const Color(0xFF8B5CF6);
      default:
        return AppStyle.hintColor;
    }
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  const _Avatar({required this.name});

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        gradient: AppStyle.primaryGradient,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: AppStyle.text(
            size: 15, color: Colors.white, weight: FontWeight.w700),
      ),
    );
  }
}

class _TimeCell extends StatelessWidget {
  final IconData icon;
  final String label;
  final String time;
  final Color color;

  const _TimeCell({
    required this.icon,
    required this.label,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 4),
              Text(label,
                  style:
                      AppStyle.text(size: 11, color: AppStyle.hintColor)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: AppStyle.text(
                size: 13, weight: FontWeight.w700, color: color),
          ),
        ],
      ),
    );
  }
}