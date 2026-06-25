import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class InputLabel extends StatelessWidget {
  final String label;
  const InputLabel({required this.label});
 
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppStyle.text(
        size: 13,
        weight: FontWeight.w500,
        color: AppStyle.hintColor,
      ),
    );
  }
}