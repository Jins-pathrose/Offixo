import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/branch/data/model/branchmodel.dart';
import 'package:offixoadmin/features/branch/presentation/provider/branchprovider.dart';
import 'package:offixoadmin/features/branch/presentation/screens/createbranchscreen.dart';
import 'package:offixoadmin/features/branch/presentation/widgets/branchdetailssheet.dart';
import 'package:offixoadmin/features/branch/presentation/widgets/createbranchbutton.dart';
import 'package:provider/provider.dart';

class BranchesScreen extends StatelessWidget {
  const BranchesScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BranchProvider()..loadBranches(),
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
                    context.read<BranchProvider>().loadBranches();
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
        return const Center(
            child: CircularProgressIndicator(color: AppStyle.accentCyan));
 
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
                onTap: provider.loadBranches,
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
              child: RefreshIndicator(
                onRefresh: provider.loadBranches,
                color: AppStyle.accentCyan,
                child: ListView.separated(
                  itemCount: provider.branches.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final branch = provider.branches[index];
                    return _BranchCard(
                      branch: branch,
                      onTap: () => _showBranchDetails(context, branch),
                      onMenuTap: () => _showBranchDetails(context, branch),
                    );
                  },
                ),
              ),
            ),
          ],
        );
    }
  }
 
  void _showBranchDetails(BuildContext context, BranchModel branch) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BranchDetailsSheet(branch: branch),
    );
  }
}
 
// ─────────────────────────────────────────────
// BRANCH CARD
// ─────────────────────────────────────────────
class _BranchCard extends StatelessWidget {
  final BranchModel branch;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;
 
  const _BranchCard({
    required this.branch,
    required this.onTap,
    required this.onMenuTap,
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
              onTap: onMenuTap,
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
}