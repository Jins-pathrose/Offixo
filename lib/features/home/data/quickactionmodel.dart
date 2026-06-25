import 'dart:ui';
import 'package:flutter/material.dart';

class QuickActionData {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon; // Optional: add icon support
  
  const QuickActionData({
    required this.label, 
    this.onTap,
    this.icon,
  });
}
 
class CheckInStaffData {
  final String name;
  final String branch;
  final String staffId;
  final String imagePath; // asset path or network url
  final bool isOnDuty;
 
  const CheckInStaffData({
    required this.name,
    required this.branch,
    required this.staffId,
    required this.imagePath,
    this.isOnDuty = true,
  });
}