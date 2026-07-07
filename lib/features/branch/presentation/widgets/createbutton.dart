import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/common/shimmer/shimmer_container.dart';
class CreateButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onTap;

  final bool isEdit;

  const CreateButton({this.isLoading = false, this.onTap, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
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
            : Text(isEdit ? 'Save Changes' : 'Create Branch',
                style: AppStyle.text(
                    size: 16,
                    color: Colors.white,
                    weight: FontWeight.w600)),
      ),
    );
  }
}