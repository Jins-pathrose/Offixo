class ProfileInfo {
  final String? phoneNumber;
  final String? email;
  final String? bloodGroup;
  final String? gender;
  final String? dateOfBirth;
  final String? presentAddress;
  final String? permanentAddress;

  ProfileInfo({
    this.phoneNumber,
    this.email,
    this.bloodGroup,
    this.gender,
    this.dateOfBirth,
    this.presentAddress,
    this.permanentAddress,
  });
}

class WorkDetails {
  final String? dateOfJoining;
  final String? department;
  final String? designation;
  final String? salaryType;
  final double? salaryAmount;
  final String? workingShift;

  WorkDetails({
    this.dateOfJoining,
    this.department,
    this.designation,
    this.salaryType,
    this.salaryAmount,
    this.workingShift,
  });
}