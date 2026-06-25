import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/bottomnavigation/presentaion/widgets/navbar.dart';
import 'package:offixoadmin/features/home/presentation/screens/homescreen.dart';
import 'package:offixoadmin/features/leave/presentation/screens/leavescreen.dart';
import 'package:offixoadmin/features/settings/presentation/screens/settingsscreen.dart';
import 'package:offixoadmin/features/staffs/presentation/screens/staffscreen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    StaffScreen(),
    LeaveRequestScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      // extendBody lets page content scroll behind the floating nav bar
      // while the nav bar itself handles the system inset
      extendBody: true,
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}