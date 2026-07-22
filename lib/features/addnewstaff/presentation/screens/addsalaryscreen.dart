import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/addnewstaff/domain/addstaffmodel.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/provider/addsalary.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/widgets/appdropdown.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/widgets/formfiled.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/widgets/sectiontitle.dart';
import 'package:provider/provider.dart';
import 'package:offixoadmin/common/shimmer/shimmer_container.dart';

import 'package:offixoadmin/features/staffdetails/data/models/payslipmodel.dart';

class AddSalaryScreen extends StatelessWidget {
  final MemberModel member;
  final bool isEditMode;
  final Payslip? existingPayslip;
  const AddSalaryScreen({super.key, required this.member, this.isEditMode = false, this.existingPayslip});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddSalaryProvider(),
      child: _AddSalaryView(member: member, isEditMode: isEditMode, existingPayslip: existingPayslip),
    );
  }
}

class _AddSalaryView extends StatefulWidget {
  final MemberModel member;
  final bool isEditMode;
  final Payslip? existingPayslip;
  const _AddSalaryView({required this.member, this.isEditMode = false, this.existingPayslip});

  @override
  State<_AddSalaryView> createState() => _AddSalaryViewState();
}

class _AddSalaryViewState extends State<_AddSalaryView> {
  // Fixed salary type as MONTHLY
  final String _salaryType = 'MONTHLY';
  final _totalSalaryCtrl = TextEditingController();
  final _pfCtrl = TextEditingController();
  final _insuranceCtrl = TextEditingController();
  final _otherDeductionCtrl = TextEditingController();
  // Keep controllers but won't be used
  final _hourlyRateCtrl = TextEditingController();
  final _workingHoursCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.existingPayslip != null) {
      final slip = widget.existingPayslip!;
      _totalSalaryCtrl.text = slip.baseSalary != '0' ? slip.baseSalary : '';
      _pfCtrl.text = slip.pfAmount != '0' ? slip.pfAmount : '';
      _insuranceCtrl.text = slip.insuranceAmount != '0' ? slip.insuranceAmount : '';
      _otherDeductionCtrl.text = slip.otherDeduction != '0' ? slip.otherDeduction : '';
    }
  }

  @override
  void dispose() {
    _totalSalaryCtrl.dispose();
    _pfCtrl.dispose();
    _insuranceCtrl.dispose();
    _otherDeductionCtrl.dispose();
    _hourlyRateCtrl.dispose();
    _workingHoursCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final provider = context.read<AddSalaryProvider>();
    final ok = await provider.submit(
      memberId: widget.member.id,
      salaryType: _salaryType, // Always MONTHLY
      totalSalary: _totalSalaryCtrl.text,
      pfAmount: _pfCtrl.text,
      insuranceAmount: _insuranceCtrl.text,
      otherDeduction: _otherDeductionCtrl.text,
      hourlyRate: '', // Not needed for MONTHLY
      workingHours: '', // Not needed for MONTHLY
      isEditMode: widget.isEditMode,
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
            child:
                provider.isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                    : Text(
                      'Save Salary',
                      style: AppStyle.text(
                        size: 15,
                        color: Colors.white,
                        weight: FontWeight.w600,
                      ),
                    ),
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
                  Expanded(
                    child: Text(
                      'Salary Details',
                      style: AppStyle.text(size: 20, weight: FontWeight.w700),
                    ),
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
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.member.fullName,
                            style: AppStyle.text(
                              size: 14,
                              weight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.member.empNo,
                            style: AppStyle.text(
                              size: 12,
                              color: AppStyle.hintColor,
                            ),
                          ),
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

              // Salary Type - Fixed as MONTHLY (non-editable)
              FormFields(
                label: 'Salary Type',
                isRequired: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppStyle.borderColor),
                    color: Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Monthly',
                        style: AppStyle.text(
                          size: 13,
                          color: AppStyle.fontColor,
                          weight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: AppStyle.accentCyan,
                      ),
                    ],
                  ),
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
                  decoration: _inputDec(
                    'Eg: 50000',
                  ).copyWith(errorText: provider.errors['totalSalary']),
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
                  decoration: _inputDec(
                    'Eg: 2000',
                  ).copyWith(errorText: provider.errors['pfAmount']),
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
                  decoration: _inputDec(
                    'Eg: 1000',
                  ).copyWith(errorText: provider.errors['insuranceAmount']),
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
                  decoration: _inputDec(
                    'Eg: 500',
                  ).copyWith(errorText: provider.errors['otherDeduction']),
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
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );
}
