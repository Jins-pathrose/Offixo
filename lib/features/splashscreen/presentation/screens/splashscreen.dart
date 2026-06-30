import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/bottomnavigation/presentaion/screens/bottomnavigation.dart';
import 'package:offixoadmin/features/onboarding/presentation/screens/onboardingscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    super.initState();

    // Shimmer animation — loops until navigation happens
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Start auth check after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAuth());
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────
  // AUTH FLOW
  // ─────────────────────────────────────────

  Future<void> _checkAuth() async {
    // Keep splash visible for at least 2 seconds
    await Future.wait([
      _resolveAuth(),
      Future.delayed(const Duration(seconds: 2)),
    ]);
  }

  Future<void> _resolveAuth() async {
    final accessToken = await _storageService.getAccessToken();

    // No token at all → Login
    if (accessToken == null || accessToken.isEmpty) {
      _goTo(const OnboardingScreen());
      return;
    }

    // Validate the token with a lightweight API call
    final isValid = await _validateToken(accessToken);
    if (isValid) {
      _goTo(const MainNavigationScreen());
      return;
    }

    // Token invalid (401) → try refresh
    final refreshed = await _tryRefresh();
    if (refreshed) {
      _goTo(const MainNavigationScreen());
    } else {
      // Refresh also failed → clear and go to Login
      await _storageService.clearAllData();
      _goTo(const OnboardingScreen());
    }
  }

  // ── Ping any lightweight endpoint to check token validity ──
  Future<bool> _validateToken(String token) async {
    try {
      final res = await http.get(
        Uri.parse(
            '${dotenv.env['BASE_URL']}/api/accounts/maintainer/profile/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 8));
      return res.statusCode == 200;
    } catch (_) {
      // Network error — assume token might be valid, proceed to home
      // Change to `return false` if you prefer strict behavior
      return true;
    }
  }

  // ── Refresh token ──
  Future<bool> _tryRefresh() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final res = await http.post(
        Uri.parse(
            '${dotenv.env['BASE_URL']}/api/accounts/maintainer/refresh/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'refresh': refreshToken}),
      ).timeout(const Duration(seconds: 8));

      debugPrint('Refresh status: ${res.statusCode}');
      debugPrint('Refresh body: ${res.body}');

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        final newAccess = json['access'] as String?;
        final newRefresh = json['refresh'] as String?;

        if (newAccess != null) {
          // Get existing user data to keep it intact
          final userData = await _storageService.getUserData() ?? {};
          await _storageService.saveTokens(
            accessToken: newAccess,
            refreshToken: newRefresh ?? refreshToken, // fallback to old refresh
            userData: userData,
          );
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Refresh error: $e');
      return false;
    }
  }

  // ── Navigate and clear back stack ──
  void _goTo(Widget screen) {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  // ─────────────────────────────────────────
  // UI
  // ─────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00BCD4), Color(0xFF0288D1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Logo ──
              _ShimmerLogo(controller: _shimmerController),
              const SizedBox(height: 32),

              // ── App name ──
              _ShimmerText(
                controller: _shimmerController,
                child: const Text(
                  'Offixo',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // ── Tagline ──
              Text(
                'Smart Office Management',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHIMMER LOGO
// ─────────────────────────────────────────────


class _ShimmerLogo extends StatelessWidget {
  final AnimationController controller;
  const _ShimmerLogo({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        final pulse = 0.4 +
            0.6 * math.sin(controller.value * 2 * math.pi).abs();

        return Stack(
          alignment: Alignment.center,
          children: [
            // Animated glow ring
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(pulse * 0.6),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(pulse * 0.25),
                    blurRadius: 24,
                    spreadRadius: 6,
                  ),
                ],
              ),
            ),

            // Logo — no ShaderMask at all
            child!,
          ],
        );
      },
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Image.asset(
            'assets/icon/ChatGPT Image Jun 9, 2026, 03_16_17 PM.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// SHIMMER TEXT WRAPPER
// ─────────────────────────────────────────────

class _ShimmerText extends StatelessWidget {
  final AnimationController controller;
  final Widget child;
  const _ShimmerText({required this.controller, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, c) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            colors: const [
              Colors.white,
              Color(0xFFB2EBF2),
              Colors.white,
            ],
            stops: [
              (controller.value - 0.3).clamp(0.0, 1.0),
              controller.value.clamp(0.0, 1.0),
              (controller.value + 0.3).clamp(0.0, 1.0),
            ],
          ).createShader(bounds),
          child: c!,
        );
      },
      child: child,
    );
  }
}