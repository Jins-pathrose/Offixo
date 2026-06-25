import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';

// ─────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────

class LiveStatusMember {
  final int memberId;
  final String name;
  final String branchName;
  final String liveStatus; // CHECKED_IN | CHECKED_OUT | NOT_CHECKED_IN
  final int? attendanceId;
  final String? lastCheckinTime;
  final String? lastCheckoutTime;
  final String? totalWorkingHoursToday;
  final String? profileImage;

  bool get isOnDuty => liveStatus == 'CHECKED_IN';

  // Format "HH:MM:SS" → "HH hr MM min"
  String get workingHoursFormatted {
    if (totalWorkingHoursToday == null) return '--';
    final parts = totalWorkingHoursToday!.split(':');
    if (parts.length < 2) return totalWorkingHoursToday!;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    if (h == 0) return '${m}min';
    return '${h}hr ${m}min';
  }

  // "2026-06-09T05:24:34.037217Z" → "05:24 AM"
  String get checkinFormatted {
    if (lastCheckinTime == null) return '--';
    try {
      final dt = DateTime.parse(lastCheckinTime!).toLocal();
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour < 12 ? 'AM' : 'PM';
      return '$h:$m $period';
    } catch (_) {
      return '--';
    }
  }

  const LiveStatusMember({
    required this.memberId,
    required this.name,
    required this.branchName,
    required this.liveStatus,
    this.attendanceId,
    this.lastCheckinTime,
    this.lastCheckoutTime,
    this.totalWorkingHoursToday,
    this.profileImage,
  });

  factory LiveStatusMember.fromJson(Map<String, dynamic> json) =>
      LiveStatusMember(
        memberId: json['member_id'] ?? 0,
        name: json['name'] ?? '',
        branchName: json['branch_name'] ?? '',
        liveStatus: json['live_status'] ?? '',
        attendanceId: json['attendance_id'],
        lastCheckinTime: json['last_checkin_time'],
        lastCheckoutTime: json['last_checkout_time'],
        totalWorkingHoursToday: json['total_working_hours_today'],
        profileImage: json['profile_image'],
      );
}

// ─────────────────────────────────────────────
// PROVIDER
// ─────────────────────────────────────────────

enum HomeLoadState { idle, loading, loaded, error }

class HomeProvider extends ChangeNotifier {
  static const String _liveStatusUrl =
      'https://offixo.archanastones.in/api/maintainer/live-status/';
  static const String _profileUrl =
      'https://offixo.archanastones.in/api/accounts/maintainer/profile/';

  final StorageService _storageService = StorageService();

  // ── State ──
  HomeLoadState state = HomeLoadState.idle;
  String? error;

  // ── Data ──
  String organizationName = '';
  List<LiveStatusMember> liveStatus = [];
  int totalCheckedIn = 0;
  int totalCheckedOut = 0;
  int totalMembers = 0;

  HomeProvider() {
    loadAll();
  }

  Future<void> loadAll() async {
    state = HomeLoadState.loading;
    error = null;
    notifyListeners();
    try {
      await Future.wait([_fetchProfile(), _fetchLiveStatus()]);
      state = HomeLoadState.loaded;
    } catch (e) {
      error = 'Failed to load: $e';
      state = HomeLoadState.error;
    }
    notifyListeners();
  }

  // ── Fetch org name from profile ──
  Future<void> _fetchProfile() async {
    final token = await _storageService.getAccessToken();
    final res = await http.get(
      Uri.parse(_profileUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final maintainer = json['maintainer'] as Map<String, dynamic>? ?? {};
      final org = maintainer['organization'] as Map<String, dynamic>? ?? {};
      organizationName = org['name'] ?? '';
    }
  }

  // ── Fetch live check-in status ──
 Future<void> _fetchLiveStatus() async {
  final token = await _storageService.getAccessToken();
  final res = await http.get(
    Uri.parse(_liveStatusUrl),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );
  if (res.statusCode == 200) {
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final branches = (json['branches'] as Map<String, dynamic>? ?? {});

    final List<LiveStatusMember> allMembers = [];
    branches.forEach((branchName, members) {
      final list = (members as List? ?? []);
      for (final m in list) {
        final map = Map<String, dynamic>.from(m as Map);
        map['branch_name'] = branchName; // inject branch name since it's not in each member object
        allMembers.add(LiveStatusMember.fromJson(map));
      }
    });

    liveStatus = allMembers;
    totalMembers = json['total_members_counted'] ?? liveStatus.length;
    totalCheckedIn =
        liveStatus.where((m) => m.liveStatus == 'CHECKED_IN').length;
    totalCheckedOut =
        liveStatus.where((m) => m.liveStatus == 'CHECKED_OUT').length;
  } else {
    throw Exception('Live status failed: ${res.statusCode}');
  }
}
}