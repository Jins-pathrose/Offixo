import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/home/presentation/widgets/notificationbell.dart';
import 'package:offixoadmin/common/shimmer/shimmer_container.dart';

class TopBar extends StatelessWidget {
  final String clinicName;
  final int notificationCount;

  const TopBar({required this.clinicName, this.notificationCount = 1});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Clinic avatar
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade300,
            image: const DecorationImage(
              image: NetworkImage(
                'https://wallpapers.com/images/featured/hd-office-background-wwmb5ymdbjbjv689.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Welcome text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back,',
                style: AppStyle.text(size: 12, color: Color(0xFF232323)),
              ),
              if (clinicName.isEmpty || clinicName == 'Loading...')
                const ShimmerContainer(width: 120, height: 20, borderRadius: 4)
              else
                Text(
                  clinicName,
                  style: AppStyle.text(size: 18, weight: FontWeight.w700),
                ),
            ],
          ),
        ),

        // Notification bell
        // NotificationBell(count: notificationCount),
      ],
    );
  }
}
