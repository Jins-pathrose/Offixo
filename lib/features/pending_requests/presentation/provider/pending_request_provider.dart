// lib/features/pending_requests/presentation/provider/pending_request_provider.dart

import 'package:flutter/material.dart';
import 'package:offixoadmin/features/pending_requests/data/models/pending_request_model.dart';
import 'package:offixoadmin/features/pending_requests/domain/pending_request_repository.dart';

enum PendingRequestState { idle, loading, loaded, error }

class PendingRequestProvider extends ChangeNotifier {
  final PendingRequestRepository _repository = PendingRequestRepository();

  List<PendingRequestModel> _pendingRequests = [];
  PendingRequestState state = PendingRequestState.idle;
  String errorMessage = '';

  int totalCount = 0;
  int pendingCount = 0;
  String? nextUrl;
  String? previousUrl;

  bool isNextLoading = false;
  bool isActionLoading = false;
  
  String currentStatus = 'pending';

  List<PendingRequestModel> get pendingRequests => _pendingRequests;

  void setStatus(String status) {
    if (currentStatus == status) return;
    currentStatus = status;
    fetchPendingRequests(isRefresh: true);
  }

  Future<void> fetchPendingRequests({bool isRefresh = false, bool loadMore = false}) async {
    if (isRefresh) {
      nextUrl = null;
      _pendingRequests.clear();
      state = PendingRequestState.loading;
      notifyListeners();
    } else if (loadMore) {
      if (nextUrl == null || isNextLoading) return;
      isNextLoading = true;
      notifyListeners();
    } else if (_pendingRequests.isEmpty) {
      state = PendingRequestState.loading;
      notifyListeners();
    } else {
      return;
    }

    try {
      final response = await _repository.fetchPendingRequests(
        url: loadMore ? nextUrl : null,
        status: loadMore ? null : currentStatus,
      );
      
      if (loadMore) {
        _pendingRequests.addAll(response.results);
      } else {
        _pendingRequests = response.results;
      }
      
      totalCount = response.count;
      if (!loadMore && currentStatus == 'pending') {
        pendingCount = response.count;
      }
      nextUrl = response.next;
      state = PendingRequestState.loaded;
    } catch (e) {
      if (!loadMore) {
        errorMessage = e.toString().replaceAll('Exception:', '').trim();
        state = PendingRequestState.error;
      } else {
        errorMessage = e.toString().replaceAll('Exception:', '').trim();
        rethrow;
      }
    } finally {
      if (loadMore) {
        isNextLoading = false;
      }
      notifyListeners();
    }
  }

  Future<void> fetchNextPage(BuildContext context) async {
    if (nextUrl == null || isNextLoading) return;
    try {
      await fetchPendingRequests(loadMore: true);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load next page')),
        );
      }
    }
  }

  Future<PendingRequestModel?> fetchRequestDetails(int id, BuildContext context) async {
    try {
      return await _repository.fetchPendingRequestDetails(id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception:', '').trim())),
        );
      }
      return null;
    }
  }

  Future<bool> performAction(int id, String action, BuildContext context) async {
    if (isActionLoading) return false;
    isActionLoading = true;
    notifyListeners();

    try {
      final success = await _repository.performAction(id, action);
      if (success) {
        // Remove from list
        _pendingRequests.removeWhere((req) => req.id == id);
        totalCount = totalCount > 0 ? totalCount - 1 : 0;
        pendingCount = pendingCount > 0 ? pendingCount - 1 : 0;
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Request ${action == "approve" ? "approved" : "rejected"} successfully')),
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Action Failed", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            content: Text(e.toString().replaceAll('Exception:', '').trim()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
      return false;
    } finally {
      isActionLoading = false;
      notifyListeners();
    }
  }
}
