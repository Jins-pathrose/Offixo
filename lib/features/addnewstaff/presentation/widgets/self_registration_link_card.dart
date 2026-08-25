import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/provider/addstaffprovider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SelfRegistrationLinkCard extends StatelessWidget {
  const SelfRegistrationLinkCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddStaffProvider>();

    if (provider.isEditMode) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Self Registration Link',
          style: AppStyle.text(size: 16, weight: FontWeight.w600, color: AppStyle.primaryColor),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildContent(context, provider),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildContent(BuildContext context, AddStaffProvider provider) {
    if (provider.isLinkLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (provider.linkErrorMsg.isNotEmpty) {
      return Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 32),
          const SizedBox(height: 8),
          Text(provider.linkErrorMsg, style: AppStyle.text(color: Colors.red)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => provider.fetchRegistrationLink(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppStyle.primaryColor,
              side: BorderSide(color: AppStyle.primaryColor),
            ),
            child: const Text('Retry'),
          ),
        ],
      );
    }

    if (provider.registrationLink.isEmpty) {
      return const Center(child: Text('No link available'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (provider.orgName.isNotEmpty) ...[
          Text(
            provider.orgName,
            style: AppStyle.text(size: 14, weight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  provider.registrationLink,
                  style: AppStyle.text(size: 13, color: Colors.blue.shade700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () async {
                  String link = provider.registrationLink;
                  if (!link.startsWith('http://') && !link.startsWith('https://')) {
                    link = 'https://$link';
                  }
                  final url = Uri.parse(link);
                  try {
                    final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
                    if (!launched && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not open link')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Could not open link')),
                      );
                    }
                  }
                },
                child: const Icon(Icons.open_in_new, size: 20, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: provider.registrationLink));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registration link copied')),
                  );
                },
                icon: const Icon(Icons.copy, size: 18),
                label: const Text('Copy'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Share.share(provider.registrationLink, subject: 'Staff Registration Link');
                },
                icon: const Icon(Icons.share, size: 18),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
