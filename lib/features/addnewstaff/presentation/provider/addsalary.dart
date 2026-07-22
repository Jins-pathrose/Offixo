import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';

class AddSalaryProvider extends ChangeNotifier {
  static String get _baseUrl =>
      '${dotenv.env['BASE_URL']}/api/salary/employee-salaries/';

  final StorageService _storageService = StorageService();

  bool isLoading = false;
  Map<String, String?> errors = {};

  Future<bool> submit({
    required int memberId,
    required String salaryType,
    required String totalSalary,
    required String pfAmount,
    required String insuranceAmount,
    required String otherDeduction,
    required String hourlyRate, // Not used for MONTHLY
    required String workingHours, // Not used for MONTHLY
    bool isEditMode = false,
    required BuildContext context,
  }) async {
    errors = {};

    // Validate salary type (should always be MONTHLY)
    if (salaryType.trim().isEmpty) {
      errors['salaryType'] = 'Required';
    } else if (salaryType.trim() != 'MONTHLY') {
      errors['salaryType'] = 'Only MONTHLY salary type is supported';
    }

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

      final url =
          isEditMode
              ? '${dotenv.env['BASE_URL']}/api/salary/employee-salaries/$memberId/update/'
              : _baseUrl;

      final request =
          isEditMode
              ? http.patch(
                Uri.parse(url),
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
              )
              : http.post(
                Uri.parse(url),
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

      final res = await request;
      debugPrint('Member ID: ${memberId}');
      debugPrint('Salary Status: ${res.statusCode}');
      debugPrint('Salary Body: ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        success = true;
        _showSnack(
          context,
          isEditMode
              ? 'Salary updated successfully'
              : 'Salary added successfully',
          isError: false,
        );
      } else {
        final fieldErrors = _parseFieldErrors(res.body);
        if (fieldErrors.isNotEmpty) {
          errors.addAll(fieldErrors);
          _showSnack(
            context,
            fieldErrors.values.first ?? 'Please try again later',
            isError: true,
          );
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
        'hourly_rate': 'hourlyRate',
        'working_hours': 'workingHours',
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

  void _showSnack(
    BuildContext context,
    String message, {
    required bool isError,
  }) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? const Color(0xFFE53935) : const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
