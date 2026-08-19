import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tulip_for_perfume/features/home/presentation/screens/landing_screen.dart';

import 'package:tulip_for_perfume/features/cart/data/repositories/cart_repository.dart';
import 'package:tulip_for_perfume/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:tulip_for_perfume/features/home/presentation/cubit/home_cubit.dart';
import 'package:tulip_for_perfume/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD4lqjTvERLmm4DG5ABgbI8skXxfwxU5Ng",
        authDomain: "tulip-perfume.firebaseapp.com",
        projectId: "tulip-perfume",
        storageBucket: "tulip-perfume.firebasestorage.app",
        messagingSenderId: "994587967021",
        appId: "1:994587967021:web:0377f87a9a6b315a4e82a4",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit()..getProducts(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(CartRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tulip For Perfume',
        theme: ThemeData.dark(),
        // 🔑 التوجيه الذكي المعتمد على كلاس حارس الجلسة
        home: const AuthGate(),
      ),
    );
  }
}

// 🛡️ كلاس يفحص الجلسة بشكل مستمر ويحافظ على استمرار الدخول
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // 🔥 استخدام userChanges لضمان التحقق من التوكين وتحديثات الـ Persistence
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        // ⏳ 1. إذا كان الفايربيز يفحص الـ Local Storage في البداية
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF070707),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFFC5A880),
              ),
            ),
          );
        }

        // 🔑 2. إذا وجد حساب محفوظ في الـ Cache / Storage 👈 يدخل فوراً LandingScreen
        if (snapshot.hasData && snapshot.data != null) {
          return const LandingScreen();
        }

        // 🚪 3. فقط إذا انتهى الفحص وتأكد عدم وجود يوزر 👈 يفتح OnboardingScreen
        return const OnboardingScreen();
      },
    );
  }
}