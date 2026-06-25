import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/staffdetails/data/models/profileinfomodel.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/inforow.dart';

class ProfileInfoTab extends StatelessWidget {
  final ProfileInfo? info;
  final WorkDetails? work;
  const ProfileInfoTab({this.info, this.work});
 
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Profile Info Section ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, color: AppStyle.accentCyan, size: 20),
                  const SizedBox(width: 8),
                  Text('Profile Info',
                      style: AppStyle.text(size: 15, weight: FontWeight.w700)),
                ],
              ),
              const Divider(height: 20),
              InfoRow(
                icon: Icons.phone_outlined,
                label: 'Phone Number',
                value: info?.phoneNumber ?? '--',
              ),
              InfoRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: info?.email ?? '--',
              ),
              InfoRow(
                icon: Icons.water_drop_outlined,
                label: 'Blood Group',
                value: info?.bloodGroup ?? '--',
              ),
              InfoRow(
                icon: Icons.wc_outlined,
                label: 'Gender',
                value: info?.gender ?? '--',
              ),
              InfoRow(
                icon: Icons.cake_outlined,
                label: 'Date of Birth',
                value: info?.dateOfBirth ?? '--',
              ),
              InfoRow(
                icon: Icons.home_outlined,
                label: 'Present Address',
                value: info?.presentAddress ?? '--',
                isLast: true,
              ),
            ],
          ),
        ),
 
        const SizedBox(height: 16),
 
        // ── Work Details Section ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.work_outline_rounded,
                      color: AppStyle.accentCyan, size: 20),
                  const SizedBox(width: 8),
                  Text('Work Details',
                      style: AppStyle.text(size: 15, weight: FontWeight.w700)),
                ],
              ),
              const Divider(height: 20),
              InfoRow(
                icon: Icons.calendar_today_outlined,
                label: 'Date of Joining',
                value: work?.dateOfJoining ?? '--',
              ),
              InfoRow(
                icon: Icons.business_outlined,
                label: 'Department',
                value: work?.department ?? '--',
              ),
              InfoRow(
                icon: Icons.badge_outlined,
                label: 'Designation',
                value: work?.designation ?? '--',
              ),
              InfoRow(
                icon: Icons.payments_outlined,
                label: 'Salary Type',
                value: work?.salaryType ?? '--',
              ),
              InfoRow(
                icon: Icons.currency_rupee_outlined,
                label: 'Salary Amount',
                value: work?.salaryAmount != null
                    ? '₹ ${work!.salaryAmount}'
                    : '--',
              ),
              InfoRow(
                icon: Icons.schedule_outlined,
                label: 'Working Shift',
                value: work?.workingShift ?? '--',
                isLast: true,
              ),
            ],
          ),
        ),
 
        const SizedBox(height: 16),
 
        // ── Edit Button ──
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              gradient: AppStyle.primaryGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: Text('Edit',
                style: AppStyle.text(
                    size: 16, color: Colors.white, weight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }
}