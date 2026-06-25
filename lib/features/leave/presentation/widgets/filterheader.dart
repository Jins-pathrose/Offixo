import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/leave/presentation/provider/leaverequestprovider.dart';

class FilterHeader extends StatelessWidget {
  final LeaveRequestProvider provider;
  const FilterHeader({required this.provider});
 
  String get _label {
    switch (provider.activeFilter) {
      case LeaveFilter.pending: return 'Pending Requests';
      case LeaveFilter.approved: return 'Approved Requests';
      case LeaveFilter.rejected: return 'Rejected Requests';
    }
  }
 
  String get _filterText {
    switch (provider.activeFilter) {
      case LeaveFilter.pending: return 'Pending';
      case LeaveFilter.approved: return 'Approved';
      case LeaveFilter.rejected: return 'Rejected';
    }
  }
 
  Color get _filterColor {
    switch (provider.activeFilter) {
      case LeaveFilter.pending: return const Color(0xFFFF9800);
      case LeaveFilter.approved: return const Color(0xFF22C55E);
      case LeaveFilter.rejected: return const Color(0xFFE53935);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(_label,
            style: AppStyle.text(size: 15, weight: FontWeight.w600)),
        GestureDetector(
          onTap: () => _showFilterMenu(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _filterColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _filterColor.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Text(_filterText,
                    style: AppStyle.text(
                        size: 12,
                        color: _filterColor,
                        weight: FontWeight.w600)),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down_rounded,
                    size: 16, color: _filterColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
 
  void _showFilterMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ...LeaveFilter.values.map((f) {
                final labels = {
                  LeaveFilter.pending: 'Pending',
                  LeaveFilter.approved: 'Approved',
                  LeaveFilter.rejected: 'Rejected',
                };
                final colors = {
                  LeaveFilter.pending: const Color(0xFFFF9800),
                  LeaveFilter.approved: const Color(0xFF22C55E),
                  LeaveFilter.rejected: const Color(0xFFE53935),
                };
                return ListTile(
                  title: Text(labels[f]!,
                      style: AppStyle.text(
                          size: 14,
                          color: f == provider.activeFilter
                              ? colors[f]
                              : AppStyle.fontColor,
                          weight: f == provider.activeFilter
                              ? FontWeight.w600
                              : FontWeight.w400)),
                  trailing: f == provider.activeFilter
                      ? Icon(Icons.check_rounded, color: colors[f])
                      : null,
                  onTap: () {
                    provider.setFilter(f);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}