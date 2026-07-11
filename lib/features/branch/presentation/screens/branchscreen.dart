import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/branch/data/model/branchmodel.dart';
import 'package:offixoadmin/features/branch/presentation/provider/branchprovider.dart';
import 'package:offixoadmin/features/branch/presentation/screens/createbranchscreen.dart';
import 'package:offixoadmin/features/branch/presentation/widgets/branchdetailssheet.dart';
import 'package:offixoadmin/features/branch/presentation/widgets/createbranchbutton.dart';
import 'package:provider/provider.dart';
import 'package:offixoadmin/common/shimmer/shimmer_list.dart';
class BranchesScreen extends StatelessWidget {
  const BranchesScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BranchProvider()..fetchBranches(),
      child: const _BranchesView(),
    );
  }
}
 
class _BranchesView extends StatelessWidget {
  const _BranchesView();
 
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BranchProvider>();
 
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
                  Text('Branches',
                      style:
                          AppStyle.text(size: 20, weight: FontWeight.w700)),
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: const Color(0xFFFFCDD2)),
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
 
              // ── Create Branch Button ──
              CreateBranchButton(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CreateBranchScreen()),
                  );
                  // Refresh list after creation
                  if (context.mounted) {
                    context.read<BranchProvider>().refreshBranches();
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _buildBody(BuildContext context, BranchProvider provider) {
    switch (provider.state) {
      case BranchLoadState.idle:
      case BranchLoadState.loading:
        return const ShimmerList();
 
      case BranchLoadState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text('Failed to load branches',
                  style: AppStyle.text(color: Colors.grey)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: provider.fetchBranches,
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
 
      case BranchLoadState.loaded:
        if (provider.branches.isEmpty) {
          return Center(
            child: Text('No branches found',
                style: AppStyle.text(color: Colors.grey)),
          );
        }
 
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('All Branches',
                style: AppStyle.text(
                    size: 15,
                    color: AppStyle.accentCyan,
                    weight: FontWeight.w700)),
            const SizedBox(height: 12),
 
            Expanded(
              child: provider.isLoadingMore
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppStyle.accentCyan,
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: provider.refreshBranches,
                      color: AppStyle.accentCyan,
                      child: ListView.separated(
                        itemCount: provider.branches.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final branch = provider.branches[index];
                          return _BranchCard(
                            branch: branch,
                            onTap: () => _showBranchDetails(context, branch),
                            onEdit: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CreateBranchScreen(existing: branch),
                                ),
                              );
                              if (context.mounted) {
                                context.read<BranchProvider>().refreshBranches();
                              }
                            },
                            onDelete: () => _confirmDelete(context, provider, branch),
                          );
                        },
                      ),
                    ),
            ),
            if (!provider.isLoadingMore && (provider.previousPageUrl != null || provider.nextPageUrl != null))
              _buildPaginationFooter(context, provider),
          ],
        );
    }
  }

  Widget _buildPaginationFooter(BuildContext context, BranchProvider provider) {
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

  void _showBranchDetails(BuildContext context, BranchModel branch) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BranchDetailsSheet(branch: branch),
    );
  }

  void _confirmDelete(BuildContext context, BranchProvider provider,
      BranchModel branch) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Branch',
            style: AppStyle.text(size: 16, weight: FontWeight.w700)),
        content: Text(
          'Delete "${branch.name}"? This cannot be undone.',
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
              await provider.deleteBranch(
                  id: branch.id, context: context);
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
            children: isNext
                ? [
                    Text(label, style: AppStyle.text(size: 13, weight: FontWeight.w500)),
                    const SizedBox(width: 4),
                    Icon(icon, size: 16),
                  ]
                : [
                    Icon(icon, size: 16),
                    const SizedBox(width: 4),
                    Text(label, style: AppStyle.text(size: 13, weight: FontWeight.w500)),
                  ],
          ),
        ),
      ),
    );
  }
}

 
// ─────────────────────────────────────────────
// BRANCH CARD
// ─────────────────────────────────────────────
class _BranchCard extends StatelessWidget {
  final BranchModel branch;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
 
  const _BranchCard({
    required this.branch,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
              child: const Icon(Icons.account_tree_outlined,
                  color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
 
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(branch.name,
                      style: AppStyle.text(
                          size: 14, weight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(
                    branch.address,
                    style: AppStyle.text(
                        size: 12, color: AppStyle.hintColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
 
            // Menu
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
                  child: Text(branch.name,
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