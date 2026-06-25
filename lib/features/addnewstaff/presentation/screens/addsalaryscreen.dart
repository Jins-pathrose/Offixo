import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/addnewstaff/domain/addstaffmodel.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/provider/addsalary.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/widgets/appdropdown.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/widgets/formfiled.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/widgets/sectiontitle.dart';
import 'package:provider/provider.dart';

const List<Map<String, String>> _salaryTypeChoices = [
  {'id': 'MONTHLY', 'name': 'Monthly'},
  {'id': 'HOURLY', 'name': 'Hourly'},
  {'id': 'DAILY', 'name': 'Daily'},
];

class AddSalaryScreen extends StatelessWidget {
  final MemberModel member;
  const AddSalaryScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddSalaryProvider(),
      child: _AddSalaryView(member: member),
    );
  }
}

class _AddSalaryView extends StatefulWidget {
  final MemberModel member;
  const _AddSalaryView({required this.member});

  @override
  State<_AddSalaryView> createState() => _AddSalaryViewState();
}

class _AddSalaryViewState extends State<_AddSalaryView> {
  String? _salaryType;
  final _totalSalaryCtrl = TextEditingController();
  final _pfCtrl = TextEditingController();
  final _insuranceCtrl = TextEditingController();
  final _otherDeductionCtrl = TextEditingController();

  @override
  void dispose() {
    _totalSalaryCtrl.dispose();
    _pfCtrl.dispose();
    _insuranceCtrl.dispose();
    _otherDeductionCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = context.read<AddSalaryProvider>();
    final ok = await provider.submit(
      memberId: widget.member.id,
      salaryType: _salaryType ?? '',
      totalSalary: _totalSalaryCtrl.text,
      pfAmount: _pfCtrl.text,
      insuranceAmount: _insuranceCtrl.text,
      otherDeduction: _otherDeductionCtrl.text,
      context: context,
    );

    // Pop back to staff list (close both this screen and the previous one)
    if (ok && mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddSalaryProvider>();

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: GestureDetector(
          onTap: provider.isLoading ? null : _submit,
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              gradient: AppStyle.primaryGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: provider.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  )
                : Text('Save Salary',
                    style: AppStyle.text(
                        size: 15,
                        color: Colors.white,
                        weight: FontWeight.w600)),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── App Bar ──
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
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
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 16, color: AppStyle.fontColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Salary Details',
                        style: AppStyle.text(
                            size: 20, weight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Member info card ──
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        gradient: AppStyle.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _initials(widget.member.fullName),
                        style: AppStyle.text(
                            size: 14,
                            color: Colors.white,
                            weight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.member.fullName,
                              style: AppStyle.text(
                                  size: 14, weight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(widget.member.empNo,
                              style: AppStyle.text(
                                  size: 12, color: AppStyle.hintColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ════════════════════════════════
              //  SECTION: Salary Details
              // ════════════════════════════════
              const SectionTitle(title: 'Salary Details'),
              const SizedBox(height: 14),

              // Salary Type
              FormFields(
                label: 'Salary Type',
                isRequired: true,
                child: AppDropdown(
                  hint: 'Select Salary Type',
                  value: _salaryType,
                  items: _salaryTypeChoices.map((e) => e['id']!).toList(),
                  itemLabels: {
                    for (final e in _salaryTypeChoices) e['id']!: e['name']!
                  },
                  onChanged: (v) => setState(() => _salaryType = v),
                  errorText: provider.errors['salaryType'],
                ),
              ),
              const SizedBox(height: 14),

              // Total Salary
              FormFields(
                label: 'Total Salary',
                isRequired: true,
                child: TextField(
                  controller: _totalSalaryCtrl,
                  keyboardType: TextInputType.number,
                  style: AppStyle.text(size: 13),
                  decoration: _inputDec('Eg: 50000')
                      .copyWith(errorText: provider.errors['totalSalary']),
                ),
              ),
              const SizedBox(height: 14),

              // PF Amount
              FormFields(
                label: 'PF Amount',
                child: TextField(
                  controller: _pfCtrl,
                  keyboardType: TextInputType.number,
                  style: AppStyle.text(size: 13),
                  decoration: _inputDec('Eg: 2000')
                      .copyWith(errorText: provider.errors['pfAmount']),
                ),
              ),
              const SizedBox(height: 14),

              // Insurance Amount
              FormFields(
                label: 'Insurance Amount',
                child: TextField(
                  controller: _insuranceCtrl,
                  keyboardType: TextInputType.number,
                  style: AppStyle.text(size: 13),
                  decoration: _inputDec('Eg: 1000').copyWith(
                      errorText: provider.errors['insuranceAmount']),
                ),
              ),
              const SizedBox(height: 14),

              // Other Deduction
              FormFields(
                label: 'Other Deduction',
                child: TextField(
                  controller: _otherDeductionCtrl,
                  keyboardType: TextInputType.number,
                  style: AppStyle.text(size: 13),
                  decoration: _inputDec('Eg: 500').copyWith(
                      errorText: provider.errors['otherDeduction']),
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
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