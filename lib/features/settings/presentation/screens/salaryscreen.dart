import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/settings/presentation/provider/salary_provider.dart';
import 'package:offixoadmin/features/settings/domain/staff_list_model.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/screens/addsalaryscreen.dart';
import 'dart:async';

class SalaryScreen extends StatelessWidget {
  const SalaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SalaryProvider(),
      child: const _SalaryScreenView(),
    );
  }
}

class _SalaryScreenView extends StatefulWidget {
  const _SalaryScreenView();

  @override
  State<_SalaryScreenView> createState() => _SalaryScreenViewState();
}

class _SalaryScreenViewState extends State<_SalaryScreenView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<SalaryProvider>();
      if (!provider.isLoading && !provider.isLoadingMore) {
        provider.fetchStaffList();
      }
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SalaryProvider>().search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SalaryProvider>();

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: AppStyle.fontColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Salary Management',
                    style: AppStyle.text(
                      size: 20,
                      weight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: AppStyle.text(size: 14),
                decoration: InputDecoration(
                  hintText: 'Search by Emp ID, Name...',
                  hintStyle: AppStyle.text(size: 14, color: AppStyle.hintColor),
                  prefixIcon: const Icon(Icons.search, color: AppStyle.hintColor),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // List
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.errorMessage != null && provider.staffList.isEmpty
                      ? Center(
                          child: Text(
                            provider.errorMessage!,
                            style: AppStyle.text(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : provider.staffList.isEmpty
                          ? Center(
                              child: Text(
                                'No staff members found',
                                style: AppStyle.text(color: AppStyle.hintColor),
                              ),
                            )
                          : ListView.separated(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(20),
                              itemCount: provider.staffList.length +
                                  (provider.isLoadingMore ? 1 : 0),
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                if (index == provider.staffList.length) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                }

                                final staff = provider.staffList[index];
                                return _StaffCard(
                                  staff: staff,
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );

                                    final existingSalary = await provider.checkStaffSalary(staff.id);

                                    if (context.mounted) {
                                      Navigator.pop(context); // Close loading dialog
                                      
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => AddSalaryScreen(
                                            member: staff.toMemberModel(),
                                            isEditMode: existingSalary != null,
                                            existingSalary: existingSalary,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaffCard extends StatelessWidget {
  final StaffListItemModel staff;
  final VoidCallback onTap;

  const _StaffCard({required this.staff, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
                image: staff.profileImage != null && staff.profileImage!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(staff.profileImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: staff.profileImage == null || staff.profileImage!.isEmpty
                  ? Center(
                      child: Text(
                        _getInitials(staff.fullName),
                        style: AppStyle.text(
                          size: 16,
                          weight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    staff.fullName,
                    style: AppStyle.text(
                      size: 16,
                      weight: FontWeight.w700,
                      color: AppStyle.fontColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    staff.empNo,
                    style: AppStyle.text(
                      size: 12,
                      weight: FontWeight.w500,
                      color: AppStyle.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Department & Designation
                  if (staff.departmentName.isNotEmpty || staff.designationName.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.work_outline, size: 14, color: AppStyle.hintColor),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              [staff.designationName, staff.departmentName]
                                  .where((e) => e.isNotEmpty)
                                  .join(' • '),
                              style: AppStyle.text(
                                size: 12,
                                color: AppStyle.hintColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Branch
                  if (staff.branch != null && staff.branch!.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppStyle.hintColor),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            staff.branch!,
                            style: AppStyle.text(
                              size: 12,
                              color: AppStyle.hintColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppStyle.hintColor,
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }
}
