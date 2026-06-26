import 'package:flutter/material.dart';
import 'package:offixoadmin/features/staffdetails/data/models/leaveanalyticsresponse.dart';
import 'package:offixoadmin/features/staffdetails/data/models/leavebalanceresponse.dart';
import 'package:offixoadmin/features/staffdetails/data/models/leaverecordmodel.dart';
import 'package:offixoadmin/features/staffdetails/data/models/monthlyattendanceresponse.dart';
import 'package:offixoadmin/features/staffdetails/data/models/payrollresponse.dart';
import 'package:offixoadmin/features/staffdetails/data/models/payslipmodel.dart';
import 'package:offixoadmin/features/staffdetails/data/models/staffdetailsresponse.dart';
import 'package:offixoadmin/features/staffdetails/domain/enum.dart';
import 'package:offixoadmin/features/staffdetails/domain/staff_repository.dart';

class StaffDetailsProvider extends ChangeNotifier {
  final int staffId;
  bool _isDisposed = false;
  bool _isDataLoaded = false;
  bool _isLoadingData = false; // Prevent concurrent loads
  
  StaffDetailsProvider({required this.staffId}) {
    print('🔵 Provider created for staffId: $staffId');
    // Don't load here - let the view trigger it
  }
  
  final Staffrepository _repository = Staffrepository();

  // State
  StaffDetailsResponse? _staffDetails;
  MonthlyAttendanceResponse? _monthlyAttendance;
  LeaveAnalyticsResponse? _leaveAnalytics;
  LeaveBalanceResponse? _leaveBalance;
  Payslip? _payslipPreview;

  bool _isLoading = false;
  String? _error;

  StaffDetailsTab _activeTab = StaffDetailsTab.main;
  StaffMainTab _activeMainTab = StaffMainTab.attendance;

  int? selectedPayslipMonth;
  int? selectedPayslipYear;

  int? selectedAttendanceMonth;
  int? selectedAttendanceYear;

  // Getters
  StaffDetailsResponse? get staffDetails => _staffDetails;
  MonthlyAttendanceResponse? get monthlyAttendance => _monthlyAttendance;
  LeaveAnalyticsResponse? get leaveAnalytics => _leaveAnalytics;
  LeaveBalanceResponse? get leaveBalance => _leaveBalance;
  bool get isLoading => _isLoading;
  String? get error => _error;
  StaffDetailsTab get activeTab => _activeTab;
  StaffMainTab get activeMainTab => _activeMainTab;

  // Helper getters for UI
  String get memberName => _staffDetails?.fullName ?? '--';
  String get memberDesignation => _staffDetails?.designationDept ?? '--';
  String get branch => _staffDetails?.branch ?? '--';
  String get empNo => _staffDetails?.empNo ?? '--';
  String get phoneNumber => _staffDetails?.phoneNumber ?? '--';
  String get email => _staffDetails?.email ?? '--';
  String get bloodGroup => _staffDetails?.bloodGroup ?? '--';
  String get gender => _staffDetails?.gender ?? '--';
  String get dateOfBirth => _staffDetails?.dateOfBirth ?? '--';
  String get presentAddress => _staffDetails?.presentAddress ?? '--';
  String get permanentAddress => _staffDetails?.permanentAddress ?? '--';
  String get emergencyContactName => _staffDetails?.emergencyContactName ?? '--';
  String get emergencyContactPhone => _staffDetails?.emergencyContactPhone ?? '--';
  String get startDate => _staffDetails?.startDate ?? '--';
  String get department => _staffDetails?.departmentName ?? '--';
  String get designation => _staffDetails?.designationName ?? '--';
  String get shift => _staffDetails?.currentShiftName ?? '--';
  String get memberType => _staffDetails?.memberType ?? '--';

  double? get salaryAmount {
    if (_payslipPreview != null) {
      return double.tryParse(_payslipPreview!.baseSalary);
    }
    return null;
  }

  // Today's attendance summary from calendar
  AttendanceSummary? get todayAttendance {
    if (_monthlyAttendance == null) return null;
    
    final today = DateTime.now();
    final todayStr = today.toString().split(' ')[0];
    
    final todayData = _monthlyAttendance!.calendarData.firstWhere(
      (d) => d.date == todayStr,
      orElse: () => CalendarDayData.fromJson({}),
    );
    
    if (todayData.attendanceDetails == null) return null;
    
    final details = todayData.attendanceDetails!;
    return AttendanceSummary(
      checkIn: details.checkinTime,
      checkOut: details.checkoutTime,
      totalWorked: details.workingHours,
      overtime: details.otHours,
      isLateCheckIn: false,
      lateByText: null,
    );
  }

