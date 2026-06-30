import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/staffdetails/data/models/leaveanalyticsresponse.dart';
import 'package:offixoadmin/features/staffdetails/data/models/leavebalanceresponse.dart';
import 'package:offixoadmin/features/staffdetails/data/models/monthlyattendanceresponse.dart';
import 'package:offixoadmin/features/staffdetails/data/models/payrollresponse.dart';
import 'package:offixoadmin/features/staffdetails/data/models/payslipmodel.dart';
import 'package:offixoadmin/features/staffdetails/data/models/staffdetailsresponse.dart';

class Staffrepository {
  String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  
  // FIX: Make token retrieval async and cache it
  String? _cachedToken;
  DateTime? _tokenExpiry;
  final StorageService _storageService = StorageService();
  
  // FIX: Proper async token getter with caching
  Future<String?> _getToken() async {
    // If token is cached and not expired, return it
    if (_cachedToken != null) {
      // You might want to check expiration here
      return _cachedToken;
    }
    
    try {
      final token = await _storageService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        _cachedToken = token;
        print('🔑 Token retrieved successfully, length: ${token.length}');
        return token;
      } else {
        print('⚠️ Token is null or empty');
        return null;
      }
    } catch (e) {
      print('❌ Error getting token: $e');
      return null;
    }
  }
  
  // FIX: Properly await the token
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    
    if (token == null || token.isEmpty) {
      print('⚠️ No token available!');
      return {
        'Content-Type': 'application/json',
      };
    }
    
    // Clean the token - remove any extra spaces
    final cleanToken = token.trim();
    print('🔑 Using token: ${cleanToken.substring(0, cleanToken.length > 15 ? 15 : cleanToken.length)}...');
    
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $cleanToken',
    };
  }

  // Helper method to handle API responses with detailed logging
  Future<Map<String, dynamic>> _handleResponse(http.Response response, String apiName) async {
    print('📡 [$apiName] Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 500) {
      print('❌ [$apiName] INTERNAL SERVER ERROR (500)');
      print('❌ [$apiName] Response body: ${response.body}');
      throw Exception('[$apiName] Internal Server Error: ${response.statusCode}\n${response.body}');
    } else if (response.statusCode == 429) {
      print('⏳ [$apiName] RATE LIMITED (429) - Too many requests');
      print('⏳ [$apiName] Response: ${response.body}');
      throw Exception('[$apiName] Rate limited: ${response.statusCode}\n${response.body}');
    } else if (response.statusCode == 401) {
      print('🔒 [$apiName] UNAUTHORIZED (401) - Token expired or invalid');
      print('🔒 [$apiName] Response: ${response.body}');
      throw Exception('[$apiName] Unauthorized: ${response.statusCode}\n${response.body}');
    } else if (response.statusCode == 404) {
      print('❓ [$apiName] NOT FOUND (404) - Endpoint doesn\'t exist');
      print('❓ [$apiName] Response: ${response.body}');
      throw Exception('[$apiName] Not Found: ${response.statusCode}\n${response.body}');
    } else {
      print('⚠️ [$apiName] Unexpected status: ${response.statusCode}');
      print('⚠️ [$apiName] Response: ${response.body}');
      throw Exception('[$apiName] Unexpected error: ${response.statusCode}\n${response.body}');
    }
  }

  Future<StaffDetailsResponse> getStaffDetails(int memberId) async {
    final apiName = 'getStaffDetails';
    final url = '$baseUrl/api/member/update/$memberId/';
    print('🌐 [$apiName] GET: $url');
    
    final headers = await _getHeaders();
    print('📋 [$apiName] Headers: ${headers.keys.join(", ")}');
    
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    
    final data = await _handleResponse(response, apiName);
    return StaffDetailsResponse.fromJson(data);
  }

  Future<MonthlyAttendanceResponse> getMonthlyAttendance(
    int memberId,
    int month,
    int year,
  ) async {
    final apiName = 'getMonthlyAttendance';
    final url = '$baseUrl/api/member/monthly-calendar/?member_id=$memberId&month=$month&year=$year';
    print('🌐 [$apiName] GET: $url');
    
    final headers = await _getHeaders();
    
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    
    final data = await _handleResponse(response, apiName);
    return MonthlyAttendanceResponse.fromJson(data);
  }

  Future<LeaveAnalyticsResponse> getLeaveAnalytics(
    int memberId,
    int year,
    int month,
  ) async {
    final apiName = 'getLeaveAnalytics';
    final url = '$baseUrl/api/member/leave-analytics/?member_id=$memberId&year=$year&month=$month';
    print('🌐 [$apiName] GET: $url');
    
    final headers = await _getHeaders();
    
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    
    final data = await _handleResponse(response, apiName);
    return LeaveAnalyticsResponse.fromJson(data);
  }

  Future<LeaveBalanceResponse> getLeaveBalance(
    int memberId,
    int year,
  ) async {
    final apiName = 'getLeaveBalance';
    final url = '$baseUrl/api/member/leave-balance-per-person/?member_id=$memberId&year=$year';
    print('🌐 [$apiName] GET: $url');
    
    final headers = await _getHeaders();
    
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    
    final data = await _handleResponse(response, apiName);
    return LeaveBalanceResponse.fromJson(data);
  }

  Future<PayrollListResponse> getPayrollList(int memberId) async {
    final apiName = 'getPayrollList';
    final url = '$baseUrl/api/salary/payroll/list/$memberId/';
    print('🌐 [$apiName] GET: $url');
    
    final headers = await _getHeaders();
    
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    
    print('📡 [$apiName] Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return PayrollListResponse.fromJson(data);
    } else if (response.statusCode == 500) {
      print('❌ [$apiName] INTERNAL SERVER ERROR (500)');
      print('❌ [$apiName] Response body: ${response.body}');
      print('❌ [$apiName] This endpoint may not be implemented or has a bug on the server.');
      // Return empty list instead of throwing to prevent app crash
      return PayrollListResponse.fromJson([]);
    } else if (response.statusCode == 429) {
      print('⏳ [$apiName] RATE LIMITED (429) - Too many requests');
      print('⏳ [$apiName] Response: ${response.body}');
      // Return empty list instead of throwing
      return PayrollListResponse.fromJson([]);
    } else {
      print('⚠️ [$apiName] Unexpected status: ${response.statusCode}');
      print('⚠️ [$apiName] Response: ${response.body}');
      throw Exception('Failed to load payroll list: ${response.statusCode}\n${response.body}');
    }
  }

  Future<PayslipResponse> getPayslip(
    int memberId,
    int month,
    int year,
  ) async {
    final apiName = 'getPayslip';
    final url = '$baseUrl/api/salary/payroll/payslips/member/$memberId/';
    print('🌐 [$apiName] GET: $url');
    
    final headers = await _getHeaders();
    
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    
    print('📡 [$apiName] Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      return PayslipResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 500) {
      print('❌ [$apiName] INTERNAL SERVER ERROR (500)');
      print('❌ [$apiName] Response body: ${response.body}');
      print('❌ [$apiName] This endpoint may not be implemented or has a bug on the server.');
      // Return empty response instead of throwing
      return PayslipResponse.fromJson({'success': false, 'count': 0, 'payslips': []});
    } else if (response.statusCode == 429) {
      print('⏳ [$apiName] RATE LIMITED (429) - Too many requests');
      print('⏳ [$apiName] Response: ${response.body}');
      return PayslipResponse.fromJson({'success': false, 'count': 0, 'payslips': []});
    } else {
      print('⚠️ [$apiName] Unexpected status: ${response.statusCode}');
      print('⚠️ [$apiName] Response: ${response.body}');
      throw Exception('Failed to get payslip: ${response.statusCode}\n${response.body}');
    }
  }

  Future<Payslip?> getPayslipPreview(
    int memberId,
    int month,
    int year,
  ) async {
    final apiName = 'getPayslipPreview';
    final url = '$baseUrl/api/salary/payslips/preview/?month=$month&year=$year&member_id=$memberId';
    print('🌐 [$apiName] GET: $url');
    
    final headers = await _getHeaders();
    
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    
    print('📡 [$apiName] Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final jsonResp = json.decode(response.body);
      if (jsonResp['success'] == true && jsonResp['data'] != null) {
        return Payslip.fromJson(jsonResp['data']);
      }
      return null;
    } else {
      print('⚠️ [$apiName] Unexpected status: ${response.statusCode}');
      print('⚠️ [$apiName] Response: ${response.body}');
      return null; // Don't throw to avoid breaking the UI flow
    }
  }

  Future<void> generatePayslip(
    int memberId,
    int month,
    int year,
  ) async {
    final apiName = 'generatePayslip';
    final url = '$baseUrl/api/salary/payslips/generate/';
    print('🌐 [$apiName] POST: $url');
    
    final headers = await _getHeaders();
    
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode({
        'month': month,
        'year': year,
        'member_id': memberId,
      }),
    );
    
    print('📡 [$apiName] Status: ${response.statusCode}');
    
    if (response.statusCode == 500) {
      print('❌ [$apiName] INTERNAL SERVER ERROR (500)');
      print('❌ [$apiName] Response body: ${response.body}');
      print('❌ [$apiName] This endpoint may not be implemented or has a bug on the server.');
      throw Exception('Failed to generate payslip (500): ${response.body}');
    } else if (response.statusCode == 429) {
      print('⏳ [$apiName] RATE LIMITED (429) - Too many requests');
      print('⏳ [$apiName] Response: ${response.body}');
      throw Exception('Rate limited: ${response.body}');
    } else if (response.statusCode != 200 && response.statusCode != 201) {
      print('⚠️ [$apiName] Unexpected status: ${response.statusCode}');
      print('⚠️ [$apiName] Response: ${response.body}');
      throw Exception('Failed to generate payslip: ${response.statusCode}\n${response.body}');
    }
    
    print('✅ [$apiName] Payslip generated successfully');
  }

  Future<void> downloadPayslip(int payslipId) async {
    final apiName = 'downloadPayslip';
    final url = '$baseUrl/api/salary/payroll/download/$payslipId/';
    print('🌐 [$apiName] GET: $url');
    
    final headers = await _getHeaders();
    headers['Accept'] = 'application/pdf';
    
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    
    print('📡 [$apiName] Status: ${response.statusCode}');
    
    if (response.statusCode == 500) {
      print('❌ [$apiName] INTERNAL SERVER ERROR (500)');
      print('❌ [$apiName] Response body: ${response.body}');
      print('❌ [$apiName] This endpoint may not be implemented or has a bug on the server.');
      throw Exception('Failed to download payslip (500): ${response.body}');
    } else if (response.statusCode == 429) {
      print('⏳ [$apiName] RATE LIMITED (429) - Too many requests');
      print('⏳ [$apiName] Response: ${response.body}');
      throw Exception('Rate limited: ${response.body}');
    } else if (response.statusCode == 200) {
      print('✅ [$apiName] Payslip downloaded successfully');
    } else {
      print('⚠️ [$apiName] Unexpected status: ${response.statusCode}');
      print('⚠️ [$apiName] Response: ${response.body}');
      throw Exception('Failed to download payslip: ${response.statusCode}\n${response.body}');
    }
  }

  Future<void> updateStaffDetails(int memberId, Map<String, dynamic> data) async {
    final apiName = 'updateStaffDetails';
    final url = '$baseUrl/api/member/update/$memberId/';
    print('🌐 [$apiName] PATCH: $url');
    
    final headers = await _getHeaders();
    
    final response = await http.patch(
      Uri.parse(url),
      headers: headers,
      body: json.encode(data),
    );
    
    print('📡 [$apiName] Status: ${response.statusCode}');
    
    if (response.statusCode != 200 && response.statusCode != 201) {
      print('⚠️ [$apiName] Unexpected status: ${response.statusCode}');
      print('⚠️ [$apiName] Response: ${response.body}');
      throw Exception('Failed to update staff details: ${response.statusCode}\n${response.body}');
    }
  }

  Future<void> deleteStaffMember(int memberId) async {
    final apiName = 'deleteStaffMember';
    final url = '$baseUrl/api/member/update/$memberId/';
    print('🌐 [$apiName] DELETE: $url');
    
    final headers = await _getHeaders();
    
    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );
    
    print('📡 [$apiName] Status: ${response.statusCode}');
    
    if (response.statusCode != 200 && response.statusCode != 204) {
      print('⚠️ [$apiName] Unexpected status: ${response.statusCode}');
      print('⚠️ [$apiName] Response: ${response.body}');
      throw Exception('Failed to delete staff member: ${response.statusCode}\n${response.body}');
    }
  }
  
  
  // FIX: Add a method to clear cached token (for logout)
  void clearTokenCache() {
    _cachedToken = null;
    _tokenExpiry = null;
  }
}