import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader();
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back,',
          style: AppStyle.text(
            size: 28,
            weight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Login to your Account',
          style: AppStyle.text(
            size: 14,
            color: AppStyle.hintColor,
          ),
        ),
      ],
    );
  }
}