import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/screens/addnewstaffscreen.dart';
import 'package:offixoadmin/features/checkincheckouts/presentation/screens/checkincheckoutscreen.dart';
import 'package:offixoadmin/features/home/data/quickactionmodel.dart';
import 'package:offixoadmin/features/home/data/statcardmodel.dart';
import 'package:offixoadmin/features/home/presentation/provider/homeprovider.dart';
import 'package:offixoadmin/features/home/presentation/widgets/quickactiongrid.dart';
import 'package:offixoadmin/features/home/presentation/widgets/sectionheader.dart';
import 'package:offixoadmin/features/home/presentation/widgets/statcard.dart';
import 'package:offixoadmin/features/home/presentation/widgets/topbar.dart';
import 'package:offixoadmin/features/leave/presentation/screens/leavescreen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeProvider(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  static List<QuickActionData> _buildQuickActions(BuildContext context) => [
        QuickActionData(
          label: 'Add Staff',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNewStaffScreen()),
          ),
        ),
        QuickActionData(
          label: 'Check-Ins',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AttendanceScreen()),
          ),
        ),
        QuickActionData(
          label: 'Attendance',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AttendanceScreen()),
          ),
        ),
        QuickActionData(
          label: 'Today Leaves',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LeaveRequestScreen()),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    // Build stat cards from live API data
    final stats = [
      StatCardData(
        icon: "assets/svg/Group.svg",
        count: '${provider.totalCheckedIn}',
        label: "Today's\nCheck-ins",
        startColor: const Color(0xFF0DC085),
        endColor: const Color(0xFF05965E),
      ),
      StatCardData(
        icon: "assets/svg/Group (1).svg",
        count: '${provider.totalCheckedOut}',
        label: "Today's\nCheck-outs",
        startColor: const Color(0xFFFF6348),
        endColor: const Color(0xFFDC2626),
      ),
      StatCardData(
        icon: "assets/svg/Vector (4).svg",
        count: '${provider.totalMembers}',
        label: 'Total\nStaffs',
        startColor: const Color(0xFF06B6D4),
        endColor: const Color(0xFF2294D6),
      ),
    ];

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: provider.loadAll,
          color: AppStyle.accentCyan,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // ── Top Bar — org name from API ──
                TopBar(
                  clinicName: provider.organizationName.isNotEmpty
                      ? provider.organizationName
                      : 'Loading...',
                ),

                const SizedBox(height: 20),

                // ── Stat Cards ──
                provider.state == HomeLoadState.loading
                    ? const _StatsShimmer()
                    : StatCardsRow(stats: stats),

                const SizedBox(height: 24),

                // ── Quick Actions ──
                SectionHeader(title: 'Quick Actions'),
                const SizedBox(height: 12),
                QuickActionsGrid(actions: _buildQuickActions(context)),

                const SizedBox(height: 24),

                // ── Today's Check-ins ──
                SectionHeader(
                  title: "Today's Check-ins",
                  trailingLabel: 'View All',
                  onTrailingTap: () {
                    // TODO: navigate to full check-ins list
                  },
                ),
                const SizedBox(height: 12),

                // ── Live Status List ──
                _LiveStatusList(provider: provider),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LIVE STATUS LIST
// ─────────────────────────────────────────────

class _LiveStatusList extends StatelessWidget {
  final HomeProvider provider;
  const _LiveStatusList({required this.provider});

  @override
  Widget build(BuildContext context) {
    switch (provider.state) {
      case HomeLoadState.idle:
      case HomeLoadState.loading:
        return Column(
          children: List.generate(
            3,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: _CardShimmer(),
            ),
          ),
        );

      case HomeLoadState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                const Icon(Icons.wifi_off_rounded,
                    size: 40, color: Colors.grey),
                const SizedBox(height: 8),
                Text('Failed to load',
                    style: AppStyle.text(color: Colors.grey)),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: provider.loadAll,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: AppStyle.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Retry',
                        style: AppStyle.text(
                            color: Colors.white,
                            weight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        );

      case HomeLoadState.loaded:
        if (provider.liveStatus.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text('No check-ins today',
                  style: AppStyle.text(color: Colors.grey)),
            ),
          );
        }
        return Column(
          children: provider.liveStatus
              .map((member) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _LiveStatusCard(member: member),
                  ))
              .toList(),
        );
    }
  }
}

// ─────────────────────────────────────────────
// LIVE STATUS CARD
// ─────────────────────────────────────────────

class _LiveStatusCard extends StatelessWidget {
  final LiveStatusMember member;
  const _LiveStatusCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F7FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: member.profileImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://offixo.archanastones.in${member.profileImage}',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.person,
                          color: AppStyle.accentCyan),
                    ),
                  )
                : const Icon(Icons.person, color: AppStyle.accentCyan),
          ),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(member.name,
                    style:
                        AppStyle.text(size: 14, weight: FontWeight.w600)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(member.branchName,
                        style: AppStyle.text(
                            size: 11,
                            color: AppStyle.accentCyan,
                            weight: FontWeight.w500)),
                    if (member.lastCheckinTime != null) ...[
                      Text(' • ',
                          style: AppStyle.text(
                              size: 11, color: AppStyle.hintColor)),
                      Text(member.checkinFormatted,
                          style: AppStyle.text(
                              size: 11, color: AppStyle.hintColor)),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Status badge
          _StatusBadge(status: member.liveStatus),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// STATUS BADGE
// ─────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case 'CHECKED_IN':
        color = const Color(0xFF22C55E);
        label = 'On Duty';
        break;
      case 'CHECKED_OUT':
        color = const Color(0xFFFF9800);
        label = 'Checked Out';
        break;
      default:
        color = AppStyle.hintColor;
        label = 'Not In';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style: AppStyle.text(
              size: 11, color: color, weight: FontWeight.w600)),
    );
  }
}

// ─────────────────────────────────────────────
// SHIMMER PLACEHOLDERS
// ─────────────────────────────────────────────

class _StatsShimmer extends StatelessWidget {
  const _StatsShimmer();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        3,
        (i) => Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < 2 ? 10 : 0),
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardShimmer extends StatelessWidget {
  const _CardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}