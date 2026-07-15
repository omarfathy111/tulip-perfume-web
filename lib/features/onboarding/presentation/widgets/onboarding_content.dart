import 'package:flutter/material.dart';
import 'package:tulip_for_perfume/features/home/presentation/screens/home_screen.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      right: 20,
      left: 20,
      child: Column(
        children: [
          Text(
            'اكتشف عطرك الفريد وجاذبيتك الخاصة مع تشكيلتنا الفاخرة',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
          SizedBox(height: 40), // مسافة قبل الزرار
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                   backgroundColor: const Color(0xFFD4AF37),
                     foregroundColor: Colors.black, // لون كتابة الزرار
    
                shape: RoundedRectangleBorder(
    
                  borderRadius: BorderRadius.circular(30)), // ح
              ),
              onPressed: () {
                // هنا ممكن تضيف أي وظيفة عايزها لما الزرار يتضغط

                  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => const HomeScreen(),
    ),
  );// مثال: الانتقال لشاشة الهوم
              },
              child: Text('ابدأ الان',style: TextStyle(fontWeight: FontWeight.bold),),
              
            ),
          ),
        ],
      ),
    );
  }
}