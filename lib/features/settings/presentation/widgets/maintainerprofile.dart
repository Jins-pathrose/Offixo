import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/settings/domain/enumprofile.dart';
import 'package:offixoadmin/features/settings/presentation/provider/maintainerprofileprovider.dart';
import 'package:provider/provider.dart';

class MaintainerProfileSheet extends StatelessWidget {
  const MaintainerProfileSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MaintainerProfileProvider(),
      child: const _ProfileSheetView(),
    );
  }
}

class _ProfileSheetView extends StatelessWidget {
  const _ProfileSheetView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MaintainerProfileProvider>();
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppStyle.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 12),
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
          const SizedBox(height: 4),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPad + 20),
              child: _buildContent(context, provider),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, MaintainerProfileProvider provider) {
    switch (provider.state) {
      case ProfileLoadState.idle:
      case ProfileLoadState.loading:
        return const SizedBox(
          height: 200,
          child: Center(
              child: CircularProgressIndicator(color: AppStyle.accentCyan)),
        );

      case ProfileLoadState.error:
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.wifi_off_rounded,
                    size: 40, color: Colors.grey),
                const SizedBox(height: 10),
                Text(provider.error ?? 'Something went wrong',
                    style: AppStyle.text(color: Colors.grey)),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: provider.fetchProfile,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
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
          ),
        );

      case ProfileLoadState.loaded:
        final p = provider.profile!;
        final org = p.organization;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Header Card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BCD4), Color(0xFF26C6DA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
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
                      color: Colors.white.withOpacity(0.3),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: p.imageUrl.isNotEmpty
                        ? Image.network(
                            p.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 36),
                          )
                        : const Icon(Icons.person,
                            color: Colors.white, size: 36),
                  ),
                  const SizedBox(width: 14),

                  // Name + email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.maintainerName,
                            style: AppStyle.text(
                                size: 18,
                                color: Colors.white,
                                weight: FontWeight.w700)),
                        const SizedBox(height: 3),
                        Text(p.email,
                            style: AppStyle.text(
                                size: 12,
                                color: Colors.white.withOpacity(0.9))),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Personal Info ──
            _SectionCard(
              icon: Icons.person_outline_rounded,
              title: 'Personal Info',
              children: [
                _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: p.phone.isNotEmpty ? p.phone : '--'),
                _InfoRow(
                    icon: Icons.home_outlined,
                    label: 'Address',
                    value: p.address.isNotEmpty ? p.address : '--',
                    isLast: true),
              ],
            ),

            const SizedBox(height: 16),

            // ── Organization Info ──
            _SectionCard(
              icon: Icons.business_outlined,
              title: 'Organization',
              children: [
                _InfoRow(
                    icon: Icons.badge_outlined,
                    label: 'Name',
                    value: org.name),
                _InfoRow(
                    icon: Icons.category_outlined,
                    label: 'Type',
                    value: org.organizationType),
                _InfoRow(
                    icon: Icons.person_outlined,
                    label: 'Owner',
                    value: org.organizationOwner),
                _InfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'Address',
                    value: org.organizationAddress),
                _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: org.organizationPhone.isNotEmpty
                        ? org.organizationPhone
                        : '--',
                    isLast: true),
              ],
            ),

            const SizedBox(height: 24),

            // ── Close button ──
            GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppStyle.primaryGradient,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text('Close',
                    style: AppStyle.text(
                        size: 16,
                        color: Colors.white,
                        weight: FontWeight.w600)),
              ),
            ),
          ],
        );
    }
  }
}

// ─────────────────────────────────────────────
// SECTION CARD
// ─────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, size: 18, color: AppStyle.accentCyan),
            const SizedBox(width: 8),
            Text(title,
                style:
                    AppStyle.text(size: 14, weight: FontWeight.w700)),
          ]),
          const Divider(height: 20),
          ...children,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// INFO ROW
// ─────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 16, color: AppStyle.hintColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: AppStyle.text(
                            size: 11, color: AppStyle.accentCyan)),
                    const SizedBox(height: 3),
                    Text(value,
                        style: AppStyle.text(
                            size: 14, weight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, thickness: 0.5, indent: 28),
      ],
    );
  }
}