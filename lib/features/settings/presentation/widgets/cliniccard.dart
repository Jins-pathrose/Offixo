import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/settings/presentation/provider/maintainerprofileprovider.dart';
import 'package:offixoadmin/features/settings/presentation/widgets/maintainerprofile.dart';
import 'package:provider/provider.dart';

class ClinicCard extends StatelessWidget {
  const ClinicCard();

  void _showProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) => const MaintainerProfileSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Read from the provider already in the tree (SettingsScreen provides it)
    final provider = context.watch<MaintainerProfileProvider>();
    final orgName = provider.profile?.organization.name ?? '';

    return GestureDetector(
      onTap: () => _showProfile(context),
      child: Container(
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
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.2),
              ),
              clipBehavior: Clip.antiAlias,
              child: const Icon(Icons.business_outlined,
                  color: Colors.white, size: 32),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Premium Plan',
                        style: AppStyle.text(
                            size: 11,
                            color: Colors.white,
                            weight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 6),

                  // ← org name from API
                  Text(
                    orgName.isNotEmpty ? orgName : '...',
                    style: AppStyle.text(
                        size: 18,
                        color: Colors.white,
                        weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text('Plan Expire on 15.02.2030',
                      style: AppStyle.text(
                          size: 12,
                          color: Colors.white.withOpacity(0.85))),
                ],
              ),
            ),

            Icon(Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.8), size: 20),
          ],
        ),
      ),
    );
  }
}