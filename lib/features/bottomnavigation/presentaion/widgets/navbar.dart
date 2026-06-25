import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Bottom safe-area inset — accounts for Android 3-button nav bar
    // or gesture-pill, and iOS home indicator.
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        12 + bottomInset, // pushes the nav bar above the system nav
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _navItem(
              svgPath: 'assets/svg/Vector (5).svg',
              index: 0,
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: _navItem(
              svgPath: 'assets/svg/Users.svg',
              index: 1,
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: _navItem(
              svgPath: 'assets/svg/mynaui_calendar-off.svg',
              index: 2,
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: _navItem(
              svgPath: 'assets/svg/lsicon_setting-outline.svg',
              index: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required String svgPath,
    required int index,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: isSelected ? AppStyle.primaryGradient : null,
          color: isSelected ? null : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: SvgPicture.asset(
            svgPath,
            width: 22,
            height: 22,
            colorFilter: ColorFilter.mode(
              isSelected ? Colors.white : Colors.black87,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}