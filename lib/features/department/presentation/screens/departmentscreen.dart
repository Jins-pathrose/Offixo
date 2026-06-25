import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/department/data/model/departmentmodel.dart';
import 'package:offixoadmin/features/department/presentation/provider/departmentprovider.dart';
import 'package:provider/provider.dart';

class DepartmentsScreen extends StatelessWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DepartmentProvider(),
      child: const _DepartmentsView(),
    );
  }
}

class _DepartmentsView extends StatelessWidget {
  const _DepartmentsView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DepartmentProvider>();

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
                  Text('Departments',
                      style: AppStyle.text(
                          size: 20, weight: FontWeight.w700)),
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFFFFCDD2)),
                      ),
                      child: Row(
                        children: [
                          Text('Close',
                              style: AppStyle.text(
                                  size: 13,
                                  color: const Color(0xFFE53935),
                                  weight: FontWeight.w500)),
                          const SizedBox(width: 4),
                          const Icon(Icons.close,
                              size: 14, color: Color(0xFFE53935)),
                        ],
                      ),
                    ),
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
                  child: Text('Create Department',
                      style: AppStyle.text(
                          size: 15,
                          color: Colors.white,
                          weight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, DepartmentProvider provider) {
    switch (provider.state) {
      case DeptLoadState.idle:
      case DeptLoadState.loading:
        return const Center(
            child: CircularProgressIndicator(color: AppStyle.accentCyan));

      case DeptLoadState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text('Failed to load departments',
                  style: AppStyle.text(color: Colors.grey)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: provider.fetchDepartments,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: AppStyle.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Retry',
                      style: AppStyle.text(
                          color: Colors.white,
                          weight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );

      case DeptLoadState.loaded:
        if (provider.departments.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.domain_outlined,
                    size: 56, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Text('No departments yet',
                    style: AppStyle.text(color: Colors.grey)),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('All Departments',
                style: AppStyle.text(
                    size: 14,
                    color: AppStyle.accentCyan,
                    weight: FontWeight.w700)),
            const SizedBox(height: 12),
            Expanded(
              child: RefreshIndicator(
                onRefresh: provider.fetchDepartments,
                color: AppStyle.accentCyan,
                child: ListView.separated(
                  itemCount: provider.departments.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final dept = provider.departments[i];
                    return _DepartmentCard(
                      department: dept,
                      onEdit: () =>
                          _showEditSheet(context, provider, dept),
                      onDelete: () =>
                          _confirmDelete(context, provider, dept),
                    );
                  },
                ),
              ),
            ),
          ],
        );
    }
  }

  void _showCreateSheet(
      BuildContext context, DepartmentProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: const _DeptFormSheet(),
      ),
    );
  }

  void _showEditSheet(BuildContext context, DepartmentProvider provider,
      DepartmentModel dept) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: provider,
        child: _DeptFormSheet(existing: dept),
      ),
    );
  }

  void _confirmDelete(BuildContext context, DepartmentProvider provider,
      DepartmentModel dept) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Department',
            style: AppStyle.text(size: 16, weight: FontWeight.w700)),
        content: Text(
          'Delete "${dept.name}"? This cannot be undone.',
          style: AppStyle.text(size: 13, color: AppStyle.hintColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: AppStyle.text(color: AppStyle.hintColor)),
          ),
          GestureDetector(
            onTap: () async {
              Navigator.pop(ctx);
              await provider.delete(
                  id: dept.id, context: context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Delete',
                  style: AppStyle.text(
                      color: Colors.white,
                      weight: FontWeight.w600)),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DEPARTMENT CARD
// ─────────────────────────────────────────────

class _DepartmentCard extends StatelessWidget {
  final DepartmentModel department;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DepartmentCard({
    required this.department,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF00BCD4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.people_outline_rounded,
                color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),

          // Name
          Expanded(
            child: Text(department.name,
                style: AppStyle.text(
                    size: 14, weight: FontWeight.w600)),
          ),

          // Three-dot menu
          GestureDetector(
            onTap: () => _showMenu(context),
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.more_vert_rounded,
                  size: 18, color: AppStyle.hintColor),
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
      builder: (ctx) => SafeArea(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(department.name,
                      style: AppStyle.text(
                          size: 15, weight: FontWeight.w700)),
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
                  child: const Icon(Icons.edit_outlined,
                      size: 18, color: AppStyle.accentCyan),
                ),
                title: Text('Edit',
                    style: AppStyle.text(
                        size: 14, weight: FontWeight.w500)),
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
                  child: const Icon(Icons.delete_outline_rounded,
                      size: 18, color: Color(0xFFE53935)),
                ),
                title: Text('Delete',
                    style: AppStyle.text(
                        size: 14,
                        color: const Color(0xFFE53935),
                        weight: FontWeight.w500)),
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

class _DeptFormSheet extends StatefulWidget {
  final DepartmentModel? existing;
  const _DeptFormSheet({this.existing});

  @override
  State<_DeptFormSheet> createState() => _DeptFormSheetState();
}

class _DeptFormSheetState extends State<_DeptFormSheet> {
  late final TextEditingController _nameCtrl;
  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl =
        TextEditingController(text: widget.existing?.name ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Department name is required'),
        backgroundColor: const Color(0xFFE53935),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ));
      return;
    }

    final provider = context.read<DepartmentProvider>();
    bool ok;

    if (_isEdit) {
      ok = await provider.update(
          id: widget.existing!.id, name: name, context: context);
    } else {
      ok = await provider.create(name: name, context: context);
    }

    if (ok && mounted) Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DepartmentProvider>();
    final bottomPad = MediaQuery.of(context).viewInsets.bottom +
        MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppStyle.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPad + 20),
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
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),

          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  _isEdit
                      ? 'Edit Department'
                      : 'Create Department',
                  style: AppStyle.text(
                      size: 18, weight: FontWeight.w700)),
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFFFFCDD2)),
                  ),
                  child: Row(
                    children: [
                      Text('Close',
                          style: AppStyle.text(
                              size: 13,
                              color: const Color(0xFFE53935),
                              weight: FontWeight.w500)),
                      const SizedBox(width: 4),
                      const Icon(Icons.close,
                          size: 14,
                          color: Color(0xFFE53935)),
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
                // Label
                RichText(
                  text: TextSpan(
                    text: 'Department Name',
                    style: AppStyle.text(
                        size: 13, weight: FontWeight.w500),
                    children: [
                      TextSpan(
                          text: ' *',
                          style: AppStyle.text(
                              size: 13,
                              color: const Color(0xFFE53935))),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Text field
                TextField(
                  controller: _nameCtrl,
                  autofocus: true,
                  style: AppStyle.text(size: 13),
                  decoration: InputDecoration(
                    hintText: 'Enter Department Name',
                    hintStyle: AppStyle.text(
                        size: 13, color: AppStyle.hintColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: AppStyle.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: AppStyle.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: AppStyle.accentCyan),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                  ),
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
                    child: provider.isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5),
                          )
                        : Text(
                            _isEdit ? 'Save Changes' : 'Create',
                            style: AppStyle.text(
                                size: 15,
                                color: Colors.white,
                                weight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}