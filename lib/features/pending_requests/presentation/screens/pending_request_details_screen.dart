// lib/features/pending_requests/presentation/screens/pending_request_details_screen.dart

import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/pending_requests/data/models/pending_request_model.dart';
import 'package:offixoadmin/features/pending_requests/presentation/provider/pending_request_provider.dart';
import 'package:provider/provider.dart';

class PendingRequestDetailsScreen extends StatefulWidget {
  final int requestId;

  const PendingRequestDetailsScreen({super.key, required this.requestId});

  @override
  State<PendingRequestDetailsScreen> createState() => _PendingRequestDetailsScreenState();
}

class _PendingRequestDetailsScreenState extends State<PendingRequestDetailsScreen> {
  PendingRequestModel? _requestDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final provider = context.read<PendingRequestProvider>();
    final details = await provider.fetchRequestDetails(widget.requestId, context);
    if (mounted) {
      setState(() {
        _requestDetails = details;
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmAndPerformAction(String action, String title, Color color) async {
    final provider = context.read<PendingRequestProvider>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: AppStyle.text(size: 18, weight: FontWeight.w600)),
        content: Text("Are you sure you want to $action this request?", style: AppStyle.text()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("Cancel", style: AppStyle.text(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text("Confirm", style: AppStyle.text(color: color, weight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await provider.performAction(widget.requestId, action, context);
      if (success && mounted) {
        Navigator.pop(context); // Go back to list on success
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Request Details",
          style: AppStyle.text(size: 18, weight: FontWeight.w600),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _requestDetails == null
              ? Center(child: Text("Failed to load details", style: AppStyle.text(color: Colors.grey)))
              : _buildContent(context, _requestDetails!),
    );
  }

  Widget _buildContent(BuildContext context, PendingRequestModel request) {
    final provider = context.watch<PendingRequestProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Images
          _buildImages(request),
            
          const SizedBox(height: 24),
          _buildSectionTitle("Personal Details"),
          _buildInfoRow("Full Name", request.fullName),
          _buildInfoRow("Employee No", request.empNo),
          _buildInfoRow("Member Type", request.memberType),
          _buildInfoRow("Blood Group", request.bloodGroup ?? 'N/A'),
          _buildInfoRow("Gender", request.gender ?? 'N/A'),
          _buildInfoRow("Date of Birth", request.dateOfBirth ?? 'N/A'),
          
          const SizedBox(height: 20),
          _buildSectionTitle("Contact Information"),
          _buildInfoRow("Email", request.email),
          _buildInfoRow("Phone", request.phoneNumber),
          
          if (request.currentAddress != null || request.permanentAddress != null) ...[
            const SizedBox(height: 20),
            _buildSectionTitle("Addresses"),
            if (request.currentAddress != null) _buildInfoRow("Current", request.currentAddress!),
            if (request.permanentAddress != null) _buildInfoRow("Permanent", request.permanentAddress!),
          ],

          if (request.emergencyContactName != null || request.emergencyContactPhone != null) ...[
            const SizedBox(height: 20),
            _buildSectionTitle("Emergency Contact"),
            if (request.emergencyContactName != null) _buildInfoRow("Name", request.emergencyContactName!),
            if (request.emergencyContactPhone != null) _buildInfoRow("Phone", request.emergencyContactPhone!),
          ],

          const SizedBox(height: 20),
          _buildSectionTitle("Status & Dates"),
          _buildInfoRow("Approval Status", request.approvalStatus),
          _buildInfoRow("Employee Status", request.employeeStatus),
          _buildInfoRow("Start Date", request.startDate ?? 'N/A'),
          _buildInfoRow("Created", request.createdAt ?? 'N/A'),

          const SizedBox(height: 40),
          
          if (request.approvalStatus.toLowerCase() == 'pending') ...[
            if (provider.isActionLoading)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _confirmAndPerformAction('reject', 'Reject Request', Colors.red),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade50,
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text("Reject", style: AppStyle.text(size: 16, weight: FontWeight.w600, color: Colors.red)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _confirmAndPerformAction('approve', 'Approve Request', AppStyle.primaryColor),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyle.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text("Approve", style: AppStyle.text(size: 16, weight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                ],
              ),
          ],
            
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppStyle.text(size: 16, weight: FontWeight.w600, color: AppStyle.primaryColor),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppStyle.text(size: 14, color: AppStyle.hintColor),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? 'N/A' : value,
              style: AppStyle.text(size: 14, weight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(Icons.person, size: 80, color: Colors.grey[400]),
    );
  }

  Widget _buildImages(PendingRequestModel request) {
    final images = [
      request.faceImage1,
      request.faceImage2,
      request.faceImage3,
      request.faceImage4,
    ].where((url) => url != null && url.isNotEmpty).toList();

    if (images.isEmpty) {
      return Center(child: _buildImagePlaceholder());
    }

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              images[index]!,
              height: 150,
              width: 150,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
            ),
          );
        },
      ),
    );
  }
}
