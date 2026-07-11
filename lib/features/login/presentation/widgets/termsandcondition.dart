import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsText extends StatelessWidget {
  const TermsText();

  @override
  Widget build(BuildContext context) {
    final Uri _policyUrl = Uri.parse(
      'https://www.freeprivacypolicy.com/live/5eb0d809-d24c-4e9f-850a-4563ca170e5d',
    );

    Future<void> _openPolicy() async {
      if (!await launchUrl(_policyUrl, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $_policyUrl');
      }
    }

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
            recognizer: TapGestureRecognizer()..onTap = _openPolicy,
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: AppStyle.text(
              size: 12,
              color: AppStyle.accentCyan,
              weight: FontWeight.w500,
            ),
            recognizer: TapGestureRecognizer()..onTap = _openPolicy,
          ),
        ],
      ),
    );
  }
}
