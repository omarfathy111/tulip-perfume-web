import 'package:url_launcher/url_launcher.dart';

class WhatsAppHelper {
  static void open({
    required String productName,
    required String price,
    String phoneNumber = "201016533007",
  }) async {
    String message = "مرحباً توليب، أود طلب هذا العطر الفاخر:\n\n"
                     "📌 عطر: $productName\n"
                     "💰 السعر: $price";

    String url = "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent(message)}";
    String fallbackUrl = "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

    try {
      bool launched = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print("خطأ أثناء فتح الواتساب: $e");
    }
  }
}