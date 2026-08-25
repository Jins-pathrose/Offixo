import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/settings/presentation/provider/resigned_members_provider.dart';

class ResignedMembersScreen extends StatelessWidget {
  const ResignedMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResignedMembersProvider()..fetchResignedMembers(),
      child: const _ResignedMembersView(),
    );
  }
}

class _ResignedMembersView extends StatelessWidget {
  const _ResignedMembersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Resigned Employees',
          style: AppStyle.text(size: 18, weight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<ResignedMembersProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppStyle.accentCyan),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading data',
                    style: AppStyle.text(size: 16, weight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: AppStyle.text(size: 14, color: Colors.grey[600]!),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchResignedMembers(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.accentCyan,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.members.isEmpty) {
            return Center(
              child: Text(
                'No resigned employees found.',
                style: AppStyle.text(size: 16, color: Colors.grey[600]!),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchResignedMembers(),
            color: AppStyle.accentCyan,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.members.length,
              itemBuilder: (context, index) {
                final member = provider.members[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppStyle.accentCyan.withOpacity(0.1),
                        child: Text(
                          member.name.isNotEmpty
                              ? member.name.substring(0, 1).toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: AppStyle.accentCyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.name,
                              style: AppStyle.text(
                                size: 16,
                                weight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${member.empNo} • ${member.designation}',
                              style: AppStyle.text(
                                size: 13,
                                color: Colors.grey[600]!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
