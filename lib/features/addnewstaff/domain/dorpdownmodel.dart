class DropdownItem {
  final String id;
  final String name;

  const DropdownItem({required this.id, required this.name});

  factory DropdownItem.fromJson(Map<String, dynamic> json) => DropdownItem(
        id: json['id'].toString(),
        name: json['name'] ?? '',
      );
}

// Shift item has a different structure — shift_name instead of name
class ShiftDropdownItem {
  final String id;
  final String name; // shift_name

  const ShiftDropdownItem({required this.id, required this.name});

  factory ShiftDropdownItem.fromJson(Map<String, dynamic> json) =>
      ShiftDropdownItem(
        id: json['id'].toString(),
        name: json['shift_name'] ?? '',
      );
}

class DropdownChoices {
  final List<DropdownItem> bloodGroups;
  final List<DropdownItem> branches;
  final List<DropdownItem> departments;
  final List<DropdownItem> designations;
  final List<ShiftDropdownItem> shifts;
  final List<DropdownItem> genders;
  final List<DropdownItem> memberTypes;

  const DropdownChoices({
    required this.bloodGroups,
    required this.branches,
    required this.departments,
    required this.designations,
    required this.shifts,
    required this.genders,
    required this.memberTypes,
  });

  factory DropdownChoices.fromJson(Map<String, dynamic> json) =>
      DropdownChoices(
        bloodGroups: (json['blood_groups'] as List? ?? [])
            .map((e) => DropdownItem.fromJson(e))
            .toList(),
        branches: (json['branches'] as List? ?? [])
            .map((e) => DropdownItem.fromJson(e))
            .toList(),
        departments: (json['departments'] as List? ?? [])
            .map((e) => DropdownItem.fromJson(e))
            .toList(),
        designations: (json['designations'] as List? ?? [])
            .map((e) => DropdownItem.fromJson(e))
            .toList(),
        shifts: (json['shifts'] as List? ?? [])
            .map((e) => ShiftDropdownItem.fromJson(e))
            .toList(),
        genders: (json['genders'] as List? ?? [])
            .map((e) => DropdownItem.fromJson(e))
            .toList(),
        memberTypes: (json['member_types'] as List? ?? [])
            .map((e) => DropdownItem.fromJson(e))
            .toList(),
      );

  factory DropdownChoices.empty() => const DropdownChoices(
        bloodGroups: [],
        branches: [],
        departments: [],
        designations: [],
        shifts: [],
        genders: [],
        memberTypes: [],
      );
}