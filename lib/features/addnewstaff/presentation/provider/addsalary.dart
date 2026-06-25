import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';

class AddSalaryProvider extends ChangeNotifier {
  static const String _baseUrl =
      'https://offixo.archanastones.in/api/salary/employee-salaries/';

  final StorageService _storageService = StorageService();

  bool isLoading = false;
  Map<String, String?> errors = {};

  /// POST /api/salary/employee-salaries/
  /// { "member": id, "salary_type": "MONTHLY", "total_salary": 50000,
  ///   "pf_amount": 2000, "insurance_amount": 1000, "other_deduction": 500 }
  Future<bool> submit({
    required int memberId,
    required String salaryType,
    required String totalSalary,
    required String pfAmount,
    required String insuranceAmount,
    required String otherDeduction,
    required BuildContext context,
  }) async {
    errors = {};

    if (salaryType.trim().isEmpty) errors['salaryType'] = 'Required';
    if (totalSalary.trim().isEmpty) {
      errors['totalSalary'] = 'Required';
    } else if (num.tryParse(totalSalary.trim()) == null) {
      errors['totalSalary'] = 'Enter a valid amount';
    }
    // pf, insurance, other deduction are optional but must be numeric if filled
    if (pfAmount.trim().isNotEmpty && num.tryParse(pfAmount.trim()) == null) {
      errors['pfAmount'] = 'Enter a valid amount';
    }
    if (insuranceAmount.trim().isNotEmpty &&
        num.tryParse(insuranceAmount.trim()) == null) {
      errors['insuranceAmount'] = 'Enter a valid amount';
    }
    if (otherDeduction.trim().isNotEmpty &&
        num.tryParse(otherDeduction.trim()) == null) {
      errors['otherDeduction'] = 'Enter a valid amount';
    }

    if (errors.isNotEmpty) {
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    bool success = false;
    try {
      final token = await _storageService.getAccessToken();

      final res = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'member': memberId,
          'salary_type': salaryType.trim(),
          'total_salary': num.parse(totalSalary.trim()),
          'pf_amount': num.tryParse(pfAmount.trim()) ?? 0,
          'insurance_amount': num.tryParse(insuranceAmount.trim()) ?? 0,
          'other_deduction': num.tryParse(otherDeduction.trim()) ?? 0,
        }),
      );

      debugPrint('Salary Status: ${res.statusCode}');
      debugPrint('Salary Body: ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        success = true;
        _showSnack(context, 'Salary added successfully', isError: false);
      } else {
        final fieldErrors = _parseFieldErrors(res.body);
        if (fieldErrors.isNotEmpty) {
          errors.addAll(fieldErrors);
          _showSnack(context, fieldErrors.values.first ?? 'Please try again later',
              isError: true);
        } else {
          _showSnack(context, 'Please try again later', isError: true);
        }
      }
    } catch (e) {
      debugPrint('Salary submit error: $e');
      _showSnack(context, 'Please try again later', isError: true);
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return success;
  }

  Map<String, String?> _parseFieldErrors(String body) {
    try {
      final json = jsonDecode(body);
      if (json is! Map<String, dynamic>) return {};

      const fieldKeyMap = {
        'member': 'member',
        'salary_type': 'salaryType',
        'total_salary': 'totalSalary',
        'pf_amount': 'pfAmount',
        'insurance_amount': 'insuranceAmount',
        'other_deduction': 'otherDeduction',
      };

      final result = <String, String?>{};
      json.forEach((apiKey, value) {
        final mappedKey = fieldKeyMap[apiKey];
        if (mappedKey == null) return;
        String? message;
        if (value is List && value.isNotEmpty) {
          message = value.first.toString();
        } else if (value is String) {
          message = value;
        }
        if (message != null) result[mappedKey] = message;
      });
      return result;
    } catch (_) {
      return {};
    }
  }

  void _showSnack(BuildContext context, String message,
      {required bool isError}) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor:
          isError ? const Color(0xFFE53935) : const Color(0xFF22C55E),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    ));
  }
}