import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/provider/staffdetailsprovider.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/settingsitem.dart';

class SettingsTab extends StatelessWidget {
  final StaffDetailsProvider provider;

  const SettingsTab({required this.provider});

  @override
  Widget build(BuildContext context) {
    final items = [
      // SettingsItem(
      //   icon: Icons.description_outlined,
      //   iconColor: const Color(0xFF00ACC1),
      //   label: 'Add / Update Documents',
      //   onTap: () {},
      // ),
      // SettingsItem(
      //   icon: Icons.emergency_outlined,
      //   iconColor: const Color(0xFFFF7043),
      //   label: 'Emergency Contact Details',
      //   onTap: () {},
      // ),
      // SettingsItem(
      //   icon: Icons.account_circle_outlined,
      //   iconColor: const Color(0xFF00ACC1),
      //   label: 'Update Image',
      //   onTap: () {},
      // ),
      SettingsItem(
        icon: Icons.delete_outline_rounded,
        iconColor: const Color(0xFFE53935),
        label: 'Delete User Profile',
        isDestructive: true,
        onTap: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete User Profile'),
              content: const Text('Are you sure you want to delete this user? This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );

          if (confirm == true) {
            try {
              await provider.deleteStaff();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Staff member deleted successfully.')),
                );
                // Go back to the previous screen since the user is deleted
                Navigator.of(context).pop();
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete user.')),
                );
              }
            }
          }
        },
      ),
    ];
 
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.settings_outlined,
                color: AppStyle.accentCyan, size: 20),
            const SizedBox(width: 8),
            Text('User Settings',
                style: AppStyle.text(size: 15, weight: FontWeight.w700)),
          ]),
          const Divider(height: 20),
          ...items.asMap().entries.map((e) => Column(
                children: [
                  e.value,
                  if (e.key < items.length - 1)
                    const Divider(height: 1, thickness: 0.5),
                ],
              )),
        ],
      ),
    );
  }
}