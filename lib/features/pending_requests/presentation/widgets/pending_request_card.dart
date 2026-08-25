// lib/features/pending_requests/presentation/widgets/pending_request_card.dart

import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/pending_requests/data/models/pending_request_model.dart';

class PendingRequestCard extends StatelessWidget {
  final PendingRequestModel request;
  final VoidCallback onTap;

  const PendingRequestCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipOval(
              child:
                  request.faceImage1 != null && request.faceImage1!.isNotEmpty
                      ? Image.network(
                        request.faceImage1!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) => _buildPlaceholder(),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return _buildPlaceholder();
                        },
                      )
                      : _buildPlaceholder(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.fullName,
                    style: AppStyle.text(size: 16, weight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${request.memberType} • ${request.empNo}',
                    style: AppStyle.text(color: AppStyle.hintColor, size: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    request.email,
                    style: AppStyle.text(color: AppStyle.hintColor, size: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            //   decoration: BoxDecoration(
            //     color: Colors.orange.shade50,
            //     borderRadius: BorderRadius.circular(20),
            //     border: Border.all(color: Colors.orange.shade200),
            //   ),
            //   child: Text(
            //     'Pending',
            //     style: AppStyle.text(color: Colors.orange.shade700, size: 12, weight: FontWeight.w600),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey[200],
      child: Center(
        child: Text(
          _getInitials(request.fullName),
          style: AppStyle.text(
            size: 20,
            weight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }
}
