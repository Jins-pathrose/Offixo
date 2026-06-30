import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/staffdetails/domain/enum.dart';

class QuickActions extends StatelessWidget {
  final StaffDetailsTab activeTab;
  final ValueChanged<StaffDetailsTab> onTabChanged;

  const QuickActions({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.grid_view_rounded, 'Main', StaffDetailsTab.main),
      (Icons.person_outline_rounded, 'Profile Info', StaffDetailsTab.profileInfo),
      (Icons.phone_outlined, 'Contact', StaffDetailsTab.contact),
      (Icons.edit_outlined, 'Edit', StaffDetailsTab.edit),
      (Icons.settings_outlined, 'Settings', StaffDetailsTab.settings),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: actions.map((a) {
          final isActive = a.$3 == activeTab;

          return GestureDetector(
            onTap: () => onTabChanged(a.$3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: isActive ? AppStyle.primaryGradient : null,
                    color: isActive
                        ? null
                        : const Color(0xFFE0F7FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    a.$1,
                    size: 20,
                    color: isActive
                        ? Colors.white
                        : AppStyle.primaryColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  a.$2,
                  style: AppStyle.text(
                    size: 11,
                    color: isActive
                        ? AppStyle.primaryColor
                        : AppStyle.hintColor,
                    weight: isActive
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}