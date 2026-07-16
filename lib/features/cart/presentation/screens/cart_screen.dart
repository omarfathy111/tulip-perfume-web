import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/whatsapp_helper.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_states.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          "MY SHOPPING CART",
          style: TextStyle(
            color: Color(0xFFB5A378),
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubit, CartStates>(
        builder: (context, state) {
          if (state is CartLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFC5A880)),
            );
          } else if (state is CartSuccessState) {
            final cartItems = state.cartItems;

            if (cartItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey[700]),
                    const SizedBox(height: 20),
                    const Text(
                      "سلتك فارغة حالياً",
                      style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "ابدأ باستكشاف أرقى عطور توليب وأضفها إلى السلة",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141414),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white10, width: 0.5),
                        ),
                        child: Row(
                          children: [
                            // صورة العطر
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                item['image'] ?? "assets/images/perfume.png",
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 15),
                            // تفاصيل العطر
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'] ?? "عطر فاخر",
                                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    item['price'] ?? "00 EGP",
                                    style: const TextStyle(color: Color(0xFFC5A880), fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            // حذف العطر من السلة (أيقونة سلة مهملات أنيقة)
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                              onPressed: () {
                                // تقدر تضيف كود المسح للـ Cubit لاحقاً لو حابب
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                // لوحة إتمام الطلب الفخمة أسفل الشاشة
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  decoration: const BoxDecoration(
                    color: Color(0xFF111111),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("عدد المنتجات:", style: TextStyle(color: Colors.grey, fontSize: 15)),
                            Text("${cartItems.length} عطور", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // زر الشراء بالكامل عبر الواتساب دفعة واحدة!
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC5A880),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            icon: const Icon(Icons.shopping_cart_checkout_rounded, size: 20),
                            label: const Text(
                              "SEND ORDER VIA WHATSAPP",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
                            ),
                            onPressed: () {
                              // تجميع كل المنتجات في رسالة واحدة للواتساب
                              String orderSummary = cartItems.map((item) => "- ${item['name']} (${item['price']})").join("\n");
                              WhatsAppHelper.open(
                                productName: "تجميعة سلة توليب:\n$orderSummary",
                                price: "",
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          } else if (state is CartErrorState) {
            return Center(
              child: Text(state.errorMessage, style: const TextStyle(color: Colors.redAccent)),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}