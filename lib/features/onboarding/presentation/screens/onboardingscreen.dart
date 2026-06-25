import 'dart:math';

import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/login/presentation/screen/loginscreen.dart';
import 'package:offixoadmin/features/onboarding/domain/model/onboarding_model.dart';
import 'package:offixoadmin/features/onboarding/presentation/widgets/outwardushapeclipper.dart';
import 'package:offixoadmin/features/onboarding/presentation/widgets/transitions.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final _buttonKey = GlobalKey();

  final List<OnboardingModel> _pages = [
    OnboardingModel(
      image: 'assets/images/Offixo_onboardingscreem_1.jpg',
      title: 'Manage Your Workforce Without the Confusion',
      description:
          'Track employee check-ins, monitor attendance, and manage teams from one dashboard.',
    ),
    OnboardingModel(
      image: 'assets/images/Offixo_onboardingscreen_2.jpg',
      title: 'Track Every Check-In With Accuracy',
      description:
          'View real-time check-in and check-out activity, employee status, and work hours instantly.',
    ),
    OnboardingModel(
      image: 'assets/images/Offixo_onboardingscreen_3.jpg',
      title: 'Simplify Payroll and Attendance Reports',
      description:
          'Automate salary calculations, monthly reports, and attendance summaries without manual work.',
    ),
  ];

  void _navigateToLogin() {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => LoginScreen()),
  );
}

  void _handleNext() {
    if (_currentPage == _pages.length - 1) {
      _navigateToLogin();
    } else {
      setState(() {
        _currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Continuous scale factor based on screen height
    // 812 = iPhone 13/14 reference height (1.0x scale)
    // clamp between 0.75 (very small devices) and 1.0 (large devices)
    final scale = (size.height / 812).clamp(0.75, 1.0);

    // Responsive values — all scale smoothly with device height
    final imageHeightFactor = 0.75 - (1 - scale) * 0.12; // 0.63 .. 0.75
    final bottomHeightFactor = 0.40 + (1 - scale) * 0.12; // 0.40 .. 0.49
    final titleSize = 25.0 * scale;
    final descSize = (13.0 * scale).clamp(11.0, 13.0);
    final spacingAfterDesc = 12.0 * scale;
    final indicatorSpacing = 20.0 * scale;
    final buttonHeight = (56.0 * scale).clamp(48.0, 56.0);
    final curveCompensation = 95.0 * scale; // increased to clear the curve
    final bottomPadding = 40.0 * scale;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1211),
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! < 0) {
              if (_currentPage < _pages.length - 1) {
                setState(() => _currentPage++);
              }
            } else if (details.primaryVelocity! > 0) {
              if (_currentPage > 0) {
                setState(() => _currentPage--);
              }
            }
          },
          child: Stack(
            children: [
              // ── Fading Images Area ──
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: size.height * imageHeightFactor,
                child: Stack(
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedOpacity(
                      duration: const Duration(milliseconds: 600),
                      opacity: _currentPage == index ? 1.0 : 0.0,
                      curve: Curves.easeInOut,
                      child: Stack(
                        children: [
                          Image.asset(
                            _pages[index].image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 150,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    const Color.fromARGB(255, 255, 255, 255)
                                        .withOpacity(0.9),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Bottom Content Area with U-Shape ──
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: size.height * bottomHeightFactor,
                child: ClipPath(
                  clipper: OutwardUShapeClipper(),
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: const Color(0xFFF9F9F9),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        32,
                        curveCompensation,
                        32,
                        bottomPadding,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ── Title + Description ──
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AnimatedSwitcher(
                                    duration:
                                        const Duration(milliseconds: 400),
                                    transitionBuilder: (child, animation) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(0.5, 0.0),
                                          end: Offset.zero,
                                        ).animate(
                                          CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeOut,
                                          ),
                                        ),
                                        child: FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: ShaderMask(
                                      shaderCallback: (bounds) {
                                        return AppStyle.primaryGradient
                                            .createShader(
                                          Rect.fromLTWH(
                                            0,
                                            0,
                                            bounds.width,
                                            bounds.height,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        _pages[_currentPage].title,
                                        key: ValueKey(
                                            _pages[_currentPage].title),
                                        textAlign: TextAlign.center,
                                        style: AppStyle.text(
                                          size: titleSize,
                                          weight: FontWeight.w700,
                                          height: 1.2,
                                          color: Colors.white,
                                        ).copyWith(letterSpacing: 0.14),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: spacingAfterDesc),
                                  AnimatedSwitcher(
                                    duration:
                                        const Duration(milliseconds: 500),
                                    transitionBuilder: (child, animation) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(-0.5, 0.0),
                                          end: Offset.zero,
                                        ).animate(
                                          CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeOut,
                                          ),
                                        ),
                                        child: FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Text(
                                      _pages[_currentPage].description,
                                      key: ValueKey(
                                          _pages[_currentPage].description),
                                      textAlign: TextAlign.center,
                                      style: AppStyle.text(
                                        size: descSize,
                                        color: const Color(0xFF9CA3AF),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ── Page Indicators ──
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _pages.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                height: 8,
                                width: _currentPage == index ? 24 : 8,
                                decoration: BoxDecoration(
                                  gradient: _currentPage == index
                                      ? AppStyle.primaryGradient
                                      : LinearGradient(
                                          colors: [
                                            Colors.grey.shade400,
                                            Colors.grey.shade400,
                                          ],
                                        ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: indicatorSpacing),

                          // ── Continue/Get Started Button ──
                          SizedBox(
                            width: double.infinity,
                            height: buttonHeight,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AppStyle.primaryGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ElevatedButton(
                                key: _buttonKey,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  animationDuration:
                                      const Duration(milliseconds: 200),
                                ),
                                onPressed: _handleNext,
                                child: AnimatedSwitcher(
                                  duration:
                                      const Duration(milliseconds: 200),
                                  transitionBuilder: (child, animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  child: Text(
                                    _currentPage == _pages.length - 1
                                        ? 'Login to your account'
                                        : 'Continue',
                                    key: ValueKey(_currentPage),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}