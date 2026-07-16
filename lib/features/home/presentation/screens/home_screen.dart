import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui'; // مهم جداً عشان تأثير الـ Blur (الضباب) يشتغل
import '../../../../core/utils/whatsapp_helper.dart'; 
import '../widgets/triangle_painter.dart'; 
import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';
import '../widgets/product_details_sheet.dart';

// 🔥 الـ imports لربط السلة بالويب وشاشة السلة
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_states.dart';
import '../../../cart/presentation/screens/cart_screen.dart'; // 👈 استدعاء شاشة السلة

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeIndex = 0; 
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // 🔥 استدعاء السلة بأمان تام بعد التأكد من جاهزية وبناء كل ملفات الأبلكيشن والـ Widgets
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartCubit>().getCartProducts();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _scrollToPage(int targetIndex, int totalItems) {
    if (targetIndex >= 0 && targetIndex < totalItems) {
      _pageController.animateToPage(
        targetIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: isDesktop 
            ? const Text(
                "TULIP PERFUME",
                style: TextStyle(
                  color: Color(0xFFB5A378),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              )
            : null,
        actions: [
          // 🛍️ زرار الشنطة الذكي المطور (يعد ويراقب المنتجات لايف)
          BlocBuilder<CartCubit, CartStates>(
            builder: (context, state) {
              int cartCount = 0;
              if (state is CartSuccessState) {
                cartCount = state.cartItems.length;
              }

              return Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 28),
                      onPressed: () {
                        // الانتقال لشاشة السلة الفخمة
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CartScreen()),
                        );
                      },
                    ),
                    if (cartCount > 0)
                      Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFC5A880), // الدائرة الذهبية الفخمة
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFC5A880)),
            );
          } else if (state is HomeSuccessState) {
            final products = state.products;

            if (products.isEmpty) {
              return const Center(
                child: Text("لا توجد عطور متوفرة حالياً", style: TextStyle(color: Colors.white)),
              );
            }

            if (_activeIndex >= products.length) {
              _activeIndex = 0;
            }

            final activeProduct = products[_activeIndex];

            // 🌟 1. تصميم الويب والكمبيوتر الفخم (Split Screen)
            if (isDesktop) {
              return Row(
                children: [
                  // 👈 النصف الأيسر السينمائي المطور لمعالجة مقاسات الصور
                  Expanded(
                    flex: 6, 
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          scrollBehavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                            },
                          ),
                          onPageChanged: (index) {
                            setState(() {
                              _activeIndex = index;
                            });
                          },
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final imagePath = products[index].image;
                            
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                // أ. الطبقة الخلفية: صورة ممتدة ومغسولة بالكامل بالضباب (Blur)
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                                    child: Container(color: Colors.black.withOpacity(0.3)),
                                  ),
                                ),
                                // ب. الطبقة الأمامية: عرض زجاجة العطر بنسبها الحقيقية
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(40.0),
                                    child: Image.asset(
                                      imagePath,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        
                        // تدرج سينمائي فوق المنتج لتأمين تداخل ناعم مع الجهة اليمنى
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.black.withOpacity(0.2),
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),

                        // 🔼🔽 أزرار التقليب الفخمة
                        Positioned(
                          right: 30,
                          top: 0,
                          bottom: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Opacity(
                                opacity: _activeIndex > 0 ? 1.0 : 0.3,
                                child: FloatingActionButton.small(
                                  heroTag: "btnUp",
                                  backgroundColor: const Color(0xFFC5A880),
                                  foregroundColor: Colors.black,
                                  onPressed: () => _scrollToPage(_activeIndex - 1, products.length),
                                  child: const Icon(Icons.keyboard_arrow_up_rounded, size: 28),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "${_activeIndex + 1} / ${products.length}",
                                style: const TextStyle(
                                  color: Color(0xFFC5A880),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Opacity(
                                opacity: _activeIndex < products.length - 1 ? 1.0 : 0.3,
                                child: FloatingActionButton.small(
                                  heroTag: "btnDown",
                                  backgroundColor: const Color(0xFFC5A880),
                                  foregroundColor: Colors.black,
                                  onPressed: () => _scrollToPage(_activeIndex + 1, products.length),
                                  child: const Icon(Icons.keyboard_arrow_down_rounded, size: 28),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Positioned(
                          bottom: 30,
                          left: 30,
                          child: Row(
                            children: [
                              Icon(Icons.unfold_more_rounded, color: Color(0xFFC5A880), size: 20),
                              SizedBox(width: 8),
                              Text(
                                "DRAG OR USE BUTTONS TO EXPLORE",
                                style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  // 👉 النصف الأيمن: لوحة التفاصيل الثابتة للويب
                  Container(
                    width: 450,
                    color: const Color(0xFF111111),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "PREMIUM COLLECTION",
                            style: TextStyle(color: Color(0xFFB5A378), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 3),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            activeProduct.name,
                            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            activeProduct.price,
                            style: const TextStyle(color: Color(0xFFC5A880), fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 15),
                          
                          Text(
                            activeProduct.description,
                            style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.6),
                          ),
                          const SizedBox(height: 30),

                          const Text(
                            "FRAGRANCE NOTES",
                            style: TextStyle(color: Color(0xFFC5A880), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              SizedBox(
                                width: 80,
                                height: 70,
                                child: CustomPaint(
                                  painter: TrianglePainter(),
                                  child: const Center(
                                    child: Text("PYRAMID", style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 25),
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildWebNote(Colors.orange, "Amber (Warm & Rich)"),
                                    const SizedBox(height: 6),
                                    _buildWebNote(Colors.pinkAccent, "Bulgarian Rose (Delicate)"),
                                    const SizedBox(height: 6),
                                    _buildWebNote(Colors.yellow, "Black Vanilla (Sweet & Cozy)"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),

                          // 🔥 أزرار تفاعل الويب المتجاوبة (إضافة للسلة + شراء واتساب)
                          BlocConsumer<CartCubit, CartStates>(
                            listener: (context, state) {
                              if (state is ProductAddedToCartSuccessState) {
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
                                  // 1️⃣ زر إضافة للسلة الفخم (Web Outlined style)
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
                                      label: const Text("ADD TO CART", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                      onPressed: state is CartLoadingState
                                          ? null
                                          : () {
                                              context.read<CartCubit>().addProductToCart(
                                                    productId: activeProduct.name,
                                                    productName: activeProduct.name,
                                                    productPrice: activeProduct.price,
                                                    productImage: activeProduct.image,
                                                  );
                                            },
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  
                                  // 2️⃣ زر الواتساب الفخم للويب
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
                                      label: const Text(
                                        "ORDER NOW VIA WHATSAPP",
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
                                      ),
                                      onPressed: () {
                                        WhatsAppHelper.open(productName: activeProduct.name, price: activeProduct.price);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            // 📱 2. تصميم الموبايل الأنيق دون تعديل
            else {
              return PageView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final currentProduct = products[index];

                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(currentProduct.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.95),
                            ],
                            stops: const [0.0, 0.2, 0.6, 1.0],
                          ),
                        ),
                      ),
                      const Positioned(
                        top: 65,
                        left: 20,
                        child: Text(
                          "TULIP PERFUME",
                          style: TextStyle(color: Color(0xFFB5A378), fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 3),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentProduct.name,
                              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              currentProduct.price,
                              style: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC5A880),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => ProductDetailsSheet(
                                      name: currentProduct.name,
                                      price: currentProduct.price,
                                      description: currentProduct.description,
                                    ),
                                  );
                                },
                                child: const Text(
                                  "VIEW DETAILS",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          } else if (state is HomeErrorState) {
            return Center(
              child: Text(state.errorMessage, style: const TextStyle(color: Colors.redAccent, fontSize: 16)),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildWebNote(Color dotColor, String text) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ],
    );
  }
}