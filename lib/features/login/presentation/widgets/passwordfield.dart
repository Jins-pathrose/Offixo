// lib/features/login/presentation/widgets/passwordfield.dart
import 'package:flutter/material.dart';
import 'package:offixoadmin/features/login/presentation/provider/logincontroller.dart';
import 'package:provider/provider.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/login/presentation/widgets/apptextfield.dart';

class PasswordField extends StatefulWidget {
  const PasswordField();

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.read<LoginProvider>();
    return AppTextField(
      hintText: 'Enter your password',
      obscureText: _obscureText,
      controller: loginProvider.passwordController,
      onChanged: (v) => loginProvider.setPassword(v),
      prefixIcon: const Icon(
        Icons.lock_outline_rounded,
        color: AppStyle.hintColor,
        size: 20,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          color: AppStyle.hintColor,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}