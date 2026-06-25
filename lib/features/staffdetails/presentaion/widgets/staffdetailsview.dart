
import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/staffdetails/data/models/staffprofilemodel.dart';
import 'package:offixoadmin/features/staffdetails/domain/enum.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/provider/staffdetailsprovider.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/profilecard.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/quickactions.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/tabcontent.dart';
import 'package:provider/provider.dart';


class StaffDetailsView extends StatefulWidget {
  const StaffDetailsView({super.key});

  @override
  State<StaffDetailsView> createState() => _StaffDetailsViewState();
}

class _StaffDetailsViewState extends State<StaffDetailsView> {
  @override
  void initState() {
    super.initState();
    // Called ONCE — no rebuild loop
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<StaffDetailsProvider>().loadAllData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaffDetailsProvider>();

    // ── REMOVED: WidgetsBinding.instance.addPostFrameCallback from here ──

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _StaffAppBar(),
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppStyle.accentCyan))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          ProfileCard(
                            profile: StaffProfile(
                              id: provider.staffDetails?.id ?? 0,
                              empNo: provider.staffDetails?.empNo ?? '',
                              firstName: provider.staffDetails?.firstName ?? '',
                              lastName: provider.staffDetails?.lastName ?? '',
                              email: provider.staffDetails?.email ?? '',
                              memberType: provider.staffDetails?.memberType ?? '',
                              departmentId: provider.staffDetails?.departmentId ?? 0,
                              departmentName: provider.staffDetails?.departmentName ?? '',
                              designationId: provider.staffDetails?.designationId ?? 0,
                              designationName: provider.staffDetails?.designationName ?? '',
                              currentShiftId: provider.staffDetails?.currentShiftId ?? 0,
                              currentShiftName: provider.staffDetails?.currentShiftName ?? '',
                              phoneNumber: provider.staffDetails?.phoneNumber ?? '',
                              bloodGroup: provider.staffDetails?.bloodGroup ?? '',
                              gender: provider.staffDetails?.gender ?? '',
                              dateOfBirth: provider.staffDetails?.dateOfBirth ?? '',
                              branch: provider.staffDetails?.branch,
                              presentAddress: provider.staffDetails?.presentAddress ?? '',
                              permanentAddress: provider.staffDetails?.permanentAddress ?? '',
                              emergencyContactName: provider.staffDetails?.emergencyContactName ?? '',
                              emergencyContactPhone: provider.staffDetails?.emergencyContactPhone ?? '',
                              proofDocument: provider.staffDetails?.proofDocument,
                              isBiometricEnabled: provider.staffDetails?.isBiometricEnabled ?? false,
                              faceImage1: provider.staffDetails?.faceImage1,
                              faceImage2: provider.staffDetails?.faceImage2,
                              faceImage3: provider.staffDetails?.faceImage3,
                              faceImage4: provider.staffDetails?.faceImage4,
                              allowManualEntry: provider.staffDetails?.allowManualEntry ?? false,
                              isActive: provider.staffDetails?.isActive ?? false,
                              organization: provider.staffDetails?.organization as Organization? ?? Organization.empty(),
                              startDate: provider.staffDetails?.startDate ?? '',
                              createdAt: provider.staffDetails?.createdAt ?? DateTime.now(),
                              updatedAt: provider.staffDetails?.updatedAt ?? DateTime.now(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          QuickActions(
                            activeTab: provider.activeTab,
                            onTabChanged: provider.setTab,
                          ),
                          const SizedBox(height: 16),
                          if (provider.activeTab == StaffDetailsTab.main) ...[
                            _MainTabBar(
                              activeTab: provider.activeMainTab,
                              onTabChanged: provider.setMainTab,
                            ),
                            const SizedBox(height: 16),
                          ],
                          TabContent(provider: provider),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaffAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Staff Details',
            style: AppStyle.text(size: 18, weight: FontWeight.w600),
          ),
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFCDD2)),
              ),
              child: Row(
                children: [
                  Text(
                    'Close',
                    style: AppStyle.text(
                      size: 13,
                      color: const Color(0xFFE53935),
                      weight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.close, size: 14, color: Color(0xFFE53935)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MainTabBar extends StatelessWidget {
  final StaffMainTab activeTab;
  final ValueChanged<StaffMainTab> onTabChanged;

  const _MainTabBar({required this.activeTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: StaffMainTab.values.map((tab) {
          final isActive = tab == activeTab;
          final label = switch (tab) {
            StaffMainTab.attendance => 'Attendance',
            StaffMainTab.leave => 'Leave',
            StaffMainTab.salary => 'Salary',
          };
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 36,
                decoration: BoxDecoration(
                  gradient: isActive ? AppStyle.primaryGradient : null,
                  borderRadius: BorderRadius.circular(26),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: AppStyle.text(
                    size: 13,
                    color: isActive ? Colors.white : AppStyle.hintColor,
                    weight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
