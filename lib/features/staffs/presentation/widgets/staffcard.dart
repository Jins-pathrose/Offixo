import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class StaffCard extends StatelessWidget {
  final String name;
  final String branch;
  final String staffId;
  final String image;
  final bool isOnDuty;

  const StaffCard({
    super.key,
    required this.name,
    required this.branch,
    required this.staffId,
    required this.image,
    required this.isOnDuty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipOval(
            child: image.isNotEmpty
                ? Image.network(
                    image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildPlaceholder(),
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
                  name,
                  style: AppStyle.text(size: 16, weight: FontWeight.w600),
                ),
                Text(
                  "$branch • $staffId",
                  style: AppStyle.text(color: AppStyle.hintColor, size: 13),
                ),
              ],
            ),
          ),
        ],
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
          _getInitials(name),
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
