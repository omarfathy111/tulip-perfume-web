import 'package:flutter/foundation.dart'; // مهم جداً عشان kIsWeb تشتغل
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tulip_for_perfume/features/home/presentation/cubit/home_cubit.dart';
import 'package:tulip_for_perfume/features/onboarding/presentation/screens/onboarding_screen.dart';

// 🔥 الـ imports الجديدة الخاصة بالسلة والـ Cubit الجديد
import 'package:tulip_for_perfume/features/cart/data/repositories/cart_repository.dart';
import 'package:tulip_for_perfume/features/cart/presentation/cubit/cart_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🌐 التشيك لو كان الأبلكيشن شغال على المتصفح (Chrome)
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD4lqjTvERLmm4DG5ABgbI8skXxfwxU5Ng", // قيم الـ Firebase الخاصة بك
        authDomain: "tulip-perfume.firebaseapp.com",
        projectId: "tulip-perfume",
        storageBucket: "tulip-perfume.firebasestorage.app",
        messagingSenderId: "994587967021",
        appId: "1:994587967021:web:0377f87a9a6b315a4e82a4",
      ),
    );
  } else {
    // 📱 لو شغال موبايل (أندرويد أو آيفون) يقرا من الملفات الجاهزة تلقائياً
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
        // 1️⃣ الـ Cubit القديم الخاص بالمنتجات والصفحة الرئيسية
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit()..getProducts(),
        ),
        // 2️⃣ الـ Cubit الجديد الخاص بالسلة (بدون استدعاء مباشر فوري)
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(CartRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tulip For Perfume',
        // 🔥 بنستخدم الـ builder لتأمين الـ context الصحيح واستدعاء السلة بعد بناء الـ Widgets بالكامل
        home: Builder(
          builder: (context) {
            // ننتظر رسم أول إطار للتطبيق لضمان جاهزية الـ LocalStorage والفايربيز ثم نستدعي السلة
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<CartCubit>().getCartProducts();
            });
            return const OnboardingScreen();
          },
        ),
      ),
    );
  }
}