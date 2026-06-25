import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/branch/presentation/screens/branchscreen.dart';
import 'package:offixoadmin/features/department/presentation/screens/departmentscreen.dart';
import 'package:offixoadmin/features/designation/presentation/screens/designationscreen.dart';
import 'package:offixoadmin/features/login/presentation/screen/loginscreen.dart';
import 'package:offixoadmin/features/settings/data/authservice.dart';
import 'package:offixoadmin/features/settings/presentation/widgets/cliniccard.dart';
import 'package:offixoadmin/features/settings/presentation/widgets/menucard.dart';
import 'package:offixoadmin/features/settings/presentation/widgets/menuitem.dart';
import 'package:offixoadmin/features/shift/presentation/screens/shiftscreen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final authService = AuthService();
    await authService
        .logout(); // clears storage instantly, API runs in background

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming Soon! 🚀'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await _logout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ── Title ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Settings',
                  style: AppStyle.text(size: 22, weight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 16),

              // ── Clinic Card ──
              const ClinicCard(),
              const SizedBox(height: 16),

              // ── Menu Group 1 ──
              MenuCard(
                items: [
                  MenuItem(
                    icon: Icons.account_tree_outlined,
                    label: 'Branches',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BranchesScreen()),
                    ),
                  ),
                  MenuItem(
                    icon: Icons.domain_outlined,
                    label: 'Departments',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DepartmentsScreen(),
                      ),
                    ),
                  ),
                  MenuItem(
                    icon: Icons.badge_outlined,
                    label: 'Designations',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DesignationsScreen(),
                      ),
                    ),
                  ),
                  MenuItem(
                    icon: Icons.work_outline_rounded,
                    label: 'Salary Creations',
                    onTap: () => _showComingSoon(context),
                  ),
                  MenuItem(
                    icon: Icons.access_time_outlined,
                    label: 'Shifts',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ShiftScreen()),
                    ),
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Menu Group 2 ──
              MenuCard(
                items: [
                  MenuItem(
                    icon: Icons.logout_rounded,
                    label: 'Logout',
                    onTap: () => _showLogoutConfirmation(context),
                  ),
                  MenuItem(
                    icon: Icons.delete_outline_rounded,
                    label: 'Delete User Profile',
                    labelColor: const Color(0xFFE53935),
                    iconColor: const Color(0xFFE53935),
                    onTap: () => _showComingSoon(context),
                    isLast: true,
                    showChevron: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
