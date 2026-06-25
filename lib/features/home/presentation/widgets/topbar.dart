import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/home/presentation/widgets/notificationbell.dart';

class TopBar extends StatelessWidget {
  final String clinicName;
  final int notificationCount;
 
  const TopBar({
    required this.clinicName,
    this.notificationCount = 1,
  });
 
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
              image: NetworkImage('https://media.gettyimages.com/id/1312706504/photo/modern-hospital-building.jpg?s=1024x1024&w=gi&k=20&c=RXpNBi29PyBzIPD7aWekJImubSm_mZuCXrYCZsRCPDQ='),
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
                style: AppStyle.text(
                  size: 12,
                  color: Color(0xFF232323),
                ),
              ),
              Text(
                clinicName,
                style: AppStyle.text(
                  size: 18,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
 
        // Notification bell
        NotificationBell(count: notificationCount),
      ],
    );
  }
}