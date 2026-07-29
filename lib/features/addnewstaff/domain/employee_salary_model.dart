class EmployeeSalaryModel {
  final int id;
  final String salaryType;
  final String totalSalary;
  final String pfAmount;
  final String insuranceAmount;
  final String otherDeduction;
  final String? hourlyRate;
  final String? workingHoursPerMonth;
  final String handSalary;
  final bool isActive;
  final int memberId;

  EmployeeSalaryModel({
    required this.id,
    required this.salaryType,
    required this.totalSalary,
    required this.pfAmount,
    required this.insuranceAmount,
    required this.otherDeduction,
    this.hourlyRate,
    this.workingHoursPerMonth,
    required this.handSalary,
    required this.isActive,
    required this.memberId,
  });

  factory EmployeeSalaryModel.fromJson(Map<String, dynamic> json) {
    return EmployeeSalaryModel(
      id: json['id'] as int? ?? 0,
      salaryType: json['salary_type'] as String? ?? '',
      totalSalary: json['total_salary']?.toString() ?? '',
      pfAmount: json['pf_amount']?.toString() ?? '',
      insuranceAmount: json['insurance_amount']?.toString() ?? '',
      otherDeduction: json['other_deduction']?.toString() ?? '',
      hourlyRate: json['hourly_rate']?.toString(),
      workingHoursPerMonth: json['working_hours_per_month']?.toString(),
      handSalary: json['hand_salary']?.toString() ?? '',
      isActive: json['is_active'] as bool? ?? true,
      memberId: json['member'] as int? ?? 0,
    );
  }
}
