import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/shift/data/model/shiftmodel.dart';
import 'package:offixoadmin/features/shift/presentation/provider/shiftprovider.dart';
import 'package:provider/provider.dart';

class ShiftScreen extends StatelessWidget {
  const ShiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShiftProvider(),
      child: const _ShiftView(),
    );
  }
}

class _ShiftView extends StatelessWidget {
  const _ShiftView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ShiftProvider>();

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ── App Bar ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shifts',
                      style:
                          AppStyle.text(size: 20, weight: FontWeight.w700)),
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFFCDD2)),
                      ),
                      child: Row(
                        children: [
                          Text('Close',
                              style: AppStyle.text(
                                  size: 13,
                                  color: const Color(0xFFE53935),
                                  weight: FontWeight.w500)),
                          const SizedBox(width: 4),
                          const Icon(Icons.close,
                              size: 14, color: Color(0xFFE53935)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Body ──
              Expanded(child: _buildBody(context, provider)),

              // ── Create Button ──
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _showCreateSheet(context, provider),
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppStyle.primaryGradient,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text('Create Shift',
                      style: AppStyle.text(
                          size: 15,
                          color: Colors.white,
                          weight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ShiftProvider provider) {
    switch (provider.state) {
      case ShiftLoadState.idle:
      case ShiftLoadState.loading:
        return const Center(
            child: CircularProgressIndicator(color: AppStyle.accentCyan));

      case ShiftLoadState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text('Failed to load shifts',
                  style: AppStyle.text(color: Colors.grey)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: provider.fetchShifts,
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

      case ShiftLoadState.loaded:
        if (provider.shifts.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.schedule_outlined,
                    size: 56, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text('No shifts yet',
                    style: AppStyle.text(color: Colors.grey)),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('All Shifts',
                style: AppStyle.text(
                    size: 14,
                    color: AppStyle.accentCyan,
                    weight: FontWeight.w700)),
            const SizedBox(height: 12),
            Expanded(
              child: RefreshIndicator(
                onRefresh: provider.fetchShifts,
                color: AppStyle.accentCyan,
                child: ListView.separated(
                  itemCount: provider.shifts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final shift = provider.shifts[i];
                    return _ShiftCard(
                      shift: shift,
                      onEdit: () => _showEditSheet(context, provider, shift),
                      onDelete: () =>
                          _confirmDelete(context, provider, shift),
                    );
                  },
                ),
              ),
            ),
          ],
        );
    }
  }

  void _showCreateSheet(BuildContext context, ShiftProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: const _ShiftFormSheet(),
      ),
    );
  }

  void _showEditSheet(
      BuildContext context, ShiftProvider provider, ShiftModel shift) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: _ShiftFormSheet(existing: shift),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, ShiftProvider provider, ShiftModel shift) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Shift',
            style: AppStyle.text(size: 16, weight: FontWeight.w700)),
        content: Text(
          'Delete "${shift.shiftName}"? This cannot be undone.',
          style: AppStyle.text(size: 13, color: AppStyle.hintColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: AppStyle.text(color: AppStyle.hintColor)),
          ),
          GestureDetector(
            onTap: () async {
              Navigator.pop(ctx);
              await provider.delete(id: shift.id, context: context);
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
// SHIFT CARD
// ─────────────────────────────────────────────

class _ShiftCard extends StatelessWidget {
  final ShiftModel shift;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ShiftCard({
    required this.shift,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF00BCD4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.schedule_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shift.shiftName,
                    style:
                        AppStyle.text(size: 14, weight: FontWeight.w600)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 12, color: AppStyle.hintColor),
                    const SizedBox(width: 4),
                    Text(
                      '${shift.startTimeDisplay} - ${shift.endTimeDisplay}',
                      style: AppStyle.text(
                          size: 12, color: AppStyle.hintColor),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppStyle.hintColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${shift.regularWorkingHours}h',
                      style: AppStyle.text(
                          size: 12,
                          color: AppStyle.accentCyan,
                          weight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Three-dot menu
          GestureDetector(
            onTap: () => _showMenu(context),
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.more_vert_rounded,
                  size: 18, color: AppStyle.hintColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(shift.shiftName,
                      style:
                          AppStyle.text(size: 15, weight: FontWeight.w700)),
                ),
              ),
              const Divider(height: 20),
              ListTile(
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit_outlined,
                      size: 18, color: AppStyle.accentCyan),
                ),
                title: Text('Edit',
                    style: AppStyle.text(size: 14, weight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(ctx);
                  onEdit();
                },
              ),
              ListTile(
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete_outline_rounded,
                      size: 18, color: Color(0xFFE53935)),
                ),
                title: Text('Delete',
                    style: AppStyle.text(
                        size: 14,
                        color: const Color(0xFFE53935),
                        weight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(ctx);
                  onDelete();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FORM SHEET — Create / Edit
// ─────────────────────────────────────────────

class _ShiftFormSheet extends StatefulWidget {
  final ShiftModel? existing;
  const _ShiftFormSheet({this.existing});

  @override
  State<_ShiftFormSheet> createState() => _ShiftFormSheetState();
}

class _ShiftFormSheetState extends State<_ShiftFormSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _hoursCtrl;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl =
        TextEditingController(text: widget.existing?.shiftName ?? '');
    _hoursCtrl = TextEditingController(
        text: widget.existing?.regularWorkingHours.toString() ?? '');

    if (widget.existing != null) {
      _startTime = _parseTime(widget.existing!.startTime);
      _endTime = _parseTime(widget.existing!.endTime);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _hoursCtrl.dispose();
    super.dispose();
  }

  TimeOfDay _parseTime(String raw) {
    final parts = raw.split(':');
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 0,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  /// TimeOfDay -> "HH:mm:00"
  String _formatForApi(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m:00';
  }

  String _formatForDisplay(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '${h.toString().padLeft(2, '0')}:$m $period';
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? _startTime : _endTime) ??
          const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppStyle.accentCyan,
            onPrimary: Colors.white,
            onSurface: AppStyle.fontColor,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
        _autoCalculateHours();
      });
    }
  }

  void _autoCalculateHours() {
    if (_startTime == null || _endTime == null) return;
    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    var endMinutes = _endTime!.hour * 60 + _endTime!.minute;
    if (endMinutes <= startMinutes) endMinutes += 24 * 60; // overnight shift
    final totalHours = (endMinutes - startMinutes) / 60;
    _hoursCtrl.text = totalHours.truncate().toString();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      _showSnack('Shift name is required');
      return;
    }
    if (_startTime == null) {
      _showSnack('Please select a start time');
      return;
    }
    if (_endTime == null) {
      _showSnack('Please select an end time');
      return;
    }
    final hours = int.tryParse(_hoursCtrl.text.trim());
    if (hours == null) {
      _showSnack('Working hours must be a number');
      return;
    }

    final provider = context.read<ShiftProvider>();
    bool ok;

    if (_isEdit) {
      ok = await provider.update(
        id: widget.existing!.id,
        shiftName: name,
        startTime: _formatForApi(_startTime!),
        endTime: _formatForApi(_endTime!),
        regularWorkingHours: hours,
        context: context,
      );
    } else {
      ok = await provider.create(
        shiftName: name,
        startTime: _formatForApi(_startTime!),
        endTime: _formatForApi(_endTime!),
        regularWorkingHours: hours,
        context: context,
      );
    }

    if (ok && mounted) Navigator.maybePop(context);
  }

  void _showSnack(String message) {
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
    final provider = context.watch<ShiftProvider>();
    final bottomPad = MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppStyle.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 20),
      child: SingleChildScrollView(
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
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),

            // Title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_isEdit ? 'Edit Shift' : 'Create Shift',
                    style:
                        AppStyle.text(size: 18, weight: FontWeight.w700)),
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFFCDD2)),
                    ),
                    child: Row(
                      children: [
                        Text('Close',
                            style: AppStyle.text(
                                size: 13,
                                color: const Color(0xFFE53935),
                                weight: FontWeight.w500)),
                        const SizedBox(width: 4),
                        const Icon(Icons.close,
                            size: 14, color: Color(0xFFE53935)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Form card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shift Name
                  _Label(text: 'Shift Name', required: true),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameCtrl,
                    autofocus: true,
                    style: AppStyle.text(size: 13),
                    decoration: _inputDec('Eg: General Shift'),
                  ),
                  const SizedBox(height: 16),

                  // Start / End time row
                  Row(
                    children: [
                      Expanded(
                        child: _TimePickerField(
                          label: 'Start Time',
                          time: _startTime,
                          display: _startTime != null
                              ? _formatForDisplay(_startTime!)
                              : null,
                          onTap: () => _pickTime(isStart: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TimePickerField(
                          label: 'End Time',
                          time: _endTime,
                          display: _endTime != null
                              ? _formatForDisplay(_endTime!)
                              : null,
                          onTap: () => _pickTime(isStart: false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Working hours
                  _Label(text: 'Regular Working Hours', required: true),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _hoursCtrl,
                    keyboardType: TextInputType.number,
                    style: AppStyle.text(size: 13),
                    decoration: _inputDec('Eg: 8').copyWith(
                      suffixText: 'hrs',
                      suffixStyle: AppStyle.text(
                          size: 12, color: AppStyle.hintColor),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Auto-calculated from start/end time. You can adjust manually.',
                    style:
                        AppStyle.text(size: 11, color: AppStyle.hintColor),
                  ),
                  const SizedBox(height: 20),

                  // Submit button
                  GestureDetector(
                    onTap: provider.isSubmitting ? null : _submit,
                    child: Container(
                      width: double.infinity,
                      height: 50,
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
                              _isEdit ? 'Save Changes' : 'Create',
                              style: AppStyle.text(
                                  size: 15,
                                  color: Colors.white,
                                  weight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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

// ── Small label widget with required-asterisk ──

class _Label extends StatelessWidget {
  final String text;
  final bool required;
  const _Label({required this.text, this.required = false});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: AppStyle.text(size: 13, weight: FontWeight.w500),
        children: required
            ? [
                TextSpan(
                    text: ' *',
                    style: AppStyle.text(
                        size: 13, color: const Color(0xFFE53935)))
              ]
            : [],
      ),
    );
  }
}

// ── Clock-style time picker field ──

class _TimePickerField extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final String? display;
  final VoidCallback onTap;

  const _TimePickerField({
    required this.label,
    required this.time,
    required this.display,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(text: label, required: true),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: time != null
                    ? AppStyle.accentCyan
                    : AppStyle.borderColor,
              ),
              color: time != null
                  ? AppStyle.accentCyan.withOpacity(0.05)
                  : Colors.white,
            ),
            child: Row(
              children: [
                Icon(Icons.access_time_rounded,
                    size: 16,
                    color: time != null
                        ? AppStyle.accentCyan
                        : AppStyle.hintColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    display ?? 'Select',
                    style: AppStyle.text(
                      size: 13,
                      weight: time != null
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: time != null
                          ? AppStyle.accentCyan
                          : AppStyle.hintColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}