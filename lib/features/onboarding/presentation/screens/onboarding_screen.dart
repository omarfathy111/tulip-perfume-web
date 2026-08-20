import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:tulip_for_perfume/features/home/presentation/screens/landing_screen.dart';
import 'package:tulip_for_perfume/features/onboarding/presentation/widgets/brand_header.dart';
import 'package:tulip_for_perfume/features/onboarding/presentation/widgets/onboarding_background.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();

    // الانتقال تلقائياً إلى LandingScreen
    // بعد انتهاء الـ Intro
    Future.delayed(
      const Duration(milliseconds: 5200),
      () {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LandingScreen(),
          ),
        );
      },
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

                  const Spacer(),

                  // ======================================================
                  // BOTTOM BRAND TEXT
                  // ======================================================

                  Text(
                    'TULIP PERFUMES',
                    style: TextStyle(
                      color: const Color(0xFFC5A880)
                          .withOpacity(0.55),
                      fontSize: 9,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ============================================================
          // LOADING / ENTER INDICATOR
          // ============================================================

          Positioned(
            bottom: 55,
            left: 0,
            right: 0,
            child: _LoadingIndicator(),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LOADING INDICATOR
// ============================================================================

class _LoadingIndicator extends StatefulWidget {
  @override
  State<_LoadingIndicator> createState() =>
      _LoadingIndicatorState();
}

class _LoadingIndicatorState
    extends State<_LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1400,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity:
              0.35 +
              (0.65 *
                  (0.5 -
                      (0.5 -
                              _controller.value)
                          .abs())),
          child: Column(
            children: [
              Container(
                width: 34,
                height: 1,
                decoration: BoxDecoration(
                  color: const Color(0xFFC5A880),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'DISCOVER',
                style: TextStyle(
                  color: Colors.white
                      .withOpacity(0.45),
                  fontSize: 8,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// ANIMATED LUXURY TEXT
// ============================================================================

class _AnimatedLuxuryText extends StatefulWidget {
  const _AnimatedLuxuryText();

  @override
  State<_AnimatedLuxuryText> createState() =>
      _AnimatedLuxuryTextState();
}

class _AnimatedLuxuryTextState
    extends State<_AnimatedLuxuryText>
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

    // ============================================================
    // TITLE ANIMATION
    // ============================================================

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2600,
      ),
    );

    // ============================================================
    // DESCRIPTION ANIMATION
    // ============================================================

    _descriptionController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );

    // ============================================================
    // START TITLE
    // ============================================================

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

    // ============================================================
    // START DESCRIPTION
    // ============================================================

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
                    (index * 0.15)
                        .clamp(0.0, 0.75);

                final double end =
                    (start + 0.25)
                        .clamp(0.0, 1.0);

                final animation =
                    CurvedAnimation(
                  parent: _titleController,
                  curve: Interval(
                    start,
                    end,
                    curve:
                        Curves.easeOutCubic,
                  ),
                );

                return AnimatedBuilder(
                  animation: animation,
                  builder:
                      (context, child) {
                    final double value =
                        animation.value;

                    return Opacity(
                      opacity: value,
                      child:
                          Transform.translate(
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
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight:
                          FontWeight.bold,
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
            final double value =
                Curves.easeOutCubic.transform(
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
              color:
                  Colors.white.withOpacity(0.62),
              fontSize: 13,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }
}