  // Monthly calendar data
  Map<int, String> get monthlyDayStatus {
    if (_monthlyAttendance == null) return {};
    final map = <int, String>{};
    for (final day in _monthlyAttendance!.calendarData) {
      map[day.dayNumber] = day.status;
    }
    return map;
  }

  String get monthLabel {
    if (_monthlyAttendance == null) return '--';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[_monthlyAttendance!.month - 1];
  }

  // Leave summary
  int get pendingLeaves => _leaveAnalytics?.yearlyStatusCounts.pendingCount ?? 0;
  int get approvedLeaves => _leaveAnalytics?.yearlyStatusCounts.approvedCount ?? 0;
  int get rejectedLeaves => _leaveAnalytics?.yearlyStatusCounts.rejectedCount ?? 0;

  List<LeaveRecord> get leaveRecords {
    if (_leaveAnalytics == null) return [];
    return _leaveAnalytics!.monthlyLeaveDetails.map((detail) => LeaveRecord(
      date: detail.fromDate,
      type: detail.leaveTypeName,
      status: detail.status,
    )).toList();
  }

  // Leave balance
  int get casualLeaveBalance {
    final cl = _leaveBalance?.leaveBalanceDetails.firstWhere(
      (d) => d.leaveTypeCode == 'CL',
      orElse: () => LeaveBalanceDetail.fromJson({}),
    );
    return cl?.remainingDays.toInt() ?? 0;
  }

  int get sickLeaveBalance {
    final sl = _leaveBalance?.leaveBalanceDetails.firstWhere(
      (d) => d.leaveTypeCode == 'SL',
      orElse: () => LeaveBalanceDetail.fromJson({}),
    );
    return sl?.remainingDays.toInt() ?? 0;
  }

  Payslip? get displayPayslip => _payslipPreview;

  // Methods
  void setTab(StaffDetailsTab tab) {
    if (_isDisposed) return;
    _activeTab = tab;
    notifyListeners();
  }

  void setMainTab(StaffMainTab tab) {
    if (_isDisposed) return;
    _activeMainTab = tab;
    notifyListeners();
  }

  // FIX: Main load method with proper checks
  // In StaffDetailsProvider - modify loadAllData

Future<void> loadAllData() async {
  if (_isLoadingData) {
    print('⏳ Already loading data, skipping...');
    return;
  }
  
  if (_isDataLoaded && _staffDetails != null) {
    print('📊 Data already loaded, skipping...');
    return;
  }
  
  print('🔄 Starting data load...');
  _isLoadingData = true;
  _isLoading = true;
  _error = null;
  notifyListeners();
  
  final now = DateTime.now();
  final month = selectedPayslipMonth ?? now.month;
  final year = selectedPayslipYear ?? now.year;

  // For attendance, leave analytics we might still want to use current year/month
  // but let's keep them using the payslip month so everything is synced, 
  // or use `now` for others. Let's use `now` for others and `month/year` for payslip.
  final currentMonth = now.month;
  final currentYear = now.year;

  final attendanceMonth = selectedAttendanceMonth ?? currentMonth;
  final attendanceYear = selectedAttendanceYear ?? currentYear;

  try {
    // Load each API separately to handle failures gracefully
    await _loadStaffDetails();
    await _loadLeaveAnalytics(currentYear, currentMonth);
    await _loadLeaveBalance(currentYear);
    
    await _loadPayslipPreview(month, year);
    
    // Load monthly attendance separately with special handling
    await _loadMonthlyAttendanceWithFallback(attendanceMonth, attendanceYear);
    
    if (!_isDisposed) {
      _isDataLoaded = true;
      _isLoading = false;
      _isLoadingData = false;
      notifyListeners();
      print('✅ All data loaded successfully for staffId: $staffId');
    }
  } catch (e) {
    if (!_isDisposed) {
      _isLoading = false;
      _isLoadingData = false;
      _error = 'Failed to load data: ${e.toString()}';
      notifyListeners();
      print('❌ Error: $e');
    }
  }
}

// New method with fallback for monthly attendance
Future<void> _loadMonthlyAttendanceWithFallback(int month, int year) async {
  try {
    final data = await _repository.getMonthlyAttendance(staffId, month, year);
    if (!_isDisposed) {
      _monthlyAttendance = data;
      _error = null;
    }
  } catch (e) {
    print('⚠️ Monthly attendance failed (server issue), using empty data');
    if (!_isDisposed) {
      // Use empty data instead of failing
      _monthlyAttendance = MonthlyAttendanceResponse.fromJson({
        'success': false,
        'member_info': {
          'member_id': staffId,
          'emp_no': '',
          'name': '',
          'designation': '',
          'department': ''
        },
        'month': month,
        'year': year,
        'saturday_rule_applied': '',
        'calendar_data': []
      });
      // Don't set error for this - it's a known server issue
    }
  }
}

