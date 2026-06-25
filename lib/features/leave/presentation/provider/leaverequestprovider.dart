import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/leave/data/model/leaverequestmodel.dart';

enum LeaveLoadState { idle, loading, loaded, error }
enum LeaveFilter { pending, approved, rejected }

class LeaveRequestProvider extends ChangeNotifier {
  static const String _baseUrl =
      'https://offixo.archanastones.in/api/leave/member/request/';
  static const String _reviewBaseUrl =
      'https://offixo.archanastones.in/api/leave/request/';

  final StorageService _storageService = StorageService();

  LeaveLoadState state = LeaveLoadState.idle;
  LeaveFilter activeFilter = LeaveFilter.pending;
  String? error;

  List<LeaveRequestModel> _all = [];

  // Counts
  int get pendingCount => _all.where((l) => l.isPending).length;
  int get approvedCount => _all.where((l) => l.isApproved).length;
  int get rejectedCount => _all.where((l) => l.isRejected).length;

  // Filtered list shown in UI
  List<LeaveRequestModel> get filtered {
    switch (activeFilter) {
      case LeaveFilter.pending:
        return _all.where((l) => l.isPending).toList();
      case LeaveFilter.approved:
        return _all.where((l) => l.isApproved).toList();
      case LeaveFilter.rejected:
        return _all.where((l) => l.isRejected).toList();
    }
  }

  LeaveRequestProvider() {
    loadRequests();
  }

  void setFilter(LeaveFilter filter) {
    activeFilter = filter;
    notifyListeners();
  }

  Future<void> loadRequests() async {
    state = LeaveLoadState.loading;
    error = null;
    notifyListeners();
    try {
      final token = await _storageService.getAccessToken();
      final res = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        _all = list.map((e) => LeaveRequestModel.fromJson(e)).toList();
        state = LeaveLoadState.loaded;
      } else {
        error = 'Failed to load leave requests';
        state = LeaveLoadState.error;
      }
    } catch (e) {
      error = 'Network error: $e';
      state = LeaveLoadState.error;
    }
    notifyListeners();
  }

  // ── Approve ──
  Future<bool> approve(int requestId, BuildContext context) async {
    return _review(
      requestId: requestId,
      status: 'APPROVED',
      rejectionReason: null,
      context: context,
    );
  }

  // ── Reject ──
  Future<bool> reject({
    required int requestId,
    required String rejectionReason,
    required BuildContext context,
  }) async {
    return _review(
      requestId: requestId,
      status: 'REJECTED',
      rejectionReason: rejectionReason,
      context: context,
    );
  }

  Future<bool> _review({
    required int requestId,
    required String status,
    String? rejectionReason,
    required BuildContext context,
  }) async {
    try {
      final token = await _storageService.getAccessToken();
      final body = <String, dynamic>{'status': status};
      if (rejectionReason != null && rejectionReason.isNotEmpty) {
        body['rejection_reason'] = rejectionReason;
      }

      final res = await http.patch(
        Uri.parse('$_reviewBaseUrl$requestId/review/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      debugPrint('Review status: ${res.statusCode} body: ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        // Update local list optimistically
        _all = _all.map((l) {
          if (l.id == requestId) {
            return LeaveRequestModel.fromJson({
              ...jsonDecode(jsonEncode({
                'id': l.id,
                'member': l.member,
                'member_name': l.memberName,
                'member_emp_no': l.memberEmpNo,
                'leave_type': l.leaveType,
                'leave_type_name': l.leaveTypeName,
                'from_date': l.fromDate,
                'to_date': l.toDate,
                'session': l.session,
                'number_of_days': l.numberOfDays,
                'reason': l.reason,
                'status': status,
                'applied_at': l.appliedAt,
                'reviewed_by_name': null,
                'rejection_reason': rejectionReason,
              })),
            });
          }
          return l;
        }).toList();
        notifyListeners();
        return true;
      } else {
        _showSnack(context,
            'Failed: ${jsonDecode(res.body)['detail'] ?? res.statusCode}',
            isError: true);
        return false;
      }
    } catch (e) {
      _showSnack(context, 'Network error: $e', isError: true);
      return false;
    }
  }

  void _showSnack(BuildContext context, String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor:
          isError ? const Color(0xFFE53935) : const Color(0xFF22C55E),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    ));
  }
}