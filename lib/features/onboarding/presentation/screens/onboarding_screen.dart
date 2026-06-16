import 'package:flutter/material.dart';
import 'package:tulip_for_perfume/core/constants/app_images.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. خلفية الشاشة (الصورة ثابتة وتفرش الشاشة كلها)
          Container(
                decoration: const BoxDecoration(

              image: DecorationImage(

                image: AssetImage(AppImages.onboardingBackground), // استخدمنا الـ Constant هنا

                fit: BoxFit.cover,

              ),

            ),
          ),

          // 2. طبقة ظل داكنة خفيفة (Gradient Overlay) عشان الكلام الأبيض يبان بوضوح فوق الصورة
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2), // ظل خفيف فوق
                  Colors.black.withOpacity(0.7), // ظل أثقل تحت عند الكلام
                ],
              ),
            ),
          ),

          // 3. التحكم في مكان الكلام والزرار (هنا السحر كله 👇)
          Positioned(
            top: 100,  // المسافة من أسفل الشاشة 50 بكسل
            left: 20,    // مسافة أمان من الشمال
            right: 20,   // مسافة أمان من اليمين
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // تخريد الكلام في النص
              children: [
                // اسم البراند
                const Text(
                  'TULIP PERFUME',
                  style: TextStyle(
                    color: Color(0xFFD4AF37), // لون ذهبي فخم لايق على العطور
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0, // مسافة بين الحروف بتدي شياكة
                  ),
                ),
                const SizedBox(height: 10), // مسافة بين العناوين
                
               
              ],
            ),
          ),
          Positioned(
              bottom: 50,  // المسافة من أسفل الشاشة 50 بكسل
            left: 20,    // مسافة أمان من الشمال
            right: 20,   // مسافة أمان من اليمين
            child: Column(
            children: [
               // الجملة التسويقية
                Text(
                  'اكتشف عطررك الفريد وجاذبيتك الخاصة مع تشكيلتنا الفاخرة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.5, // المسافة بين السطرين
                  ),
                ),
                const SizedBox(height: 40), // مسافة قبل الزرار

                // زرار البداية
                SizedBox(
                  width: double.infinity, // يخلي الزرار يفرش العرض المتاح كله
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // هنا هتنقل للملف بتاع الـ Home Screen بعدين
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37), // لون الزرار ذهبي
                      foregroundColor: Colors.black, // لون كتابة الزرار
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // حواف دائرية مودرن
                      ),
                    ),
                    child: const Text(
                      'ابدأ الآن',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ))
        ],
      ),
    );
  }
}