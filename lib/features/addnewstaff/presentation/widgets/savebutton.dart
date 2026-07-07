import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/common/shimmer/shimmer_container.dart';
class SaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onTap;
  final String label;

  const SaveButton({
    this.isLoading = false,
    this.onTap,
    this.label = 'Save',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      color: AppStyle.backgroundColor,
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: AppStyle.primaryGradient,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Text(
                  label,
                  style: AppStyle.text(
                    size: 16,
                    color: Colors.white,
                    weight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}