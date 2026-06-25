import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/branch/presentation/provider/createbranchprovider.dart';

class LocationField extends StatelessWidget {
  final SelectedLocation? selectedLocation;
  final String? errorText;
  final VoidCallback onTap;
 
  const LocationField({
    required this.onTap,
    this.selectedLocation,
    this.errorText,
  });
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: errorText != null
                    ? const Color(0xFFE53935)
                    : AppStyle.borderColor,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedLocation?.address ?? 'Choose Branch Location',
                    style: AppStyle.text(
                      size: 13,
                      color: selectedLocation != null
                          ? AppStyle.fontColor
                          : AppStyle.hintColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: selectedLocation != null
                      ? AppStyle.accentCyan
                      : AppStyle.hintColor,
                ),
              ],
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 2),
            child: Text(errorText!,
                style: AppStyle.text(
                    size: 11, color: const Color(0xFFE53935))),
          ),
      ],
    );
  }
}