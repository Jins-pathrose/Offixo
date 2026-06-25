import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/checkincheckouts/presentation/provider/checkincheckoutprovider.dart';
import 'package:offixoadmin/features/checkincheckouts/presentation/widgets/employeeattendancecard.dart';
import 'package:provider/provider.dart';


class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AttendanceProvider(),
      child: const _AttendanceView(),
    );
  }
}

class _AttendanceView extends StatelessWidget {
  const _AttendanceView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>();

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ──
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 16, color: AppStyle.fontColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Attendance',
                        style: AppStyle.text(
                            size: 20, weight: FontWeight.w700)),
                  ),
                  // Date picker button
                  GestureDetector(
                    onTap: () => _pickDate(context, provider),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppStyle.borderColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              size: 14, color: AppStyle.accentCyan),
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(provider.selectedDate),
                            style: AppStyle.text(
                                size: 12,
                                weight: FontWeight.w600,
                                color: AppStyle.accentCyan),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Branch filter ──
            if (provider.branches.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _BranchFilter(provider: provider),
              ),

            const SizedBox(height: 12),

            // ── Summary strip ──
            if (provider.state == AttendanceLoadState.loaded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _SummaryStrip(provider: provider),
              ),

            const SizedBox(height: 12),

            // ── List ──
            Expanded(child: _buildBody(context, provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AttendanceProvider provider) {
    switch (provider.state) {
      case AttendanceLoadState.idle:
      case AttendanceLoadState.loading:
        return const Center(
            child: CircularProgressIndicator(color: AppStyle.accentCyan));

      case AttendanceLoadState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text('Failed to load',
                  style: AppStyle.text(color: Colors.grey)),
              if (provider.errorMessage != null) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(provider.errorMessage!,
                      style: AppStyle.text(
                          size: 12, color: AppStyle.hintColor),
                      textAlign: TextAlign.center),
                ),
              ],
              const SizedBox(height: 16),
              GestureDetector(
                onTap: provider.loadAttendance,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: AppStyle.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Retry',
                      style: AppStyle.text(
                          color: Colors.white,
                          weight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );

      case AttendanceLoadState.loaded:
        if (provider.records.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.event_busy_rounded,
                    size: 52,
                    color: AppStyle.hintColor.withOpacity(0.4)),
                const SizedBox(height: 12),
                Text('No attendance records',
                    style: AppStyle.text(
                        size: 15, color: AppStyle.hintColor)),
                const SizedBox(height: 4),
                Text('for ${_formatDate(provider.selectedDate)}',
                    style: AppStyle.text(
                        size: 13, color: AppStyle.hintColor)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: provider.loadAttendance,
          color: AppStyle.accentCyan,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.records.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) =>
                EmployeeAttendanceCard(record: provider.records[index]),
          ),
        );
    }
  }

  Future<void> _pickDate(
      BuildContext context, AttendanceProvider provider) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppStyle.accentCyan,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) provider.setDate(picked);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// ── Branch filter chips ───────────────────────────────────────────────────────

class _BranchFilter extends StatelessWidget {
  final AttendanceProvider provider;
  const _BranchFilter({required this.provider});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // "All" chip
          _BranchChip(
            label: 'All Branches',
            selected: provider.selectedBranch == null,
            onTap: () => provider.selectBranch(null),
          ),
          const SizedBox(width: 8),
          ...provider.branches.map((branch) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _BranchChip(
                  label: branch.name,
                  selected: provider.selectedBranch?.id == branch.id,
                  onTap: () => provider.selectBranch(branch),
                ),
              )),
        ],
      ),
    );
  }
}

class _BranchChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BranchChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: selected ? AppStyle.primaryGradient : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                selected ? Colors.transparent : AppStyle.borderColor,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppStyle.accentCyan.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: AppStyle.text(
            size: 12,
            weight: FontWeight.w600,
            color: selected ? Colors.white : AppStyle.hintColor,
          ),
        ),
      ),
    );
  }
}

// ── Summary strip ─────────────────────────────────────────────────────────────

class _SummaryStrip extends StatelessWidget {
  final AttendanceProvider provider;
  const _SummaryStrip({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _SummaryChip(
            label: 'Total',
            count: provider.totalCount,
            color: AppStyle.accentCyan,
          ),
          _divider(),
          _SummaryChip(
            label: 'Present',
            count: provider.presentCount,
            color: const Color(0xFF22C55E),
          ),
          _divider(),
          _SummaryChip(
            label: 'Absent',
            count: provider.absentCount,
            color: const Color(0xFFEF4444),
          ),
          _divider(),
          _SummaryChip(
            label: 'Late',
            count: provider.lateCount,
            color: const Color(0xFFF59E0B),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 28,
        color: AppStyle.borderColor,
      );
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _SummaryChip(
      {required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text('$count',
              style: AppStyle.text(
                  size: 18, weight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: AppStyle.text(
                  size: 11, color: AppStyle.hintColor)),
        ],
      ),
    );
  }
}