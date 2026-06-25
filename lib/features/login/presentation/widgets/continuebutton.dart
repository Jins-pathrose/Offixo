// lib/features/login/presentation/widgets/continuebutton.dart
import 'package:flutter/material.dart';
import 'package:offixoadmin/features/login/presentation/provider/logincontroller.dart';
import 'package:provider/provider.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/bottomnavigation/presentaion/screens/bottomnavigation.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton();

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();
    
    return GestureDetector(
      onTap: loginProvider.isLoading ? null : () async {
        final success = await loginProvider.login(context);
        if (success && context.mounted) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => const MainNavigationScreen())
          );
        } else if (context.mounted && loginProvider.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(loginProvider.errorMessage!)),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: AppStyle.primaryGradient,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: loginProvider.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'Continue',
                style: AppStyle.text(
                  size: 16,
                  color: Colors.white,
                  weight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}