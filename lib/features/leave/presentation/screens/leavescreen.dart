import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/leave/data/model/leaverequestmodel.dart';
import 'package:offixoadmin/features/leave/presentation/provider/leaverequestprovider.dart';
import 'package:offixoadmin/features/leave/presentation/widgets/filterheader.dart';
import 'package:offixoadmin/features/leave/presentation/widgets/leavecard.dart';
import 'package:offixoadmin/features/leave/presentation/widgets/leavedetailsheet.dart';
import 'package:offixoadmin/features/leave/presentation/widgets/leavesummaryrow.dart';
import 'package:offixoadmin/features/leavebalance/presentation/screens/leavesbalancescreen.dart';
import 'package:offixoadmin/features/leavetype/presentation/screens/leavetypescreen.dart';
import 'package:provider/provider.dart';

class LeaveRequestScreen extends StatelessWidget {
  const LeaveRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LeaveRequestProvider(),
      child: const _LeaveRequestView(),
    );
  }
}

class _LeaveRequestView extends StatelessWidget {
  const _LeaveRequestView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeaveRequestProvider>();

    return Scaffold(
      floatingActionButton: Padding(
  padding: const EdgeInsets.only(bottom: 100.0), // Adjust as needed
        child: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LeaveTypeScreen()),
        ),
        backgroundColor: AppStyle.accentCyan,
        child: const Icon(Icons.playlist_add_rounded, color: Colors.white),
            ),
      ),
    floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat, // Add this line
    backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ──
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Leave Requests',
                        style: AppStyle.text(
                            size: 20, weight: FontWeight.w700)),
                  ),
                  // ── Leave Balances button ──
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LeaveBalanceScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: AppStyle.primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.account_balance_wallet_outlined,
                              size: 15, color: Colors.white),
                          const SizedBox(width: 6),
                          Text('Balances',
                              style: AppStyle.text(
                                  size: 12,
                                  color: Colors.white,
                                  weight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Summary Badges ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SummaryRow(provider: provider),
            ),
            const SizedBox(height: 16),

            // ── Filter Label + Dropdown ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FilterHeader(provider: provider),
            ),
            const SizedBox(height: 12),

            // ── List ──
            Expanded(
              child: _buildBody(context, provider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, LeaveRequestProvider provider) {
    switch (provider.state) {
      case LeaveLoadState.idle:
      case LeaveLoadState.loading:
        return const Center(
            child: CircularProgressIndicator(color: AppStyle.accentCyan));

      case LeaveLoadState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text('Failed to load',
                  style: AppStyle.text(color: Colors.grey)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: provider.loadRequests,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
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
        );

      case LeaveLoadState.loaded:
        final list = provider.filtered;
        if (list.isEmpty) {
          return Center(
            child: Text(
                'No ${_filterLabel(provider.activeFilter)} requests',
                style: AppStyle.text(color: Colors.grey)),
          );
        }
        return RefreshIndicator(
          onRefresh: provider.loadRequests,
          color: AppStyle.accentCyan,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => LeaveCard(
              leave: list[index],
              onViewTap: () => _showDetail(context, list[index]),
            ),
          ),
        );
    }
  }

  String _filterLabel(LeaveFilter f) {
    switch (f) {
      case LeaveFilter.pending:
        return 'Pending';
      case LeaveFilter.approved:
        return 'Approved';
      case LeaveFilter.rejected:
        return 'Rejected';
    }
  }

  void _showDetail(BuildContext context, LeaveRequestModel leave) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<LeaveRequestProvider>(),
        child: LeaveDetailSheet(leave: leave),
      ),
    );
  }
}