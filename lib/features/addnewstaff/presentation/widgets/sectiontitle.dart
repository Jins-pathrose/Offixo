import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title});
 
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppStyle.text(
        size: 16,
        color: AppStyle.sectionColor,
        weight: FontWeight.w700,
      ),
    );
  }
}