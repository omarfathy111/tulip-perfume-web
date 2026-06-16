import 'package:flutter/material.dart';
import 'package:tulip_for_perfume/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // عشان تشيل الشريط الأحمر اللي بيبقى فوق على اليمين
      title: 'Tulip For Perfume',
      home: OnboardingScreen(), // هنا بنحدد أول شاشة تفتح في التطبيق
    );
  }
}