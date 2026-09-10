import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/medicines/data/model/medicine_model.dart';
import 'package:offixoadmin/features/medicines/presentation/provider/medicine_provider.dart';
import 'package:provider/provider.dart';
import 'package:offixoadmin/common/shimmer/shimmer_list.dart';
import 'package:offixoadmin/features/home/presentation/provider/homeprovider.dart';
import 'package:offixoadmin/features/medicines/presentation/screens/selected_medicines_screen.dart';

class MedicinesScreen extends StatelessWidget {
  const MedicinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MedicineProvider(),
      child: const _MedicinesView(),
    );
  }
}

class _MedicinesView extends StatelessWidget {
  const _MedicinesView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicineProvider>();

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ── App Bar ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Medicines',
                    style: AppStyle.text(size: 20, weight: FontWeight.w700),
                  ),
                  Row(
                    children: [
                      // GestureDetector(
                      //   onTap: () => _showMemberSelectionSheet(context),
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 14,
                      //       vertical: 6,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(20),
                      //       border: Border.all(color: AppStyle.accentCyan),
                      //     ),
                      //     child: Text(
                      //       'Selected',
                      //       style: AppStyle.text(
                      //         size: 13,
                      //         color: AppStyle.accentCyan,
                      //         weight: FontWeight.w500,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
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
                              const Icon(
                                Icons.close,
                                size: 14,
                                color: Color(0xFFE53935),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Body ──
              Expanded(child: _buildBody(context, provider)),

              // ── Create Button ──
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _showCreateSheet(context, provider),
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppStyle.primaryGradient,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Create Medicine',
                    style: AppStyle.text(
                      size: 15,
                      color: Colors.white,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, MedicineProvider provider) {
    switch (provider.state) {
      case MedicineLoadState.idle:
      case MedicineLoadState.loading:
        return const ShimmerList();

      case MedicineLoadState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                'Failed to load medicines',
                style: AppStyle.text(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: provider.fetchMedicines,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppStyle.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Retry',
                    style: AppStyle.text(
                      color: Colors.white,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      case MedicineLoadState.loaded:
        if (provider.medicines.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  size: 56,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 12),
                Text(
                  'No medicines yet',
                  style: AppStyle.text(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Medicines',
              style: AppStyle.text(
                size: 14,
                color: AppStyle.accentCyan,
                weight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child:
                  provider.isLoadingMore
                      ? const Center(
                        child: CircularProgressIndicator(
                          color: AppStyle.accentCyan,
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh: () => provider.fetchMedicines(refresh: true),
                        color: AppStyle.accentCyan,
                        child: ListView.separated(
                          itemCount: provider.medicines.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final med = provider.medicines[i];
                            return _MedicineCard(
                              medicine: med,
                              onEdit:
                                  () => _showEditSheet(context, provider, med),
                              onDelete:
                                  () => _confirmDelete(context, provider, med),
                            );
                          },
                        ),
                      ),
            ),
            if (!provider.isLoadingMore &&
                (provider.previousPageUrl != null ||
                    provider.nextPageUrl != null))
              _buildPaginationFooter(context, provider),
          ],
        );
    }
  }

  Widget _buildPaginationFooter(
    BuildContext context,
    MedicineProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _PaginationButton(
            label: 'Previous',
            icon: Icons.chevron_left_rounded,
            isNext: false,
            isEnabled: provider.previousPageUrl != null,
            onTap: () => provider.loadPreviousPage(),
          ),
          Text(
            'Page ${provider.currentPage}',
            style: AppStyle.text(size: 14, weight: FontWeight.w600),
          ),
          _PaginationButton(
            label: 'Next',
            icon: Icons.chevron_right_rounded,
            isNext: true,
            isEnabled: provider.nextPageUrl != null,
            onTap: () => provider.loadNextPage(),
          ),
        ],
      ),
    );
  }

  void _showCreateSheet(BuildContext context, MedicineProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => ChangeNotifierProvider.value(
            value: provider,
            child: const _MedicineFormSheet(),
          ),
    );
  }

  void _showEditSheet(
    BuildContext context,
    MedicineProvider provider,
    MedicineModel medicine,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => ChangeNotifierProvider.value(
            value: provider,
            child: _MedicineFormSheet(existing: medicine),
          ),
    );
  }

  void _showMemberSelectionSheet(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final members = homeProvider.liveStatus;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => SafeArea(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select Member',
                        style: AppStyle.text(size: 16, weight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const Divider(height: 20),
                  if (members.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'No members available',
                        style: AppStyle.text(color: AppStyle.hintColor),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          final member = members[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppStyle.accentCyan.withOpacity(
                                0.1,
                              ),
                              backgroundImage:
                                  member.profileImage != null
                                      ? NetworkImage(member.profileImage!)
                                      : null,
                              child:
                                  member.profileImage == null
                                      ? const Icon(
                                        Icons.person,
                                        color: AppStyle.accentCyan,
                                      )
                                      : null,
                            ),
                            title: Text(
                              member.name,
                              style: AppStyle.text(
                                size: 14,
                                weight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              member.branchName,
                              style: AppStyle.text(
                                size: 12,
                                color: AppStyle.hintColor,
                              ),
                            ),
                            onTap: () {
                              if (member.attendanceId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Member has not checked in (no attendance ID).',
                                    ),
                                    backgroundColor: Color(0xFFE53935),
                                  ),
                                );
                                return;
                              }
                              Navigator.pop(ctx);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => SelectedMedicinesScreen(
                                        attendanceId: member.attendanceId!,
                                      ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    MedicineProvider provider,
    MedicineModel medicine,
  ) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Delete Medicine',
              style: AppStyle.text(size: 16, weight: FontWeight.w700),
            ),
            content: Text(
              'Delete "${medicine.name}"? This cannot be undone.',
              style: AppStyle.text(size: 13, color: AppStyle.hintColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancel',
                  style: AppStyle.text(color: AppStyle.hintColor),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(ctx);
                  await provider.delete(id: medicine.id, context: context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Delete',
                    style: AppStyle.text(
                      color: Colors.white,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
    );
  }
}

// ─────────────────────────────────────────────
// PAGINATION BUTTON
// ─────────────────────────────────────────────
class _PaginationButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isNext;
  final bool isEnabled;
  final VoidCallback onTap;

  const _PaginationButton({
    required this.label,
    required this.icon,
    required this.isNext,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Opacity(
        opacity: isEnabled ? 1.0 : 0.4,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children:
                isNext
                    ? [
                      Text(
                        label,
                        style: AppStyle.text(size: 13, weight: FontWeight.w500),
                      ),
                      const SizedBox(width: 4),
                      Icon(icon, size: 16),
                    ]
                    : [
                      Icon(icon, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        label,
                        style: AppStyle.text(size: 13, weight: FontWeight.w500),
                      ),
                    ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// MEDICINE CARD
// ─────────────────────────────────────────────

class _MedicineCard extends StatelessWidget {
  final MedicineModel medicine;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MedicineCard({
    required this.medicine,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF00BCD4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.medical_services_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Name and Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        medicine.name,
                        style: AppStyle.text(size: 14, weight: FontWeight.w600),
                      ),
                    ),
                    if (medicine.isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Active',
                          style: AppStyle.text(
                            size: 10,
                            color: Colors.green.shade700,
                            weight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Inactive',
                          style: AppStyle.text(
                            size: 10,
                            color: Colors.red.shade700,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Code: ${medicine.code}',
                  style: AppStyle.text(size: 12, color: AppStyle.hintColor),
                ),
                const SizedBox(height: 4),
                Text(
                  medicine.description,
                  style: AppStyle.text(size: 12, color: AppStyle.hintColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Three-dot menu
          GestureDetector(
            onTap: () => _showMenu(context),
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.more_vert_rounded,
                size: 18,
                color: AppStyle.hintColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        medicine.name,
                        style: AppStyle.text(size: 15, weight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const Divider(height: 20),
                  ListTile(
                    leading: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: AppStyle.accentCyan,
                      ),
                    ),
                    title: Text(
                      'Edit',
                      style: AppStyle.text(size: 14, weight: FontWeight.w500),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      onEdit();
                    },
                  ),
                  ListTile(
                    leading: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: Color(0xFFE53935),
                      ),
                    ),
                    title: Text(
                      'Delete',
                      style: AppStyle.text(
                        size: 14,
                        color: const Color(0xFFE53935),
                        weight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      onDelete();
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
    );
  }
}

// ─────────────────────────────────────────────
// FORM SHEET — Create / Edit
// ─────────────────────────────────────────────

class _MedicineFormSheet extends StatefulWidget {
  final MedicineModel? existing;
  const _MedicineFormSheet({this.existing});

  @override
  State<_MedicineFormSheet> createState() => _MedicineFormSheetState();
}

class _MedicineFormSheetState extends State<_MedicineFormSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _descCtrl;
  bool _isActive = true;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _codeCtrl = TextEditingController(text: widget.existing?.code ?? '');
    _descCtrl = TextEditingController(text: widget.existing?.description ?? '');
    _isActive = widget.existing?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final code = _codeCtrl.text.trim();
    final desc = _descCtrl.text.trim();

    if (name.isEmpty || code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Name and Code are required'),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    final provider = context.read<MedicineProvider>();
    bool ok;

    if (_isEdit) {
      ok = await provider.update(
        id: widget.existing!.id,
        name: name,
        code: code,
        description: desc,
        isActive: _isActive,
        context: context,
      );
    } else {
      ok = await provider.create(
        name: name,
        code: code,
        description: desc,
        isActive: _isActive,
        context: context,
      );
    }

    if (ok && mounted) Navigator.maybePop(context);
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppStyle.text(size: 13, weight: FontWeight.w500),
            children: [
              if (label != 'Description')
                TextSpan(
                  text: ' *',
                  style: AppStyle.text(
                    size: 13,
                    color: const Color(0xFFE53935),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: AppStyle.text(size: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppStyle.text(size: 13, color: AppStyle.hintColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppStyle.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppStyle.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppStyle.accentCyan),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicineProvider>();
    final bottomPad =
        MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppStyle.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEdit ? 'Edit Medicine' : 'Create Medicine',
                  style: AppStyle.text(size: 18, weight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
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
                        const Icon(
                          Icons.close,
                          size: 14,
                          color: Color(0xFFE53935),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Form card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    'Medicine Name',
                    _nameCtrl,
                    'Enter Medicine Name',
                  ),
                  _buildTextField(
                    'Code',
                    _codeCtrl,
                    'Enter Medicine Code (e.g. MED001)',
                  ),
                  _buildTextField(
                    'Description',
                    _descCtrl,
                    'Enter Description',
                  ),

                  // Is Active switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Is Active',
                        style: AppStyle.text(size: 13, weight: FontWeight.w500),
                      ),
                      Switch(
                        value: _isActive,
                        onChanged: (val) => setState(() => _isActive = val),
                        activeColor: AppStyle.accentCyan,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Create button
                  GestureDetector(
                    onTap: provider.isSubmitting ? null : _submit,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: AppStyle.primaryGradient,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child:
                          provider.isSubmitting
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                _isEdit ? 'Save Changes' : 'Create',
                                style: AppStyle.text(
                                  size: 15,
                                  color: Colors.white,
                                  weight: FontWeight.w600,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
