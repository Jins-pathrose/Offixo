// lib/features/login/presentation/widgets/forgotpassword.dart
import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class ForgotPasswordRow extends StatelessWidget {
const ForgotPasswordRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Forgot Password ', style: AppStyle.text(size: 13)),
        GestureDetector(
          onTap: () {
            // TODO: navigate to forgot-password screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Forgot password feature coming soon')),
            );
          },
          child: Text(
            'Click Here',
            style: AppStyle.text(
              size: 13,
              color: AppStyle.accentCyan,
              weight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}