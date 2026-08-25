// lib/features/pending_requests/presentation/screens/pending_requests_screen.dart

import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/pending_requests/presentation/provider/pending_request_provider.dart';
import 'package:offixoadmin/features/pending_requests/presentation/widgets/pending_request_card.dart';
import 'package:offixoadmin/features/pending_requests/presentation/screens/pending_request_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:offixoadmin/common/shimmer/shimmer_list.dart';

class PendingRequestsScreen extends StatefulWidget {
  const PendingRequestsScreen({super.key});

  @override
  State<PendingRequestsScreen> createState() => _PendingRequestsScreenState();
}

class _PendingRequestsScreenState extends State<PendingRequestsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PendingRequestProvider>().fetchPendingRequests();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final provider = context.read<PendingRequestProvider>();
      if (!provider.isNextLoading) {
        provider.fetchNextPage(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PendingRequestProvider>();

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Header
              Text(
                "Pending Requests",
                style: AppStyle.text(size: 20, weight: FontWeight.w600),
              ),
              const SizedBox(height: 15),

              // Status Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStatusChip(context, provider, 'pending', 'Pending'),
                    const SizedBox(width: 10),
                    _buildStatusChip(context, provider, 'Approved', 'Approved'),
                    const SizedBox(width: 10),
                    _buildStatusChip(context, provider, 'Rejected', 'Rejected'),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Title + Count
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    provider.currentStatus == 'pending'
                        ? "Pending Requests"
                        : provider.currentStatus == 'Approved'
                            ? "Approved Requests"
                            : "Rejected Requests",
                    style: AppStyle.text(size: 17, weight: FontWeight.w500),
                  ),
                  if (provider.state == PendingRequestState.loaded)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: AppStyle.primaryGradient,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "${provider.totalCount} ${provider.currentStatus == 'pending' ? 'Pending' : provider.currentStatus == 'Approved' ? 'Approved' : 'Rejected'}",
                        style: AppStyle.text(color: Colors.white, size: 13),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 15),

              // Body
              Expanded(child: _buildBody(provider)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(PendingRequestProvider provider) {
    switch (provider.state) {
      case PendingRequestState.loading:
      case PendingRequestState.idle:
        return const ShimmerList(itemCount: 6, padding: EdgeInsets.zero);

      case PendingRequestState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                provider.errorMessage.isNotEmpty ? provider.errorMessage : 'Failed to load requests',
                style: AppStyle.text(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => provider.fetchPendingRequests(isRefresh: true),
                child: const Text("Retry"),
              )
            ],
          ),
        );

      case PendingRequestState.loaded:
        if (provider.pendingRequests.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => provider.fetchPendingRequests(isRefresh: true),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No pending requests found',
                      style: AppStyle.text(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.fetchPendingRequests(isRefresh: true),
          child: ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: provider.pendingRequests.length + (provider.isNextLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= provider.pendingRequests.length) {
                return const Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: ShimmerListItem(),
                );
              }

              final request = provider.pendingRequests[index];
              return PendingRequestCard(
                request: request,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PendingRequestDetailsScreen(requestId: request.id),
                    ),
                  );
                },
              );
            },
          ),
        );
    }
  }

  Widget _buildStatusChip(BuildContext context, PendingRequestProvider provider, String status, String label) {
    final isSelected = provider.currentStatus == status;
    return GestureDetector(
      onTap: () => provider.setStatus(status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppStyle.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppStyle.primaryColor : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: AppStyle.text(
            color: isSelected ? Colors.white : Colors.black87,
            weight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
