import 'package:flutter/material.dart';
import 'package:offixoadmin/features/staffdetails/data/models/leavedetailsmodel.dart';
import 'package:offixoadmin/features/staffdetails/data/models/monthlyattendance.dart';
import 'package:offixoadmin/features/staffdetails/data/models/profileinfomodel.dart';
import 'package:offixoadmin/features/staffdetails/data/models/salarydetailsmodel.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/provider/staffdetailsprovider.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/attendancetabcontent.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/contacttab.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/edittab.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/profileinfotab.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/leavetab.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/salarytab.dart';
import 'package:offixoadmin/features/staffdetails/domain/enum.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/settingstab.dart';

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
            salaryAmount: provider.salaryAmount,
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
      StaffDetailsTab.edit => EditTab(provider: provider),
      StaffDetailsTab.settings => SettingsTab(provider: provider),
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
          selectedMonth: provider.selectedAttendanceMonth ?? DateTime.now().month,
          selectedYear: provider.selectedAttendanceYear ?? DateTime.now().year,
          onMonthChanged: (month, year) {
            provider.changeAttendanceMonth(month, year);
          },
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
          payslip: provider.displayPayslip,
          selectedMonth: provider.selectedPayslipMonth ?? DateTime.now().month,
          selectedYear: provider.selectedPayslipYear ?? DateTime.now().year,
          staffName: provider.memberName,
          empNo: provider.empNo,
          department: provider.department,
          designation: provider.designation,
          onMonthChanged: (month, year) {
            provider.changePayslipMonth(month, year);
          },
        ),
    };
  }
}