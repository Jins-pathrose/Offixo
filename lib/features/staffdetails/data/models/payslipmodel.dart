class PayslipResponse {
  final bool success;
  final int count;
  final List<Payslip> payslips;

  PayslipResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'] ?? false,
        count = json['count'] ?? 0,
        payslips = (json['payslips'] as List?)
            ?.map((e) => Payslip.fromJson(e))
            .toList() ?? [];
}

class Payslip {
  final int id;
  final int member;
  final String memberName;
  final String empNo;
  final int month;
  final int year;
  final String startDate;
  final String endDate;
  final String paymentCycle;
  final String baseSalary;
  final String travelAllowance;
  final String medicalAllowance;
  final String otherAllowance;
  final String otAmount;
  final String grossSalary;
  final String? actualWorkedHours;
  final String lopDays;
  final String lopDeduction;
  final String pfAmount;
  final String insuranceAmount;
  final String otherDeduction;
  final String netSalary;
  final String status;
  final DateTime createdAt;

  Payslip.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        member = json['member'] ?? 0,
        memberName = json['member_name'] ?? '',
        empNo = json['emp_no'] ?? '',
        month = json['month'] ?? 0,
        year = json['year'] ?? 0,
        startDate = json['start_date'] ?? '',
        endDate = json['end_date'] ?? '',
        paymentCycle = json['payment_cycle'] ?? '',
        baseSalary = json['base_salary']?.toString() ?? '0',
        travelAllowance = json['travel_allowance']?.toString() ?? '0',
        medicalAllowance = json['medical_allowance']?.toString() ?? '0',
        otherAllowance = json['other_allowance']?.toString() ?? '0',
        otAmount = json['ot_amount']?.toString() ?? '0',
        grossSalary = json['gross_salary']?.toString() ?? '0',
        actualWorkedHours = json['actual_worked_hours']?.toString(),
        lopDays = json['lop_days']?.toString() ?? '0',
        lopDeduction = json['lop_deduction']?.toString() ?? '0',
        pfAmount = json['pf_amount']?.toString() ?? '0',
        insuranceAmount = json['insurance_amount']?.toString() ?? '0',
        otherDeduction = json['other_deduction']?.toString() ?? '0',
        netSalary = json['net_salary']?.toString() ?? '0',
        status = json['status'] ?? 'PENDING',
        createdAt = DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String());

  String get monthLabel => _getMonthLabel(month);
  String _getMonthLabel(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }
}