import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';

class TermsText extends StatelessWidget {
  const TermsText();
 
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppStyle.text(size: 12, color: AppStyle.hintColor),
        children: [
          const TextSpan(text: 'By clicking Continue, you agree to our\n'),
          TextSpan(
            text: 'Terms of Service',
            style: AppStyle.text(
              size: 12,
              color: AppStyle.accentCyan,
              weight: FontWeight.w500,
            ),
            // TODO: recognizer: TapGestureRecognizer()..onTap = () => launchUrl(...)
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: AppStyle.text(
              size: 12,
              color: AppStyle.accentCyan,
              weight: FontWeight.w500,
            ),
            // TODO: recognizer: TapGestureRecognizer()..onTap = () => launchUrl(...)
          ),
        ],
      ),
    );
  }
}