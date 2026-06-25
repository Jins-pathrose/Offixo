import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/leavetype/data/model/leavetypemodel.dart';
import 'package:offixoadmin/features/leavetype/presentation/provider/leavetypeprovider.dart';
import 'package:offixoadmin/features/leavetype/presentation/widgets/leavesettingsheet.dart';

import 'package:provider/provider.dart';

class LeaveTypeScreen extends StatelessWidget {
  const LeaveTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LeaveTypeProvider(),
      child: const _LeaveTypeView(),
    );
  }
}

class _LeaveTypeView extends StatelessWidget {
  const _LeaveTypeView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeaveTypeProvider>();

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFormSheet(context, provider),
        backgroundColor: AppStyle.accentCyan,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('New Leave Type',
            style: AppStyle.text(
                size: 13, color: Colors.white, weight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: const Icon(Icons.arrow_back_rounded, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Leave Types',
                        style: AppStyle.text(
                            size: 20, weight: FontWeight.w700)),
                  ),
                  // ── Settings icon ──
                  GestureDetector(
                    onTap: () => showLeaveSettingsMenu(context),
                    child: Container(
                      width: 38,
                      height: 38,
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
                      child: const Icon(Icons.settings_outlined,
                          size: 19, color: AppStyle.fontColor),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ──
            Expanded(child: _buildBody(context, provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, LeaveTypeProvider provider) {
    switch (provider.state) {
      case LeaveTypeLoadState.idle:
      case LeaveTypeLoadState.loading:
        return const Center(
            child: CircularProgressIndicator(color: AppStyle.accentCyan));

      case LeaveTypeLoadState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text('Failed to load leave types',
                  style: AppStyle.text(color: Colors.grey)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: provider.fetchLeaveTypes,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: AppStyle.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Retry',
                      style: AppStyle.text(
                          color: Colors.white, weight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );

      case LeaveTypeLoadState.loaded:
        if (provider.leaveTypes.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.event_busy_outlined,
                    size: 56, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text('No leave types yet',
                    style: AppStyle.text(color: Colors.grey)),
                const SizedBox(height: 6),
                Text('Tap + to create one',
                    style: AppStyle.text(
                        size: 12, color: Colors.grey.shade400)),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: provider.fetchLeaveTypes,
          color: AppStyle.accentCyan,
          child: ListView.separated(
            padding:
                const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: provider.leaveTypes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) => _LeaveTypeCard(
              leaveType: provider.leaveTypes[i],
              onEdit: () =>
                  _showFormSheet(context, provider,
                      existing: provider.leaveTypes[i]),
              onDelete: () =>
                  _confirmDelete(context, provider, provider.leaveTypes[i]),
            ),
          ),
        );
    }
  }

  void _showFormSheet(BuildContext context, LeaveTypeProvider provider,
      {LeaveTypeModel? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: _LeaveTypeFormSheet(existing: existing),
      ),
    );
  }

  void _confirmDelete(BuildContext context, LeaveTypeProvider provider,
      LeaveTypeModel leave) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Leave Type',
            style: AppStyle.text(size: 16, weight: FontWeight.w700)),
        content: Text(
          'Delete "${leave.name}"? This cannot be undone.',
          style: AppStyle.text(size: 13, color: AppStyle.hintColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text('Cancel', style: AppStyle.text(color: AppStyle.hintColor)),
          ),
          GestureDetector(
            onTap: () async {
              Navigator.pop(ctx);
              await provider.delete(id: leave.id, context: context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Delete',
                  style: AppStyle.text(
                      color: Colors.white, weight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LEAVE TYPE CARD
// ─────────────────────────────────────────────

class _LeaveTypeCard extends StatelessWidget {
  final LeaveTypeModel leaveType;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _LeaveTypeCard({
    required this.leaveType,
    required this.onEdit,
    required this.onDelete,
  });

  Color get _codeColor {
    switch (leaveType.code) {
      case 'SL': return const Color(0xFF00ACC1);
      case 'CL': return const Color(0xFF22C55E);
      case 'RH': return const Color(0xFFFF9800);
      default:   return AppStyle.accentCyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _codeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(leaveType.code,
                style: AppStyle.text(
                    size: 13,
                    color: _codeColor,
                    weight: FontWeight.w800)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(leaveType.name,
                          style: AppStyle.text(
                              size: 14, weight: FontWeight.w600)),
                    ),
                    if (leaveType.isRestrictedHoliday)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9800).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('Restricted',
                            style: AppStyle.text(
                                size: 10,
                                color: const Color(0xFFFF9800),
                                weight: FontWeight.w600)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${leaveType.totalDaysPerYear} days/year',
                  style: AppStyle.text(
                      size: 12, color: AppStyle.hintColor),
                ),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit_outlined,
                      size: 16, color: AppStyle.accentCyan),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete_outline_rounded,
                      size: 16, color: Color(0xFFE53935)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LEAVE TYPE FORM SHEET (Create / Edit)
// ─────────────────────────────────────────────

class _LeaveTypeFormSheet extends StatefulWidget {
  final LeaveTypeModel? existing;
  const _LeaveTypeFormSheet({this.existing});

  @override
  State<_LeaveTypeFormSheet> createState() => _LeaveTypeFormSheetState();
}

class _LeaveTypeFormSheetState extends State<_LeaveTypeFormSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _daysCtrl;
  bool _isRestricted = false;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl =
        TextEditingController(text: widget.existing?.name ?? '');
    _codeCtrl =
        TextEditingController(text: widget.existing?.code ?? '');
    _daysCtrl = TextEditingController(
        text: widget.existing?.totalDaysPerYear.toString() ?? '');
    _isRestricted = widget.existing?.isRestrictedHoliday ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _daysCtrl.dispose();
    super.dispose();
  }

  String? _validate() {
    if (_nameCtrl.text.trim().isEmpty) return 'Name is required';
    if (_codeCtrl.text.trim().isEmpty) return 'Code is required';
    if (_daysCtrl.text.trim().isEmpty) return 'Days per year is required';
    if (int.tryParse(_daysCtrl.text.trim()) == null)
      return 'Days must be a number';
    return null;
  }

  Future<void> _submit() async {
    final err = _validate();
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ));
      return;
    }

    final provider = context.read<LeaveTypeProvider>();
    bool ok;

    if (_isEdit) {
      ok = await provider.update(
        id: widget.existing!.id,
        name: _nameCtrl.text,
        code: _codeCtrl.text,
        totalDays: int.parse(_daysCtrl.text.trim()),
        isRestricted: _isRestricted,
        context: context,
      );
    } else {
      ok = await provider.create(
        name: _nameCtrl.text,
        code: _codeCtrl.text,
        totalDays: int.parse(_daysCtrl.text.trim()),
        isRestricted: _isRestricted,
        context: context,
      );
    }

    if (ok && mounted) Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeaveTypeProvider>();
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
          Text(_isEdit ? 'Edit Leave Type' : 'New Leave Type',
              style: AppStyle.text(size: 17, weight: FontWeight.w700)),
          const SizedBox(height: 20),
          _FormField(label: 'Leave Type Name', isRequired: true,
            child: TextField(
              controller: _nameCtrl,
              style: AppStyle.text(size: 13),
              decoration: _inputDec('Eg: Sick Leave'),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _FormField(label: 'Code', isRequired: true,
                  child: TextField(
                    controller: _codeCtrl,
                    textCapitalization: TextCapitalization.characters,
                    style: AppStyle.text(size: 13),
                    decoration: _inputDec('Eg: SL'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FormField(label: 'Days / Year', isRequired: true,
                  child: TextField(
                    controller: _daysCtrl,
                    keyboardType: TextInputType.number,
                    style: AppStyle.text(size: 13),
                    decoration: _inputDec('Eg: 12'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => setState(() => _isRestricted = !_isRestricted),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: _isRestricted
                    ? const Color(0xFFFF9800).withOpacity(0.08)
                    : AppStyle.backgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _isRestricted
                      ? const Color(0xFFFF9800).withOpacity(0.4)
                      : AppStyle.borderColor,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isRestricted
                        ? Icons.check_box_rounded
                        : Icons.check_box_outline_blank_rounded,
                    color: _isRestricted
                        ? const Color(0xFFFF9800)
                        : AppStyle.hintColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This is a Restricted Holiday',
                      style: AppStyle.text(
                        size: 13,
                        color: _isRestricted
                            ? const Color(0xFFFF9800)
                            : AppStyle.fontColor,
                        weight: _isRestricted
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: provider.isSubmitting ? null : _submit,
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
                  : Text(
                      _isEdit ? 'Save Changes' : 'Create Leave Type',
                      style: AppStyle.text(
                          size: 15,
                          color: Colors.white,
                          weight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: AppStyle.text(size: 13, color: AppStyle.hintColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppStyle.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppStyle.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppStyle.accentCyan),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      );
}

class _FormField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final Widget child;

  const _FormField({
    required this.label,
    required this.child,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppStyle.text(size: 13, weight: FontWeight.w500),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: AppStyle.text(
                          size: 13, color: const Color(0xFFE53935)),
                    )
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}