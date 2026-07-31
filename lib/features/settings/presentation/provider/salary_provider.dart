import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:offixoadmin/core/network/global_http_client.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/settings/domain/staff_list_model.dart';
import 'package:offixoadmin/features/addnewstaff/domain/employee_salary_model.dart';

class SalaryProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  bool isLoading = false;
  bool isLoadingMore = false;
  String? errorMessage;
  
  List<StaffListItemModel> staffList = [];
  String? _nextUrl;
  
  String searchQuery = '';

  SalaryProvider() {
    fetchStaffList();
  }

  Future<void> fetchStaffList({bool refresh = false}) async {
    if (refresh) {
      staffList.clear();
      _nextUrl = null;
      errorMessage = null;
      isLoading = true;
      notifyListeners();
    } else if (_nextUrl != null) {
      isLoadingMore = true;
      notifyListeners();
    } else if (staffList.isEmpty) {
      isLoading = true;
      notifyListeners();
    } else {
      return; // Nothing to do
    }

    try {
      final token = await _storageService.getAccessToken();
      if (token == null || token.isEmpty) {
        errorMessage = 'Authentication token missing';
        isLoading = false;
        isLoadingMore = false;
        notifyListeners();
        return;
      }

      String url = _nextUrl ?? '${dotenv.env['BASE_URL']}/api/member/create/';
      if (searchQuery.isNotEmpty && _nextUrl == null) {
        url += '?search=${Uri.encodeComponent(searchQuery)}';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final listResponse = StaffListResponse.fromJson(data);
        
        staffList.addAll(listResponse.results);
        _nextUrl = listResponse.next;
        errorMessage = null;
      } else {
        errorMessage = 'Failed to load staff list. Server responded with ${response.statusCode}';
        if (isLoadingMore) throw Exception(errorMessage);
      }
    } catch (e) {
      errorMessage = 'Network error: $e';
      if (isLoadingMore) throw Exception(errorMessage);
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  void search(String query) {
    searchQuery = query;
    fetchStaffList(refresh: true);
  }

  Future<EmployeeSalaryModel?> checkStaffSalary(int memberId) async {
    try {
      final token = await _storageService.getAccessToken();
      if (token == null || token.isEmpty) return null;

      String? url = '${dotenv.env['BASE_URL']}/api/salary/employee-salaries/';
      
      while (url != null) {
        debugPrint('GET Salary URL: $url');
        
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        debugPrint('GET Salary Status: ${response.statusCode}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data != null) {
            try {
              if (data is Map<String, dynamic> && data.containsKey('results')) {
                final results = data['results'] as List;
                
                // Manually search for the salary record matching the memberId
                final match = results.firstWhere(
                  (r) => r['member'] == memberId,
                  orElse: () => null,
                );

                if (match != null) {
                  final model = EmployeeSalaryModel.fromJson(match as Map<String, dynamic>);
                  debugPrint('isEditMode should be true. Model parsed successfully. Salary ID: ${model.id}');
                  return model;
                }
                
                // If not found on this page, go to the next page
                url = data['next'] as String?;
              } else if (data is List && data.isNotEmpty) {
                // If it's a flat list for some reason
                final match = data.firstWhere(
                  (r) => r['member'] == memberId,
                  orElse: () => null,
                );
                if (match != null) {
                  final model = EmployeeSalaryModel.fromJson(match as Map<String, dynamic>);
                  debugPrint('isEditMode should be true. Model parsed successfully. Salary ID: ${model.id}');
                  return model;
                }
                url = null; // No next page
              } else {
                debugPrint('Unexpected JSON format: $data');
                url = null;
              }
            } catch (e) {
              debugPrint('Error parsing EmployeeSalaryModel: $e');
              url = null;
            }
          } else {
            url = null;
          }
        } else {
          debugPrint('Non-200 status. Stopping search.');
          url = null;
        }
      }
      
      debugPrint('isEditMode should be false. No salary found for member $memberId.');
      return null;
    } catch (e) {
      debugPrint('Error checking staff salary: $e');
      return null;
    }
  }
}
