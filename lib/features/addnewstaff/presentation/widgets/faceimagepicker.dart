import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class FaceImagePicker extends StatelessWidget {
  final String label;
  final bool isRequired;
  final String scanLabel;
  final File? image;
  final VoidCallback? onTap;

  const FaceImagePicker({
    required this.label,
    required this.scanLabel,
    this.isRequired = false,
    this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: AppStyle.text(size: 13, weight: FontWeight.w500),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: AppStyle.text(
                        size: 13,
                        color: const Color(0xFFE53935),
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 110,
            width: double.infinity, // ← added
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppStyle.borderColor,
                style: BorderStyle.solid,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: image != null
                ? Image.file(image!, fit: BoxFit.cover, width: double.infinity)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/Icon.svg',
                        width: 30,
                        height: 30,
                        colorFilter: ColorFilter.mode(
                          AppStyle.primaryColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        scanLabel,
                        style: AppStyle.text(
                          size: 12,
                          color: AppStyle.hintColor,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
