import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tulip_for_perfume/core/utils/guest_service.dart';
import '../../data/repositories/cart_repository.dart';
import 'cart_states.dart';

class CartCubit extends Cubit<CartStates> {
  final CartRepository _cartRepository;

  CartCubit(this._cartRepository) : super(CartInitialState());

  // 🔥 1. دالة إضافة منتج للسلة
  Future<void> addProductToCart({
    required String productId,
    required String productName,
    required String productPrice,
    required String productImage,
  }) async {
    emit(CartLoadingState());
    try {
      await _cartRepository.addToCart(
        productId: productId,
        productName: productName,
        productPrice: productPrice,
        productImage: productImage,
      );
      emit(ProductAddedToCartSuccessState());
      // بعد ما نضيف، بنرجع نجيب المنتجات تاني تلقائياً لتحديث السلة
      getCartProducts(); 
    } catch (e) {
      emit(CartErrorState("فشل إضافة المنتج للسلة: ${e.toString()}"));
    }
  }

  // 📥 2. دالة جلب منتجات السلة ومراقبتها لايف (Stream)
 // 📥 2. دالة جلب منتجات السلة ومراقبتها لايف (Stream) بعد تعديل الـ Async
 // 📥 دالة جلب المنتجات الحية
  Future<void> getCartProducts() async {
    emit(CartLoadingState());
    try {
      // 1. استدعاء الـ ID المستقر والآمن
      String guestId = await GuestService.getOrCreateGuestId();
      
      // 2. ربط الـ Stream بالـ ID
      _cartRepository.getCartItemsStream(guestId).listen(
        (snapshot) {
          final items = snapshot.docs.map((doc) => doc.data()).toList();
          emit(CartSuccessState(items));
        },
        onError: (error) {
          emit(CartErrorState("حدث خطأ أثناء جلب السلة: ${error.toString()}"));
        },
      );
    } catch (e) {
      emit(CartErrorState("فشل تحميل السلة المحفوظة: ${e.toString()}"));
    }
  }
}