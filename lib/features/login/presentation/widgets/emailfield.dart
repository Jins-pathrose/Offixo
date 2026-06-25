// lib/features/login/presentation/widgets/emailfield.dart
import 'package:flutter/material.dart';
import 'package:offixoadmin/features/login/presentation/provider/logincontroller.dart';
import 'package:provider/provider.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/login/presentation/widgets/apptextfield.dart';

class EmailField extends StatelessWidget {
  const EmailField();

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.read<LoginProvider>();
    return AppTextField(
      hintText: 'fahadrahman@gmail.com',
      keyboardType: TextInputType.emailAddress,
      controller: loginProvider.emailController,
      onChanged: (v) => loginProvider.setEmail(v),
      prefixIcon: const Icon(
        Icons.mail_outline_rounded,
        color: AppStyle.hintColor,
        size: 20,
      ),
    );
  }
}