import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:provider/provider.dart';
import 'package:offixoadmin/features/leavetype/presentation/provider/leavesettingsprovider.dart';

// ─────────────────────────────────────────────
// ENTRY POINT — call this from the settings icon
// ─────────────────────────────────────────────

void showLeaveSettingsMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ChangeNotifierProvider(
      create: (_) => LeaveSettingsProvider(),
      child: const _LeaveSettingsMenuSheet(),
    ),
  );
}

// ─────────────────────────────────────────────
// MENU SHEET (2 options)
// ─────────────────────────────────────────────

class _LeaveSettingsMenuSheet extends StatelessWidget {
  const _LeaveSettingsMenuSheet();

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Text('Leave Settings',
              style: AppStyle.text(size: 17, weight: FontWeight.w700)),
          const SizedBox(height: 20),

          _SettingsOptionTile(
            icon: Icons.refresh_rounded,
            iconColor: AppStyle.accentCyan,
            title: 'Annual Leave Balance Renewal',
            subtitle: 'Reset leave balances for a new year',
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => LeaveSettingsProvider(),
                  child: const _AnnualResetSheet(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _SettingsOptionTile(
            icon: Icons.calendar_view_week_rounded,
            iconColor: const Color(0xFFFF9800),
            title: 'Saturday Leave Configuration',
            subtitle: 'Set Saturday off-rule for a branch',
            onTap: () {
              Navigator.pop(context);
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => ChangeNotifierProvider(
                  create: (_) => LeaveSettingsProvider(),
                  child: const _SaturdayConfigSheet(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsOptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsOptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppStyle.backgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          AppStyle.text(size: 14, weight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: AppStyle.text(
                          size: 12, color: AppStyle.hintColor)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppStyle.hintColor, size: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// 1. ANNUAL LEAVE RESET SHEET
// ─────────────────────────────────────────────

class _AnnualResetSheet extends StatefulWidget {
  const _AnnualResetSheet();

  @override
  State<_AnnualResetSheet> createState() => _AnnualResetSheetState();
}

class _AnnualResetSheetState extends State<_AnnualResetSheet> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year + 1; // default to next year
  }

  Future<void> _confirmAndSubmit(LeaveSettingsProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Confirm Reset',
            style: AppStyle.text(size: 16, weight: FontWeight.w700)),
        content: Text(
          'This will reset annual leave balances for all employees for the year $_selectedYear. Continue?',
          style: AppStyle.text(size: 13, color: AppStyle.hintColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel',
                style: AppStyle.text(color: AppStyle.hintColor)),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(ctx, true),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: AppStyle.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Confirm',
                  style: AppStyle.text(
                      color: Colors.white, weight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final ok = await provider.resetAnnualLeave(
          year: _selectedYear, context: context);
      if (ok && mounted) Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeaveSettingsProvider>();
    final bottomPad = MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;
    final currentYear = DateTime.now().year;
    final yearOptions =
        List.generate(5, (i) => currentYear - 1 + i); // -1 .. +3

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppStyle.accentCyan.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.refresh_rounded,
                    color: AppStyle.accentCyan, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Annual Leave Balance Renewal',
                    style:
                        AppStyle.text(size: 16, weight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'This will reset annual leave balances for all employees for the selected year.',
            style: AppStyle.text(size: 12, color: AppStyle.hintColor),
          ),
          const SizedBox(height: 20),

          Text('Select Year',
              style: AppStyle.text(size: 13, weight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppStyle.borderColor),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedYear,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppStyle.hintColor),
                style: AppStyle.text(size: 14),
                items: yearOptions
                    .map((y) => DropdownMenuItem(
                          value: y,
                          child: Text('$y'),
                        ))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedYear = val);
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          GestureDetector(
            onTap:
                provider.isSubmitting ? null : () => _confirmAndSubmit(provider),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: AppStyle.primaryGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: provider.isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text('Reset for $_selectedYear',
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

// ─────────────────────────────────────────────
// 2. SATURDAY CONFIG SHEET
// ─────────────────────────────────────────────

class _SaturdayConfigSheet extends StatefulWidget {
  const _SaturdayConfigSheet();

  @override
  State<_SaturdayConfigSheet> createState() => _SaturdayConfigSheetState();
}

class _SaturdayConfigSheetState extends State<_SaturdayConfigSheet> {
  int? _selectedBranchId;
  String? _selectedRule;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeaveSettingsProvider>().fetchBranches();
    });
  }

  Future<void> _submit(LeaveSettingsProvider provider) async {
    if (_selectedBranchId == null) {
      _showError('Please select a branch');
      return;
    }
    if (_selectedRule == null) {
      _showError('Please select a Saturday rule');
      return;
    }

    final ok = await provider.saveSaturdayConfig(
      branchId: _selectedBranchId!,
      saturdayRule: _selectedRule!,
      context: context,
    );
    if (ok && mounted) Navigator.maybePop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: const Color(0xFFE53935),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeaveSettingsProvider>();
    final bottomPad = MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.calendar_view_week_rounded,
                    color: Color(0xFFFF9800), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Saturday Leave Configuration',
                    style:
                        AppStyle.text(size: 16, weight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Configure which Saturdays are off for a specific branch.',
            style: AppStyle.text(size: 12, color: AppStyle.hintColor),
          ),
          const SizedBox(height: 20),

          // Branch dropdown
          Text('Branch',
              style: AppStyle.text(size: 13, weight: FontWeight.w500)),
          const SizedBox(height: 8),
          if (provider.isLoadingBranches)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Center(
                  child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppStyle.accentCyan),
              )),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppStyle.borderColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _selectedBranchId,
                  isExpanded: true,
                  hint: Text('Select branch',
                      style: AppStyle.text(
                          size: 13, color: AppStyle.hintColor)),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppStyle.hintColor),
                  style: AppStyle.text(size: 14),
                  items: provider.branches
                      .map((b) => DropdownMenuItem(
                            value: b.id,
                            child: Text(b.name),
                          ))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _selectedBranchId = val),
                ),
              ),
            ),
          const SizedBox(height: 16),

          // Saturday rule dropdown
          Text('Saturday Rule',
              style: AppStyle.text(size: 13, weight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppStyle.borderColor),
            ),
            child: DropdownButtonHideUnderline(
              
              child: DropdownButton<String>(
                value: _selectedRule,
                isExpanded: true,
                hint: Text('Select rule',
                    style:
                        AppStyle.text(size: 13, color: AppStyle.hintColor)),
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppStyle.hintColor),
                style: AppStyle.text(size: 13),
                items: saturdayRuleChoices
                    .map((choice) => DropdownMenuItem(
                          value: choice['id'],
                          child: Text(choice['name']!,
                              overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedRule = val),
              ),
            ),
          ),
          const SizedBox(height: 24),

          GestureDetector(
            onTap: provider.isSubmitting ? null : () => _submit(provider),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: AppStyle.primaryGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: provider.isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.5),
                    )
                  : Text('Save Configuration',
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