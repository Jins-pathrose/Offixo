import 'package:flutter/material.dart';

class StatCardData {
  final String icon;
  final String count;
  final String label;
  final Color startColor;
  final Color endColor;

  const StatCardData({
    required this.icon,
    required this.count,
    required this.label,
    required this.startColor,
    required this.endColor,
  });
}