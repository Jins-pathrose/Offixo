// lib/features/staffs/presentation/screens/staff_screen.dart

import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/screens/addnewstaffscreen.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/screens/staffdetailscreen.dart';
import 'package:offixoadmin/features/staffs/presentation/controller/staffprovider.dart';
import 'package:offixoadmin/features/staffs/presentation/widgets/staffcard.dart';
import 'package:provider/provider.dart';
import 'package:offixoadmin/common/shimmer/shimmer_list.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StaffProvider()..loadStaffs(),
      child: const _StaffScreenBody(),
    );
  }
}

class _StaffScreenBody extends StatelessWidget {
  const _StaffScreenBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaffProvider>();

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // ── Header ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All Staffs",
                    style: AppStyle.text(size: 20, weight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddNewStaffScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 10),
                        ],
                      ),
                      child: const Icon(Icons.person_add_alt_1),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              // ── Search ──
              TextField(
                onChanged: provider.search,
                decoration: InputDecoration(
                  hintText: "Search with Name, Id or Phone..",
                  hintStyle: AppStyle.text(color: AppStyle.hintColor),
                  prefixIcon: const Icon(Icons.search_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppStyle.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppStyle.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: AppStyle.primaryColor),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ── Title + Count ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All Staffs",
                    style: AppStyle.text(size: 17, weight: FontWeight.w500),
                  ),
                  if (provider.state == StaffLoadState.loaded)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppStyle.primaryGradient,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "${provider.staffs.length} Members",
                        style: AppStyle.text(color: Colors.white, size: 13),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 15),

              // ── Body ──
              Expanded(child: _buildBody(provider)),
              if (provider.state == StaffLoadState.loaded &&
                  provider.totalCount > 0)
                _buildPaginationControls(context, provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginationControls(
    BuildContext context,
    StaffProvider provider,
  ) {
    final int startItem = (provider.currentPage - 1) * 10 + 1;
    final int endItem = startItem + provider.staffs.length - 1;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing $startItem–$endItem of ${provider.totalCount} Staff',
            style: AppStyle.text(size: 13, color: Colors.grey.shade700),
          ),
          Row(
            children: [
              _PaginationButton(
                title: 'Previous',
                isLoading: provider.isPreviousLoading,
                isEnabled:
                    provider.previousUrl != null && !provider.isNextLoading,
                onTap: () => provider.fetchPreviousPage(context),
              ),
              const SizedBox(width: 8),
              _PaginationButton(
                title: 'Next',
                isLoading: provider.isNextLoading,
                isEnabled:
                    provider.nextUrl != null && !provider.isPreviousLoading,
                onTap: () => provider.fetchNextPage(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBody(StaffProvider provider) {
    switch (provider.state) {
      case StaffLoadState.loading:
      case StaffLoadState.idle:
        return const ShimmerList(itemCount: 6, padding: EdgeInsets.zero);

      case StaffLoadState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                'Failed to load staffs',
                style: AppStyle.text(color: Colors.grey),
              ),
            ],
          ),
        );

      case StaffLoadState.loaded:
        if (provider.staffs.isEmpty) {
          return Center(
            child: Text(
              'No staff found',
              style: AppStyle.text(color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.loadStaffs(isRefresh: true),
          child: ListView.builder(
            itemCount: provider.staffs.length,
            itemBuilder: (context, index) {
              final staff = provider.staffs[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StaffDetailsScreen(staffId: staff.id),
                      ),
                    );
                    if (result == true) {
                      provider.loadStaffs(isRefresh: true);
                    }
                  },
                  child: StaffCard(
                    name: staff.fullName,
                    branch: staff.designation,
                    staffId: staff.empNo,
                    image: staff.faceImage ?? '',
                    isOnDuty: staff.isActive,
                  ),
                ),
              );
            },
          ),
        );
    }
  }
}

class _PaginationButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onTap;

  const _PaginationButton({
    required this.title,
    required this.isLoading,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled && !isLoading ? onTap : null,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isEnabled
                  ? AppStyle.primaryColor.withOpacity(0.1)
                  : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isEnabled ? AppStyle.primaryColor : Colors.grey.shade300,
          ),
        ),
        child:
            isLoading
                ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppStyle.primaryColor,
                  ),
                )
                : Text(
                  title,
                  style: AppStyle.text(
                    size: 13,
                    color: isEnabled ? AppStyle.primaryColor : Colors.grey,
                    weight: FontWeight.w600,
                  ),
                ),
      ),
    );
  }
}
