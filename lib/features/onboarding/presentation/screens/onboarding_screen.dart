import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tulip_for_perfume/core/utils/google_auth_helper.dart';
import 'package:tulip_for_perfume/features/home/presentation/screens/landing_screen.dart';
import 'package:tulip_for_perfume/features/onboarding/presentation/widgets/brand_header.dart';
import 'package:tulip_for_perfume/features/onboarding/presentation/widgets/onboarding_background.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final UserCredential? userCredential =
          await GoogleAuthHelper.signInWithGoogle();

      if (userCredential?.user != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LandingScreen(
              
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF1A1815),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            content: Text(
              'حدث خطأ أثناء تسجيل الدخول: $e',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _continueAsGuest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LandingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070707),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ============================================================
          // CINEMATIC BACKGROUND
          // ============================================================

          const OnboardingBackground(),

          // ============================================================
          // DARK CINEMATIC OVERLAY
          // ============================================================

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.30),
                  Colors.black.withOpacity(0.48),
                  Colors.black.withOpacity(0.94),
                ],
                stops: const [
                  0.0,
                  0.50,
                  1.0,
                ],
              ),
            ),
          ),

          // ============================================================
          // MAIN CONTENT
          // ============================================================

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // ======================================================
                  // BRAND HEADER
                  // ======================================================

                  const BrandHeader(),

                  const Spacer(),

                  // ======================================================
                  // CINEMATIC TEXT
                  // ======================================================

                  const _AnimatedLuxuryText(),

                  const SizedBox(height: 38),

                  // ======================================================
                  // GOOGLE BUTTON
                  // ======================================================

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFE0C08D),
                            Color(0xFFC5A880),
                            Color(0xFFA88A61),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x33C5A880),
                            blurRadius: 24,
                            spreadRadius: 0,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          splashColor: Colors.white.withOpacity(0.15),
                          highlightColor: Colors.white.withOpacity(0.06),
                          onTap: _isLoading
                              ? null
                              : _handleGoogleSignIn,
                          child: Center(
                            child: _isLoading
                                ? const SizedBox(
                                    width: 23,
                                    height: 23,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.black,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      // Google Logo
                                      Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.12),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "G",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF4285F4),
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 14),

                                      const Text(
                                        "المتابعة بواسطة Google",
                                        style: TextStyle(
                                          color: Color(0xFF17130E),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ======================================================
                  // GUEST BUTTON
                  // ======================================================

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(17),
                        splashColor:
                            const Color(0xFFC5A880).withOpacity(0.08),
                        highlightColor:
                            const Color(0xFFC5A880).withOpacity(0.04),
                        onTap: _continueAsGuest,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.025),
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                              color: const Color(0xFFC5A880)
                                  .withOpacity(0.20),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "استكشف المتجر كزائر",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.82),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(width: 10),

                              // Arrow
                              Container(
                                width: 27,
                                height: 27,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFC5A880)
                                      .withOpacity(0.10),
                                  border: Border.all(
                                    color: const Color(0xFFC5A880)
                                        .withOpacity(0.25),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 15,
                                  color: Color(0xFFC5A880),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ANIMATED LUXURY TEXT
// ============================================================================

class _AnimatedLuxuryText extends StatefulWidget {
  const _AnimatedLuxuryText();

  @override
  State<_AnimatedLuxuryText> createState() => _AnimatedLuxuryTextState();
}

class _AnimatedLuxuryTextState extends State<_AnimatedLuxuryText>
    with TickerProviderStateMixin {
  late final AnimationController _titleController;
  late final AnimationController _descriptionController;

  final List<String> _words = [
    "عالم",
    "من",
    "الفخامة",
    "والعطور",
    "الساحرة",
  ];

  @override
  void initState() {
    super.initState();

    // ------------------------------------------------------------
    // TITLE ANIMATION
    // ------------------------------------------------------------

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2600,
      ),
    );

    // ------------------------------------------------------------
    // DESCRIPTION ANIMATION
    // ------------------------------------------------------------

    _descriptionController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );

    // ------------------------------------------------------------
    // START TITLE
    // ------------------------------------------------------------

    Future.delayed(
      const Duration(
        milliseconds: 450,
      ),
      () {
        if (mounted) {
          _titleController.forward();
        }
      },
    );

    // ------------------------------------------------------------
    // START DESCRIPTION AFTER TITLE
    // ------------------------------------------------------------

    Future.delayed(
      const Duration(
        milliseconds: 3100,
      ),
      () {
        if (mounted) {
          _descriptionController.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ==========================================================
        // SMALL BRAND TITLE
        // ==========================================================

        const Text(
          "TULIP PERFUME",
          style: TextStyle(
            color: Color(0xFFC5A880),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),

        const SizedBox(height: 18),

        // ==========================================================
        // WORD BY WORD TITLE
        // ==========================================================

        Directionality(
          textDirection: TextDirection.rtl,
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 7,
            runSpacing: 3,
            children: List.generate(
              _words.length,
              (index) {
                final double start =
                    (index * 0.15).clamp(0.0, 0.75);

                final double end =
                    (start + 0.25).clamp(0.0, 1.0);

                final animation = CurvedAnimation(
                  parent: _titleController,
                  curve: Interval(
                    start,
                    end,
                    curve: Curves.easeOutCubic,
                  ),
                );

                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    final double value = animation.value;

                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          20 * (1 - value),
                        ),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    _words[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 18),

        // ==========================================================
        // DESCRIPTION
        // ==========================================================

        AnimatedBuilder(
          animation: _descriptionController,
          builder: (context, child) {
            final double value = Curves.easeOutCubic.transform(
              _descriptionController.value,
            );

            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(
                  0,
                  14 * (1 - value),
                ),
                child: child,
              ),
            );
          },
          child: Text(
            "اكتشف تشكيلة العطور النادرة والمصممة بعناية "
            "لتعبر عن حضورك المتميز في كل لحظة.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.62),
              fontSize: 13,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }
}