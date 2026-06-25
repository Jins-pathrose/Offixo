import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class Backbutton extends StatelessWidget {
  const Backbutton();
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.maybePop(context),
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppStyle.primaryGradient,
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 24),
      ),
    );
  }
}