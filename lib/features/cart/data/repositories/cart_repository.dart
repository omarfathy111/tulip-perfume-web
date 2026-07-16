import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tulip_for_perfume/core/utils/guest_service.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🛒 دالة إضافة منتج لسلة الـ Guest المجهول في الفايربيز
  Future<void> addToCart({
    required String productId,
    required String productName,
    required String productPrice,
    required String productImage,
    int quantity = 1,
  }) async {
    try {
      String guestId = await GuestService.getOrCreateGuestId();
      DocumentReference cartRef = _firestore.collection('carts').doc(guestId);

      await cartRef.collection('items').doc(productId).set({
        'productId': productId,
        'name': productName,
        'price': productPrice,
        'image': productImage,
        'quantity': quantity,
        'addedAt': FieldValue.serverTimestamp(),
      });

      print("🎉 Product added to Guest Cart successfully!");
    } catch (e) {
      print("❌ Error adding to cart: $e");
    }
  }

  // 📥 🔥 تعديل دالة جلب البيانات لتصبح متوافقة تماماً مع الويب والريستارت
  Stream<QuerySnapshot<Map<String, dynamic>>> getCartItemsStream(String guestId) {
    return _firestore
        .collection('carts')
        .doc(guestId)
        .collection('items')
        .orderBy('addedAt', descending: true)
        .snapshots();
  }
}