import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Staff Details',
              style: AppStyle.text(size: 20, weight: FontWeight.w700)),
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFCDD2)),
              ),
              child: Row(
                children: [
                  Text('Close',
                      style: AppStyle.text(
                          size: 13,
                          color: const Color(0xFFE53935),
                          weight: FontWeight.w500)),
                  const SizedBox(width: 4),
                  const Icon(Icons.close, size: 14, color: Color(0xFFE53935)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}