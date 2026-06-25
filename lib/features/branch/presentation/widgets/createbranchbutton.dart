import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class CreateBranchButton extends StatelessWidget {
  final VoidCallback onTap;
  const CreateBranchButton({required this.onTap});
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: AppStyle.primaryGradient,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: Text('Create Branch',
            style: AppStyle.text(
                size: 16, color: Colors.white, weight: FontWeight.w600)),
      ),
    );
  }
}
 