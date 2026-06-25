import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/staffdetails/data/models/salarydetailsmodel.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/salarymeritcard.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/salaryrow.dart';

class SalaryTab extends StatelessWidget {
  final SalaryDetails? salary;
  final int? payslipId;
  final VoidCallback? onDownload;
  final VoidCallback? onGenerate;

  const SalaryTab({
    this.salary,
    this.payslipId,
    this.onDownload,
    this.onGenerate,
  });

  String _fmt(double v) => v
      .toStringAsFixed(2)
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Salary Details',
                  style: AppStyle.text(size: 15, weight: FontWeight.w700)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BCD4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Text(salary?.monthLabel ?? '--',
                        style: AppStyle.text(
                            size: 12, color: Colors.white, weight: FontWeight.w500)),
                    const SizedBox(width: 4),
                    const Icon(Icons.calendar_month_outlined,
                        size: 14, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(children: [
            Expanded(
              child: SalaryMetricCard(
                icon: Icons.work_outline_rounded,
                iconColor: const Color(0xFF00ACC1),
                label: 'Payable Days',
                value: '${salary?.payableDays ?? '--'} Days',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SalaryMetricCard(
                icon: Icons.watch_later_outlined,
                iconColor: const Color(0xFFFF9800),
                label: 'Overtime Work',
                value: salary?.overtimeWork ?? '--',
              ),
            ),
          ]),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),

          SalaryRow(
              label: 'Monthly Salary',
              value: '₹ ${_fmt(salary?.monthlySalary ?? 0)}'),
          const SizedBox(height: 10),
          SalaryRow(
              label: 'Earned Salary',
              value: '₹${_fmt(salary?.earnedSalary ?? 0)}',
              isBold: true),

          const SizedBox(height: 16),

          Row(children: [
            Expanded(
              child: GestureDetector(
                onTap: payslipId != null ? onDownload : onGenerate,
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
                        payslipId != null ? 'Download Pay slip' : 'Generate Pay slip',
                        style: AppStyle.text(
                            size: 13,
                            color: Colors.white,
                            weight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        payslipId != null 
                            ? Icons.download_rounded 
                            : Icons.add_circle_outline,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppStyle.borderColor),
                ),
                child: const Icon(Icons.share_outlined,
                    size: 20, color: AppStyle.accentCyan),
              ),
            ),
          ]),
          
          if (payslipId == null) ...[
            const SizedBox(height: 8),
            Text(
              'No payslip generated for this month. Tap "Generate" to create one.',
              style: AppStyle.text(size: 12, color: AppStyle.hintColor),
            ),
          ],
        ],
      ),
    );
  }
}