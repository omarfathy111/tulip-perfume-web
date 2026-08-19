import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

class WhatsAppHelper {
  // 📱 رقم الواتساب الخاص بمتجرك بالرمز الدولي
  static const String phoneNumber = "201011158329"; // 👈 غير الرقم هنا لرقم المحل

  static Future<void> open({
    required String productName,
    required String price,
  }) async {
    // 🎨 تنسيق الرسالة بشكل ملكي وفخم جدًا
    final String formattedText = 
'''
🛍️ *طلب جديد من التطبيق - TULIP PERFUME*
──────────────────────────

✨ *تفاصيل العطر:*
• *المنتج:* $productName
• *السعر:* $price

📋 *بيانات التوصيل المطلوب استكمالها:*
• *الاسم بالكامل:* 
• *رقم الهاتف:* 
• *العنوان بالتفصيل:* 

──────────────────────────
🌸 _شكراً لاختيارك Tulip Perfume_
''';

    final String whatsappUrl = "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(formattedText)}";

    try {
      if (kIsWeb) {
        html.window.open(whatsappUrl, '_blank');
      } else {
        final Uri uri = Uri.parse(whatsappUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (kDebugMode) {
            print("لا يمكن فتح الواتساب");
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("خطأ أثناء فتح الواتساب: $e");
      }
    }
  }
}