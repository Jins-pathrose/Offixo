import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/medicines/data/model/selected_medicine_model.dart';
import 'package:offixoadmin/features/medicines/presentation/provider/selected_medicine_provider.dart';
import 'package:provider/provider.dart';
import 'package:offixoadmin/common/shimmer/shimmer_list.dart';

class SelectedMedicinesScreen extends StatelessWidget {
  final int attendanceId;
  const SelectedMedicinesScreen({super.key, required this.attendanceId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectedMedicineProvider(attendanceId: attendanceId),
      child: const _SelectedMedicinesView(),
    );
  }
}

class _SelectedMedicinesView extends StatelessWidget {
  const _SelectedMedicinesView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SelectedMedicineProvider>();

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
                  Text('Selected Medicines',
                      style: AppStyle.text(size: 20, weight: FontWeight.w700)),
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFFFCDD2)),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SelectedMedicineProvider provider) {
    switch (provider.state) {
      case SelectedMedicineLoadState.idle:
      case SelectedMedicineLoadState.loading:
        return const ShimmerList();

      case SelectedMedicineLoadState.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text('Failed to load selected medicines',
                  style: AppStyle.text(color: Colors.grey)),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: provider.fetchSelectedMedicines,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: AppStyle.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Retry',
                      style: AppStyle.text(
                          color: Colors.white, weight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );

      case SelectedMedicineLoadState.loaded:
        final data = provider.data;
        if (data == null) {
          return const Center(child: Text('No data available'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Member Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.memberName,
                      style: AppStyle.text(size: 16, weight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(data.memberEmail,
                      style: AppStyle.text(size: 13, color: AppStyle.hintColor)),
                  const Divider(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.login, size: 16, color: AppStyle.accentCyan),
                      const SizedBox(width: 8),
                      Text('Check-in: ',
                          style: AppStyle.text(size: 13, weight: FontWeight.w500)),
                      Text(
                        _formatTime(data.checkinTime) ?? '--',
                        style: AppStyle.text(size: 13, color: AppStyle.hintColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.logout, size: 16, color: Color(0xFFE53935)),
                      const SizedBox(width: 8),
                      Text('Check-out: ',
                          style: AppStyle.text(size: 13, weight: FontWeight.w500)),
                      Text(
                        _formatTime(data.checkoutTime) ?? '--',
                        style: AppStyle.text(size: 13, color: AppStyle.hintColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            Text('Medicine Samples',
                style: AppStyle.text(
                    size: 14,
                    color: AppStyle.accentCyan,
                    weight: FontWeight.w700)),
            const SizedBox(height: 12),
            
            // Medicines List
            Expanded(
              child: data.medicineSamples.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.medical_services_outlined,
                              size: 56, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text('No medicines selected',
                              style: AppStyle.text(color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: data.medicineSamples.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final med = data.medicineSamples[i];
                        return _SampleCard(sample: med);
                      },
                    ),
            ),
          ],
        );
    }
  }

  String? _formatTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;
    try {
      final dt = DateTime.parse(timeStr).toLocal();
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour < 12 ? 'AM' : 'PM';
      return '$h:$m $period';
    } catch (_) {
      return timeStr;
    }
  }
}

class _SampleCard extends StatelessWidget {
  final SelectedMedicineSample sample;
  const _SampleCard({required this.sample});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Count Badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF00BCD4),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              '${sample.count}x',
              style: AppStyle.text(size: 16, weight: FontWeight.w700, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),

          // Name and Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sample.medicineName,
                    style: AppStyle.text(size: 14, weight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Code: ${sample.medicineCode}',
                    style: AppStyle.text(size: 12, color: AppStyle.hintColor)),
                if (sample.notes.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notes, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            sample.notes,
                            style: AppStyle.text(size: 12, color: Colors.grey.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
