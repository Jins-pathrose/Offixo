import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/leavebalance/data/models/leavebalancemodel.dart';
import 'package:offixoadmin/features/leavebalance/presentation/provider/leavebalanceprovider.dart';
import 'package:provider/provider.dart';

class LeaveBalanceScreen extends StatelessWidget {
  const LeaveBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LeaveBalanceProvider(),
      child: const _LeaveBalanceView(),
    );
  }
}

class _LeaveBalanceView extends StatelessWidget {
  const _LeaveBalanceView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeaveBalanceProvider>();

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ── Header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Leave Balances',
                      style:
                          AppStyle.text(size: 20, weight: FontWeight.w700)),
                  if (provider.year != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00BCD4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('${provider.year}',
                          style: AppStyle.text(
                              size: 12,
                              color: Colors.white,
                              weight: FontWeight.w600)),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Search Bar ──
              TextField(
                onChanged: provider.search,
                style: AppStyle.text(size: 13),
                decoration: InputDecoration(
                  hintText: 'Search by name, ID, branch...',
                  hintStyle:
                      AppStyle.text(size: 13, color: AppStyle.hintColor),
                  prefixIcon: const Icon(Icons.search_outlined,
                      color: AppStyle.hintColor),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppStyle.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppStyle.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppStyle.accentCyan),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // ── Body ──
              Expanded(child: _buildBody(provider)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(LeaveBalanceProvider provider) {
    switch (provider.state) {
      case BalanceLoadState.idle:
      case BalanceLoadState.loading:
        return const Center(
            child: CircularProgressIndicator(color: AppStyle.accentCyan));

      case BalanceLoadState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text('Failed to load balances',
                  style: AppStyle.text(color: Colors.grey)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: provider.loadBalances,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: AppStyle.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Retry',
                      style: AppStyle.text(
                          color: Colors.white, weight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );

      case BalanceLoadState.loaded:
        if (provider.employees.isEmpty) {
          return Center(
            child: Text('No employees found',
                style: AppStyle.text(color: Colors.grey)),
          );
        }
        return RefreshIndicator(
          onRefresh: provider.loadBalances,
          color: AppStyle.accentCyan,
          child: ListView.separated(
            itemCount: provider.employees.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _EmployeeBalanceCard(employee: provider.employees[index]),
          ),
        );
    }
  }
}

// ─────────────────────────────────────────────
// EMPLOYEE BALANCE CARD
// ─────────────────────────────────────────────

class _EmployeeBalanceCard extends StatelessWidget {
  final EmployeeLeaveBalance employee;
  const _EmployeeBalanceCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Avatar + Name + Designation ──
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F7FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  employee.fullName.isNotEmpty
                      ? employee.fullName[0].toUpperCase()
                      : '?',
                  style: AppStyle.text(
                      size: 18,
                      color: AppStyle.accentCyan,
                      weight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(employee.fullName,
                        style: AppStyle.text(
                            size: 14, weight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(employee.designation,
                            style: AppStyle.text(
                                size: 11,
                                color: AppStyle.accentCyan,
                                weight: FontWeight.w500)),
                        Text(' • ${employee.empNo}',
                            style: AppStyle.text(
                                size: 11, color: AppStyle.hintColor)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(employee.branchName,
                        style: AppStyle.text(
                            size: 11, color: AppStyle.hintColor)),
                  ],
                ),
              ),

              // Total remaining badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFF22C55E).withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(employee.totalRemaining.toStringAsFixed(0),
                        style: AppStyle.text(
                            size: 15,
                            color: const Color(0xFF22C55E),
                            weight: FontWeight.w700)),
                    Text('left',
                        style: AppStyle.text(
                            size: 9, color: const Color(0xFF22C55E))),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 20),

          // ── Leave Type Balances ──
          ...employee.balances.asMap().entries.map((entry) {
            final isLast = entry.key == employee.balances.length - 1;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: _LeaveTypeRow(balance: entry.value),
            );
          }),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LEAVE TYPE ROW with progress bar
// ─────────────────────────────────────────────

class _LeaveTypeRow extends StatelessWidget {
  final LeaveBalanceModel balance;
  const _LeaveTypeRow({required this.balance});

  Color get _color {
    switch (balance.leaveTypeCode) {
      case 'SL':
        return const Color(0xFF00ACC1);
      case 'CL':
        return const Color(0xFF22C55E);
      case 'RH':
        return const Color(0xFFFF9800);
      default:
        return AppStyle.accentCyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(balance.leaveTypeCode,
                      style: AppStyle.text(
                          size: 10,
                          color: _color,
                          weight: FontWeight.w700)),
                ),
                const SizedBox(width: 8),
                Text(balance.leaveTypeName,
                    style: AppStyle.text(size: 12, weight: FontWeight.w500)),
              ],
            ),
            Text(
              '${balance.remainingBalance.toStringAsFixed(0)} / ${balance.totalAllocated.toStringAsFixed(0)}',
              style: AppStyle.text(
                  size: 12,
                  color: AppStyle.hintColor,
                  weight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Progress bar — shows used vs total
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: balance.usedFraction,
            minHeight: 6,
            backgroundColor: _color.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation<Color>(_color),
          ),
        ),
      ],
    );
  }
}