  // Individual load methods
  Future<void> _loadStaffDetails() async {
    try {
      final data = await _repository.getStaffDetails(staffId);
      if (!_isDisposed) {
        _staffDetails = data;
        _error = null;
      }
    } catch (e) {
      if (!_isDisposed) {
        _error = e.toString();
      }
      rethrow;
    }
  }

  Future<void> _loadMonthlyAttendance(int month, int year) async {
    try {
      final data = await _repository.getMonthlyAttendance(staffId, month, year);
      if (!_isDisposed) {
        _monthlyAttendance = data;
        _error = null;
      }
    } catch (e) {
      if (!_isDisposed) {
        _error = e.toString();
      }
      rethrow;
    }
  }

  Future<void> _loadLeaveAnalytics(int year, int month) async {
    try {
      final data = await _repository.getLeaveAnalytics(staffId, year, month);
      if (!_isDisposed) {
        _leaveAnalytics = data;
        _error = null;
      }
    } catch (e) {
      if (!_isDisposed) {
        _error = e.toString();
      }
      rethrow;
    }
  }

  Future<void> _loadLeaveBalance(int year) async {
    try {
      final data = await _repository.getLeaveBalance(staffId, year);
      if (!_isDisposed) {
        _leaveBalance = data;
        _error = null;
      }
    } catch (e) {
      if (!_isDisposed) {
        _error = e.toString();
      }
      rethrow;
    }
  }



Future<void> _loadPayslipPreview(int month, int year) async {
  try {
    final data = await _repository.getPayslipPreview(staffId, month, year);
    if (!_isDisposed) {
      _payslipPreview = data;
    }
  } catch (e) {
    print('⚠️ Payslip preview error: $e');
    if (!_isDisposed) {
      _payslipPreview = null;
    }
  }
}

  Future<void> changeAttendanceMonth(int month, int year) async {
    if (_isDisposed) return;
    selectedAttendanceMonth = month;
    selectedAttendanceYear = year;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      await _loadMonthlyAttendanceWithFallback(month, year);
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> changePayslipMonth(int month, int year) async {
    if (_isDisposed) return;
    selectedPayslipMonth = month;
    selectedPayslipYear = year;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      await _loadPayslipPreview(month, year);
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  // Public method to force refresh
  Future<void> refreshData() async {
    _isDataLoaded = false;
    await loadAllData();
  }

  Future<void> generatePayslip(int memberId, int month, int year) async {
    if (_isDisposed) return;
    _isLoading = true;
    notifyListeners();
    
    try {
      await _repository.generatePayslip(memberId, month, year);
      if (!_isDisposed) {
        _isDataLoaded = false; // Reset to reload
        await loadAllData();
      }
    } catch (e) {
      if (!_isDisposed) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> downloadPayslip(int payslipId) async {
    if (_isDisposed) return;
    _isLoading = true;
    notifyListeners();
    
    try {
      await _repository.downloadPayslip(payslipId);
      if (!_isDisposed) {
        _error = null;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      if (!_isDisposed) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

// Helper classes
class AttendanceSummary {
  final String checkIn;
  final String checkOut;
  final String totalWorked;
  final String overtime;
  final bool isLateCheckIn;
  final String? lateByText;

  AttendanceSummary({
    required this.checkIn,
    required this.checkOut,
    required this.totalWorked,
    required this.overtime,
    required this.isLateCheckIn,
    this.lateByText,
  });
}