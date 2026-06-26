import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/staffdetails/data/models/payslipmodel.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/salarymeritcard.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/salaryrow.dart';
import 'package:offixoadmin/core/utils/pdf_service.dart';

class SalaryTab extends StatelessWidget {
  final Payslip? payslip;
  final int selectedMonth;
  final int selectedYear;
  final String staffName;
  final String empNo;
  final String department;
  final String designation;
  final Function(int month, int year)? onMonthChanged;

  const SalaryTab({
    this.payslip,
    required this.selectedMonth,
    required this.selectedYear,
    required this.staffName,
    required this.empNo,
    required this.department,
    required this.designation,
    this.onMonthChanged,
  });

  String _fmt(double v) => v
      .toStringAsFixed(2)
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');

  Future<void> _showMonthPicker(BuildContext context) async {
    final now = DateTime.now();
    int tempMonth = selectedMonth;
    int tempYear = selectedYear;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Month', style: AppStyle.text(size: 16, weight: FontWeight.w700)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, size: 16),
                        onPressed: () => setState(() => tempYear--),
                      ),
                      Text('$tempYear', style: AppStyle.text(size: 16, weight: FontWeight.w600)),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: tempYear < now.year ? () => setState(() => tempYear++) : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(12, (index) {
                      final month = index + 1;
                      final isSelected = month == tempMonth;
                      final isFuture = tempYear == now.year && month > now.month;
                      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                      return InkWell(
                        onTap: isFuture ? null : () {
                          setState(() => tempMonth = month);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF00BCD4) : (isFuture ? Colors.grey.shade200 : Colors.transparent),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isSelected ? const Color(0xFF00BCD4) : Colors.grey.shade300),
                          ),
                          child: Text(
                            months[index],
                            style: AppStyle.text(
                              size: 12,
                              color: isSelected ? Colors.white : (isFuture ? Colors.grey.shade400 : Colors.black),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: AppStyle.text(size: 14, color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onMonthChanged != null) {
                      onMonthChanged!(tempMonth, tempYear);
                    }
                  },
                  child: Text('Apply', style: AppStyle.text(size: 14, color: const Color(0xFF00BCD4), weight: FontWeight.w600)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final monthLabel = payslip != null ? payslip!.monthLabel : months[selectedMonth - 1];

    Widget headerWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Salary Details',
            style: AppStyle.text(size: 15, weight: FontWeight.w700)),
        GestureDetector(
          onTap: () => _showMonthPicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF00BCD4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(monthLabel,
                    style: AppStyle.text(
                        size: 12, color: Colors.white, weight: FontWeight.w500)),
                const SizedBox(width: 4),
                const Icon(Icons.calendar_month_outlined,
                    size: 14, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );

    if (payslip == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerWidget,
            const SizedBox(height: 32),
            Center(
              child: Text('No salary information available for this month.',
                style: AppStyle.text(size: 14, color: AppStyle.hintColor)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      );
    }

    final double baseSalary = double.tryParse(payslip!.baseSalary) ?? 0;
    final double otherAllowance = double.tryParse(payslip!.otherAllowance) ?? 0;
    final double travelAllowance = double.tryParse(payslip!.travelAllowance) ?? 0;
    final double medicalAllowance = double.tryParse(payslip!.medicalAllowance) ?? 0;
    final double otAmount = double.tryParse(payslip!.otAmount) ?? 0;
    final double grossSalary = double.tryParse(payslip!.grossSalary) ?? 0;
    final double pfAmount = double.tryParse(payslip!.pfAmount) ?? 0;
    final double insuranceAmount = double.tryParse(payslip!.insuranceAmount) ?? 0;
    final double lopDeduction = double.tryParse(payslip!.lopDeduction) ?? 0;
    final double otherDeduction = double.tryParse(payslip!.otherDeduction) ?? 0;
    final double netSalary = double.tryParse(payslip!.netSalary) ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerWidget,
          const SizedBox(height: 16),

          Row(children: [
            Expanded(
              child: SalaryMetricCard(
                icon: Icons.work_outline_rounded,
                iconColor: const Color(0xFF00ACC1),
                label: 'LOP Days',
                value: '${payslip!.lopDays} Days',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SalaryMetricCard(
                icon: Icons.watch_later_outlined,
                iconColor: const Color(0xFFFF9800),
                label: 'Overtime Hrs',
                value: payslip!.actualWorkedHours ?? '0 hrs',
              ),
            ),
          ]),

          const SizedBox(height: 16),
          Text('Earnings', style: AppStyle.text(size: 14, weight: FontWeight.w600, color: Colors.grey.shade700)),
          const Divider(),
          SalaryRow(label: 'Base Salary', value: '₹ ${_fmt(baseSalary)}'),
          if (otherAllowance > 0) SalaryRow(label: 'Other Allowance', value: '₹ ${_fmt(otherAllowance)}'),
          if (travelAllowance > 0) SalaryRow(label: 'Travel Allowance', value: '₹ ${_fmt(travelAllowance)}'),
          if (medicalAllowance > 0) SalaryRow(label: 'Medical Allowance', value: '₹ ${_fmt(medicalAllowance)}'),
          if (otAmount > 0) SalaryRow(label: 'Overtime Amount', value: '₹ ${_fmt(otAmount)}'),
          SalaryRow(label: 'Gross Salary', value: '₹ ${_fmt(grossSalary)}', isBold: true),

          const SizedBox(height: 16),
          Text('Deductions', style: AppStyle.text(size: 14, weight: FontWeight.w600, color: Colors.grey.shade700)),
          const Divider(),
          SalaryRow(label: 'PF Amount', value: '₹ ${_fmt(pfAmount)}'),
          SalaryRow(label: 'Insurance', value: '₹ ${_fmt(insuranceAmount)}'),
          SalaryRow(label: 'LOP Deduction', value: '₹ ${_fmt(lopDeduction)}'),
          if (otherDeduction > 0) SalaryRow(label: 'Other Deductions', value: '₹ ${_fmt(otherDeduction)}'),

          const SizedBox(height: 16),
          const Divider(),
          SalaryRow(label: 'Net Salary', value: '₹${_fmt(netSalary)}', isBold: true),

          const SizedBox(height: 16),

          Row(children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Generating Payslip PDF...')),
                  );
                  final path = await PdfService.generateAndSavePayslipPdf(
                    payslip!,
                    staffName: staffName,
                    empNo: empNo,
                    department: department,
                    designation: designation,
                  );
                  if (context.mounted) {
                    if (path != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Payslip saved to $path', style: const TextStyle(fontSize: 12))),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to download Payslip.')),
                      );
                    }
                  }
                },
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: AppStyle.primaryGradient,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Download Pay slip',
                        style: AppStyle.text(
                            size: 13,
                            color: Colors.white,
                            weight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.download_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}