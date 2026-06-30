import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/staffdetails/data/models/staffprofilemodel.dart';

class ProfileCard extends StatelessWidget {
  final StaffProfile? profile;
  const ProfileCard({this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
  gradient: AppStyle.primaryGradient,
  borderRadius: BorderRadius.circular(16),
),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: profile?.profileImageUrl != null && profile!.profileImageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(profile!.profileImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: profile?.profileImageUrl == null || profile!.profileImageUrl!.isEmpty
                ? Center(
                    child: Text(
                      profile?.initials ?? '?',
                      style: AppStyle.text(
                        size: 24,
                        color: const Color(0xFF00BCD4),
                        weight: FontWeight.w700,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Branch/Status badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        profile?.branchDisplay ?? '--',
                        style: AppStyle.text(
                          size: 11,
                          color: Colors.white,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: (profile?.isActive ?? false)
                            ? const Color(0xFF22C55E).withOpacity(0.8)
                            : const Color(0xFFE53935).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            profile?.displayStatus ?? '--',
                            style: AppStyle.text(
                              size: 10,
                              color: Colors.white,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                // Name
                Text(
                  profile?.fullName ?? '--',
                  style: AppStyle.text(
                    size: 18,
                    color: Colors.white,
                    weight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                // Designation & Department
                Text(
                  profile?.designationDept ?? '--',
                  style: AppStyle.text(
                    size: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 2),
                // Employee ID
                Row(
                  children: [
                    const Icon(
                      Icons.badge_outlined,
                      size: 12,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'EMP: ${profile?.empNo ?? '--'}',
                      style: AppStyle.text(
                        size: 11,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}