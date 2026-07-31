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

class _StaffScreenBody extends StatefulWidget {
  const _StaffScreenBody();

  @override
  State<_StaffScreenBody> createState() => _StaffScreenBodyState();
}

class _StaffScreenBodyState extends State<_StaffScreenBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<StaffProvider>();
      if (!provider.isNextLoading) {
        provider.fetchNextPage(context);
      }
    }
  }

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
            ],
          ),
        ),
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
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount:
                provider.staffs.length + (provider.isNextLoading ? 3 : 0),
            itemBuilder: (context, index) {
              if (index >= provider.staffs.length) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: ShimmerListItem(),
                );
              }

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
