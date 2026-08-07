// lib/features/login/presentation/widgets/continuebutton.dart
import 'package:flutter/material.dart';
import 'package:offixoadmin/features/login/presentation/provider/logincontroller.dart';
import 'package:provider/provider.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/bottomnavigation/presentaion/screens/bottomnavigation.dart';
import 'package:offixoadmin/common/shimmer/shimmer_container.dart';
import 'package:offixoadmin/features/settings/presentation/provider/maintainerprofileprovider.dart';
import 'package:offixoadmin/features/home/presentation/provider/homeprovider.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton();

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();

    return GestureDetector(
      onTap:
          loginProvider.isLoading
              ? null
              : () async {
                final success = await loginProvider.login(context);
                if (success && context.mounted) {
                  // Fetch the profile for the new user before navigating
                  context.read<MaintainerProfileProvider>().fetchProfile();
                  context.read<HomeProvider>().loadAll();
                  
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainNavigationScreen(),
                    ),
                  );
                } else if (context.mounted &&
                    loginProvider.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(loginProvider.errorMessage!),
                      backgroundColor: Colors.black12,
                    ),
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
        child:
            loginProvider.isLoading
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
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
