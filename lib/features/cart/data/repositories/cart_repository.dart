import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tulip_for_perfume/core/utils/guest_service.dart';

class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🛒 دالة إضافة منتج لسلة الـ Guest المجهول في الفايربيز
 // 🛒 دالة إضافة منتج لسلة الـ Guest (مُعدلة لتوليد ID آمن لا يضيع)
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

      // 🔥 بدلاً من استخدام اسم المنتج كـ Doc ID، بنخليه ينشئ ID آمن أو نستخدم doc(productId) بدون رموز
      // استخدام doc().set بـ ID مائل أو مسافات بيعمل Crash على الويب عند الريستارت
      String safeDocId = productId.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '_');

      await cartRef.collection('items').doc(safeDocId).set({
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

  // ➕/➖ دالة تحديث كمية المنتج
  Future<void> updateQuantity({
    required String productId,
    required int newQuantity,
  }) async {
    try {
      String guestId = await GuestService.getOrCreateGuestId();
      String safeDocId = productId.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '_');

      if (newQuantity <= 0) {
        // لو الكمية بقت 0 نمسح المنتج تلقائياً
        await deleteFromCart(productId: productId);
      } else {
        await _firestore
            .collection('carts')
            .doc(guestId)
            .collection('items')
            .doc(safeDocId)
            .update({'quantity': newQuantity});
      }
    } catch (e) {
      print("Error updating quantity: $e");
    }
  }

  // 🗑️ دالة حذف منتج من السلة
  Future<void> deleteFromCart({required String productId}) async {
    try {
      String guestId = await GuestService.getOrCreateGuestId();
      String safeDocId = productId.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '_');

      await _firestore
          .collection('carts')
          .doc(guestId)
          .collection('items')
          .doc(safeDocId)
          .delete();
    } catch (e) {
      print("Error deleting item: $e");
    }
  }
}