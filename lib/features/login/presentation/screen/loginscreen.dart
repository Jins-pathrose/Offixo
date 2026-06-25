import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/login/presentation/widgets/backbutton.dart';
import 'package:offixoadmin/features/login/presentation/widgets/continuebutton.dart';
import 'package:offixoadmin/features/login/presentation/widgets/emailfield.dart';
import 'package:offixoadmin/features/login/presentation/widgets/forgotpassword.dart';
import 'package:offixoadmin/features/login/presentation/widgets/inputlabel.dart';
import 'package:offixoadmin/features/login/presentation/widgets/loginheader.dart';
import 'package:offixoadmin/features/login/presentation/widgets/passwordfield.dart';
import 'package:offixoadmin/features/login/presentation/widgets/termsandcondition.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 200),

              // ── Back Button ──
              const Backbutton(),

              const SizedBox(height: 32),

              // ── Header ──
              const LoginHeader(),

              const SizedBox(height: 40),

              // ── Email Field ──
              InputLabel(label: 'Email Id'),
              const SizedBox(height: 8),
              const EmailField(),

              const SizedBox(height: 20),

              // ── Password Field ──
              InputLabel(label: 'Password'),
              const SizedBox(height: 8),
              const PasswordField(),

              const SizedBox(height: 28),

              // ── Continue Button ──
              const ContinueButton(),

              const SizedBox(height: 28),

              // ── Forgot Password ──
              const ForgotPasswordRow(),

              const SizedBox(height: 48),

              // ── Terms ──
              Center(child: const TermsText()),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
