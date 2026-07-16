import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 👈 استيراد الـ Bloc للاستماع لحالة السلة
import 'package:tulip_for_perfume/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:tulip_for_perfume/features/cart/presentation/cubit/cart_states.dart';
import '../../../../core/utils/whatsapp_helper.dart';
import 'triangle_painter.dart';

class ProductDetailsSheet extends StatelessWidget {
  final String name;
  final String price;
  final String description;
  final double rating;       // 👈 إضافة متغير التقييم
  final int reviewsCount;    // 👈 إضافة متغير عدد المراجعات

  const ProductDetailsSheet({
    super.key,
    required this.name,
    required this.price,
    required this.description,
    this.rating = 4.8,       // قيمة افتراضية في حال عدم التمرير
    this.reviewsCount = 120, // قيمة افتراضية في حال عدم التمرير
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // مؤشر السحب (Notch)
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              children: [
                // 1. الاسم والسعر
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      price,
                      style: const TextStyle(color: Color(0xFFC5A880), fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text("by TULIP", style: TextStyle(color: Colors.grey, fontSize: 14)),
                
                // ⭐ التقييم والنجوم الديناميكية
                const SizedBox(height: 10),
                Row(
                  children: [
                    Row(
                      children: List.generate(5, (index) => const Icon(Icons.star_rounded, color: Color(0xFFC5A880), size: 20)),
                    ),
                    const SizedBox(width: 8),
                    // قراءة رقم التقييم بشكل ديناميكي
                    Text(
                      rating.toString(), 
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 6),
                    // قراءة عدد المراجعات بشكل ديناميكي
                    Text(
                      "($reviewsCount reviews)", 
                      style: TextStyle(color: Colors.grey[500], fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 2. الوصف الديناميكي
                Text(
                  description,
                  style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.6),
                ),
                const SizedBox(height: 25),

                // 3. النوتات
                const Text(
                  "FRAGRANCE NOTES",
                  style: TextStyle(color: Color(0xFFC5A880), fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
                const SizedBox(height: 15),

                // 4. الهرم العطري
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 80,
                      child: CustomPaint(
                        painter: TrianglePainter(),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("NOTE", style: TextStyle(color: Colors.grey, fontSize: 9)),
                              Text("PYRAMID", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: Column(
                        children: [
                          _buildInlineNote(Colors.orange, "Amber"),
                          const SizedBox(height: 8),
                          _buildInlineNote(Colors.pinkAccent, "Rose"),
                          const SizedBox(height: 8),
                          _buildInlineNote(Colors.yellow, "Vanilla"),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // 5. قسم الأداء
                Row(
                  children: [
                    _buildPerformanceItem(Icons.access_time, "LONGEVITY:", "Long Lasting (8-10 hrs)"),
                    _buildPerformanceItem(Icons.wb_sunny_outlined, "SILLAGE:", "Strong"),
                  ],
                ),
                const SizedBox(height: 35),

                // 6. أزرار التفاعل المتجاوبة مع الـ Bloc (إضافة للسلة + شراء واتساب)
                BlocConsumer<CartCubit, CartStates>(
                  listener: (context, state) {
                    if (state is ProductAddedToCartSuccessState) {
                      // إظهار رسالة نجاح سفلية عند إضافة المنتج للفايربيز
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("تم إضافة العطر إلى سلتك بنجاح! 🛍️"),
                          backgroundColor: Color(0xFFC5A880),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        // 🔥 زرار إضافة إلى السلة
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent, 
                              foregroundColor: const Color(0xFFC5A880),
                              side: const BorderSide(color: Color(0xFFC5A880), width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 0,
                            ),
                            icon: state is CartLoadingState 
                                ? const SizedBox(
                                    width: 20, 
                                    height: 20, 
                                    child: CircularProgressIndicator(color: Color(0xFFC5A880), strokeWidth: 2),
                                  )
                                : const Icon(Icons.add_shopping_cart_rounded, size: 20),
                            label: const Text("ADD TO CART", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            onPressed: state is CartLoadingState 
                                ? null 
                                : () {
                                    context.read<CartCubit>().addProductToCart(
                                          productId: name, 
                                          productName: name,
                                          productPrice: price,
                                          productImage: "assets/images/perfume.png", // يمكنك تمرير مسار الصورة الفعلي لاحقاً
                                        );
                                  },
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // زرار الواتساب
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC5A880),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.chat_bubble_outline, size: 20),
                            label: const Text("ORDER NOW via WHATSAPP", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.pop(context);
                              WhatsAppHelper.open(productName: name, price: price);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineNote(Color dotColor, String noteName) {
    return Row(
      children: [
        Container(width: 7, height: 7, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
        const SizedBox(width: 10),
        Text(noteName, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildPerformanceItem(IconData icon, String title, String value) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFFC5A880), size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(color: Colors.grey[300], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}