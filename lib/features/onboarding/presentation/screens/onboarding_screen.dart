import 'package:flutter/material.dart';
import 'package:tulip_for_perfume/features/onboarding/presentation/widgets/brand_header.dart';
import 'package:tulip_for_perfume/features/onboarding/presentation/widgets/onboarding_background.dart';
import 'package:tulip_for_perfume/features/onboarding/presentation/widgets/onboarding_content.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OnboardingBackground(),
         
          BrandHeader(),

          OnboardingContent(),
        ],
      ),
    );
  }
}
