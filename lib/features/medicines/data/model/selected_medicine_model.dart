class SelectedMedicineSample {
  final int id;
  final int medicine;
  final String medicineName;
  final String medicineCode;
  final int count;
  final String notes;
  final String createdAt;

  const SelectedMedicineSample({
    required this.id,
    required this.medicine,
    required this.medicineName,
    required this.medicineCode,
    required this.count,
    required this.notes,
    required this.createdAt,
  });

  factory SelectedMedicineSample.fromJson(Map<String, dynamic> json) =>
      SelectedMedicineSample(
        id: json['id'] ?? 0,
        medicine: json['medicine'] ?? 0,
        medicineName: json['medicine_name'] ?? '',
        medicineCode: json['medicine_code'] ?? '',
        count: json['count'] ?? 0,
        notes: json['notes'] ?? '',
        createdAt: json['created_at'] ?? '',
      );
}

class SelectedMedicineData {
  final int id;
  final int memberId;
  final String memberName;
  final String memberEmail;
  final String? checkinTime;
  final String? checkoutTime;
  final List<SelectedMedicineSample> medicineSamples;

  const SelectedMedicineData({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.memberEmail,
    this.checkinTime,
    this.checkoutTime,
    required this.medicineSamples,
  });

  factory SelectedMedicineData.fromJson(Map<String, dynamic> json) {
    var list = json['medicine_samples'] as List? ?? [];
    List<SelectedMedicineSample> samplesList =
        list.map((i) => SelectedMedicineSample.fromJson(i)).toList();

    return SelectedMedicineData(
      id: json['id'] ?? 0,
      memberId: json['member_id'] ?? 0,
      memberName: json['member_name'] ?? '',
      memberEmail: json['member_email'] ?? '',
      checkinTime: json['checkin_time'],
      checkoutTime: json['checkout_time'],
      medicineSamples: samplesList,
    );
  }
}
