import 'package:flutter/material.dart';
import 'package:offixoadmin/features/staffdetails/data/models/leavedetailsmodel.dart';
import 'package:offixoadmin/features/staffdetails/data/models/monthlyattendance.dart';
import 'package:offixoadmin/features/staffdetails/data/models/profileinfomodel.dart';
import 'package:offixoadmin/features/staffdetails/data/models/salarydetailsmodel.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/provider/staffdetailsprovider.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/attendancetabcontent.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/contacttab.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/profileinfotab.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/leavetab.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/salarytab.dart';
import 'package:offixoadmin/features/staffdetails/domain/enum.dart';

class TabContent extends StatelessWidget {
  final StaffDetailsProvider provider;

  const TabContent({required this.provider});

  @override
  Widget build(BuildContext context) {
    return switch (provider.activeTab) {
      StaffDetailsTab.main => _buildMainTabContent(),
      StaffDetailsTab.profileInfo => ProfileInfoTab(
          info: ProfileInfo(
            phoneNumber: provider.phoneNumber,
            email: provider.email,
            bloodGroup: provider.bloodGroup,
            gender: provider.gender,
            dateOfBirth: provider.dateOfBirth,
            presentAddress: provider.presentAddress,
          ),
          work: WorkDetails(
            dateOfJoining: provider.startDate,
            department: provider.department,
            designation: provider.designation,
            salaryType: provider.memberType,
            salaryAmount: double.tryParse(provider.currentPayroll?.baseSalary ?? '0'),
            workingShift: provider.shift,
          ),
        ),
      StaffDetailsTab.contact => ContactTab(
          info: ProfileInfo(
            phoneNumber: provider.phoneNumber,
            email: provider.email,
            bloodGroup: provider.bloodGroup,
            gender: provider.gender,
            dateOfBirth: provider.dateOfBirth,
            presentAddress: provider.presentAddress,
            permanentAddress: provider.permanentAddress,
          ),
        ),
      StaffDetailsTab.edit => const SizedBox.shrink(), // Add edit view
      StaffDetailsTab.settings => const SizedBox.shrink(), // Add settings view
    };
  }

  Widget _buildMainTabContent() {
    return switch (provider.activeMainTab) {
      StaffMainTab.attendance => AttendanceTabContent(
          summary: provider.todayAttendance,
          monthly: MonthlyAttendance(
            monthLabel: provider.monthLabel,
            dayStatus: provider.monthlyDayStatus,
          ),
        ),
      StaffMainTab.leave => LeaveTab(
          leave: LeaveDetails(
            pending: provider.pendingLeaves,
            approved: provider.approvedLeaves,
            rejected: provider.rejectedLeaves,
            casualLeaveBalance: provider.casualLeaveBalance,
            sickLeaveBalance: provider.sickLeaveBalance,
            records: provider.leaveRecords,
          ),
        ),
      StaffMainTab.salary => SalaryTab(
          salary: SalaryDetails(
            monthLabel: provider.currentPayroll?.monthLabel ?? '--',
            payableDays: 30, // You can calculate this
            overtimeWork: '0 hrs', // You can calculate this
            monthlySalary: double.tryParse(provider.currentPayroll?.baseSalary ?? '0') ?? 0,
            earnedSalary: double.tryParse(provider.currentPayroll?.netSalary ?? '0') ?? 0,
          ),
          payslipId: provider.currentPayslip?.id,
          onDownload: () {
            if (provider.currentPayslip != null) {
              provider.downloadPayslip(provider.currentPayslip!.id);
            }
          },
          onGenerate: () {
            final now = DateTime.now();
            provider.generatePayslip(
              provider.staffDetails?.id ?? 0,
              now.month,
              now.year,
            );
          },
        ),
    };
  }
}