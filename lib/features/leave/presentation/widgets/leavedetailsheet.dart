import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/leave/data/model/leaverequestmodel.dart';
import 'package:offixoadmin/features/leave/presentation/provider/leaverequestprovider.dart';
import 'package:offixoadmin/features/leave/presentation/widgets/detailcolum.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LeaveDetailSheet extends StatelessWidget {
  final LeaveRequestModel leave;
  const LeaveDetailSheet({required this.leave});
 
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LeaveRequestProvider>();
    final bottomPad = MediaQuery.of(context).padding.bottom;
 
    return Container(
      decoration: const BoxDecoration(
        color: AppStyle.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPad + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
 
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Leave Details',
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
                  child: Row(children: [
                    Text('Close',
                        style: AppStyle.text(
                            size: 13,
                            color: const Color(0xFFE53935),
                            weight: FontWeight.w500)),
                    const SizedBox(width: 4),
                    const Icon(Icons.close,
                        size: 14, color: Color(0xFFE53935)),
                  ]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
 
          // Detail card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Member row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(leave.memberName,
                              style: AppStyle.text(
                                  size: 16, weight: FontWeight.w700)),
                          const SizedBox(height: 3),
                          Text(
                            '${leave.leaveTypeName} • ${leave.memberEmpNo}',
                            style: AppStyle.text(
                                size: 12, color: AppStyle.hintColor),
                          ),
                        ],
                      ),
                    ),
                    // Initial avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        leave.memberName.isNotEmpty
                            ? leave.memberName[0].toUpperCase()
                            : '?',
                        style: AppStyle.text(
                            size: 20,
                            color: AppStyle.accentCyan,
                            weight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
 
                // Date / Session / Status row
                Row(
                  children: [
                    Expanded(
                      child: DetailCol(
                        label: 'From Date',
                        value: leave.fromDateFormatted,
                      ),
                    ),
                    Expanded(
                      child: DetailCol(
                        label: 'To Date',
                        value: leave.toDateFormatted,
                      ),
                    ),
                    Expanded(
                      child: DetailCol(
                        label: 'Days',
                        value: leave.numberOfDays,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
 
                Row(
                  children: [
                    Expanded(
                      child: DetailCol(
                        label: 'Session',
                        value: leave.sessionLabel,
                      ),
                    ),
                    Expanded(
                      child: DetailCol(
                        label: 'Status',
                        value: leave.status,
                        valueColor: _statusColor(leave.status),
                      ),
                    ),
                    Expanded(
                      child: DetailCol(
                        label: 'Applied',
                        value: leave.appliedDateFormatted,
                      ),
                    ),
                  ],
                ),
 
                if (leave.reason.isNotEmpty) ...[
                  const Divider(height: 20),
                  Text('Reason',
                      style: AppStyle.text(
                          size: 11, color: AppStyle.accentCyan)),
                  const SizedBox(height: 4),
                  Text(leave.reason,
                      style: AppStyle.text(size: 13)),
                ],
 
                if (leave.rejectionReason != null &&
                    leave.rejectionReason!.isNotEmpty) ...[
                  const Divider(height: 20),
                  Text('Rejection Reason',
                      style: AppStyle.text(
                          size: 11, color: const Color(0xFFE53935))),
                  const SizedBox(height: 4),
                  Text(leave.rejectionReason!,
                      style: AppStyle.text(size: 13)),
                ],

                if (leave.medicalCertificateUrl != null &&
                    leave.medicalCertificateUrl!.isNotEmpty) ...[
                  const Divider(height: 20),
                  Text('Document Attached',
                      style: AppStyle.text(
                          size: 11, color: AppStyle.accentCyan)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final url = Uri.parse(leave.medicalCertificateUrl!);
                      try {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } catch (e) {
                        debugPrint('Could not launch url: $e');
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppStyle.accentCyan.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppStyle.accentCyan.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.description_outlined, size: 16, color: AppStyle.accentCyan),
                          const SizedBox(width: 8),
                          Text('View Medical Certificate',
                              style: AppStyle.text(size: 13, color: AppStyle.accentCyan, weight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
 
          const SizedBox(height: 16),
 
          // Approve / Reject buttons — only for pending
          if (leave.isPending)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showApproveDialog(context, provider),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text('Approve',
                          style: AppStyle.text(
                              size: 15,
                              color: Colors.white,
                              weight: FontWeight.w600)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showRejectDialog(context, provider),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text('Reject',
                          style: AppStyle.text(
                              size: 15,
                              color: Colors.white,
                              weight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
 
  Color _statusColor(String status) {
    switch (status) {
      case 'APPROVED': return const Color(0xFF22C55E);
      case 'REJECTED': return const Color(0xFFE53935);
      default: return const Color(0xFFFF9800);
    }
  }
 
  void _showRejectDialog(
      BuildContext context, LeaveRequestProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text('Reject Leave',
            style: AppStyle.text(size: 16, weight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Please provide a reason for rejection:',
                style: AppStyle.text(
                    size: 13, color: AppStyle.hintColor)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter rejection reason...',
                hintStyle: AppStyle.text(
                    size: 13, color: AppStyle.hintColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: AppStyle.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppStyle.accentCyan),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text('Cancel',
                style: AppStyle.text(
                    size: 14, color: AppStyle.hintColor)),
          ),
          GestureDetector(
            onTap: () {
              if (controller.text.trim().isEmpty) return;
              Navigator.pop(dialogCtx);
              _runWithLoader(context, () => provider.reject(
                requestId: leave.id,
                rejectionReason: controller.text.trim(),
                context: context,
              ));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE53935),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Reject',
                  style: AppStyle.text(
                      color: Colors.white,
                      weight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  void _showApproveDialog(
      BuildContext context, LeaveRequestProvider provider) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text('Approve Leave',
            style: AppStyle.text(size: 16, weight: FontWeight.w700)),
        content: Text('Are you sure you want to approve this leave request?',
            style: AppStyle.text(size: 14, color: AppStyle.hintColor)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: Text('Cancel',
                style: AppStyle.text(
                    size: 14, color: AppStyle.hintColor)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(dialogCtx);
              _runWithLoader(context, () => provider.approve(leave.id, context));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Approve',
                  style: AppStyle.text(
                      color: Colors.white,
                      weight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _runWithLoader(BuildContext context, Future<bool> Function() action) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator(color: AppStyle.accentCyan)),
    );
    final ok = await action();
    if (context.mounted) {
      Navigator.pop(context); // Close the loader
      if (ok) {
        Navigator.maybePop(context); // Close the sheet
      }
    }
  }
}