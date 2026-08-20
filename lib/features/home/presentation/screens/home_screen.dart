import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/whatsapp_helper.dart';

import '../widgets/triangle_painter.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_states.dart';
import '../widgets/product_details_sheet.dart';
import '../widgets/comments_section.dart';

import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/cubit/cart_states.dart';
import '../../../cart/presentation/screens/cart_screen.dart';

class HomeScreen extends StatefulWidget {
  /// null = عرض كل المنتجات
  ///
  /// categoryId = عرض منتجات القسم فقط
  final String? categoryId;

  /// اسم القسم - اختياري
  final String? categoryTitle;

  const HomeScreen({
    super.key,
    this.categoryId,
    this.categoryTitle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _idleController;

  int _activeIndex = 0;

  bool _wheelLocked = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<CartCubit>().getCartProducts();
    });
  }

  // ============================================================
  // UPDATE CATEGORY
  // ============================================================

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.categoryId != widget.categoryId) {
      _activeIndex = 0;

      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }

      setState(() {});
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _pageController.dispose();
    _idleController.dispose();

    super.dispose();
  }

  // ============================================================
  // SAFE CATEGORY ID
  // ============================================================

  dynamic _getProductCategoryId(dynamic product) {
    // ------------------------------------------------------------
    // لو المنتج Map
    // ------------------------------------------------------------

    if (product is Map) {
      return product['categoryId'] ??
          product['category_id'] ??
          product['category'];
    }

    // ------------------------------------------------------------
    // لو الـ Model عنده toJson()
    // ------------------------------------------------------------

    try {
      final json = product.toJson();

      if (json is Map) {
        return json['categoryId'] ??
            json['category_id'] ??
            json['category'];
      }
    } catch (_) {
      // المنتج لا يحتوي على toJson
    }

    // ------------------------------------------------------------
    // محاولة قراءة categoryId لو موجود
    // ------------------------------------------------------------

    try {
      return product.categoryId;
    } catch (_) {
      return null;
    }
  }

  // ============================================================
  // FILTER PRODUCTS
  // ============================================================

  List<dynamic> _filterProducts(
    List<dynamic> products,
  ) {
    // ------------------------------------------------------------
    // لا يوجد Category
    // ------------------------------------------------------------

    if (widget.categoryId == null ||
        widget.categoryId!.trim().isEmpty) {
      return products;
    }

    final wantedCategoryId =
        widget.categoryId!.trim();

    final filtered = products.where((product) {
      final rawCategoryId =
          _getProductCategoryId(product);

      if (rawCategoryId == null) {
        return false;
      }

      return rawCategoryId
          .toString()
          .trim() ==
          wantedCategoryId;
    }).toList();

    return filtered;
  }

  // ============================================================
  // CURRENT PAGE
  // ============================================================

  double get _currentPage {
    if (!_pageController.hasClients) {
      return _activeIndex.toDouble();
    }

    if (!_pageController.position.haveDimensions) {
      return _activeIndex.toDouble();
    }

    return _pageController.page ??
        _activeIndex.toDouble();
  }

  // ============================================================
  // GO TO PAGE
  // ============================================================

  void _goToPage(
    int index,
    int total,
  ) {
    if (index < 0 || index >= total) {
      return;
    }

    if (!_pageController.hasClients) {
      return;
    }

    _pageController.animateToPage(
      index,
      duration: const Duration(
        milliseconds: 850,
      ),
      curve: Curves.easeInOutCubic,
    );
  }

  // ============================================================
  // MOUSE WHEEL
  // ============================================================

  void _handleMouseWheel(
    PointerScrollEvent event,
    int totalProducts,
  ) {
    if (_wheelLocked) return;

    final delta = event.scrollDelta.dy;

    if (delta.abs() < 8) return;

    _wheelLocked = true;

    if (delta > 0) {
      if (_activeIndex < totalProducts - 1) {
        _goToPage(
          _activeIndex + 1,
          totalProducts,
        );
      }
    } else {
      if (_activeIndex > 0) {
        _goToPage(
          _activeIndex - 1,
          totalProducts,
        );
      }
    }

    Future.delayed(
      const Duration(milliseconds: 750),
      () {
        if (mounted) {
          _wheelLocked = false;
        }
      },
    );
  }

  // ============================================================
  // PRODUCT VISUAL
  // ============================================================

  Widget _buildProductVisual({
    required String image,
    required int index,
    required bool desktop,
  }) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _pageController,
        _idleController,
      ]),
      builder: (context, child) {
        final page = _currentPage;

        final difference = page - index;
        final distance = difference.abs();

        final normalized = difference.clamp(
          -1.0,
          1.0,
        );

        // ========================================================
        // SCALE
        // ========================================================

        double scale;

        if (distance >= 1) {
          scale = 0.72;
        } else {
          scale = 1.0 - (distance * 0.28);
        }

        // ========================================================
        // MOVEMENT
        // ========================================================

        final horizontalMove =
            normalized *
                (desktop ? 170.0 : 80.0);

        final verticalMove =
            normalized.abs() *
                (desktop ? 35.0 : 25.0);

        // ========================================================
        // 3D
        // ========================================================

        final rotateY =
            normalized * 0.28;

        final rotateZ =
            normalized * 0.035;

        // ========================================================
        // DEPTH
        // ========================================================

        final depth = math.max(
          0.0,
          1 - distance,
        );

        final opacity =
            (1 - distance * 0.85)
                .clamp(0.0, 1.0);

        final blur =
            distance * 3.5;

        // ========================================================
        // IDLE FLOAT
        // ========================================================

        final idleWave = math.sin(
          _idleController.value *
              math.pi *
              2,
        );

        final idleY =
            depth *
                idleWave *
                (desktop ? 7.0 : 4.0);

        final idleRotation =
            depth *
                idleWave *
                0.006;

        // ========================================================
        // GOLD GLOW
        // ========================================================

        final glow =
            depth *
                (
                  0.12 +
                  ((idleWave + 1) / 2) *
                      0.06
                );

        return Opacity(
          opacity: opacity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ====================================================
              // GLOW
              // ====================================================

              IgnorePointer(
                child: Container(
                  width:
                      desktop ? 420 : 290,
                  height:
                      desktop ? 420 : 290,
                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color(
                          0xFFC5A880,
                        ).withOpacity(glow),
                        blurRadius: 110,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                ),
              ),

              // ====================================================
              // FLOOR SHADOW
              // ====================================================

              Positioned(
                bottom:
                    desktop ? 90 : 110,
                child: Opacity(
                  opacity: depth * 0.55,
                  child: Transform.scale(
                    scale: scale,
                    child: Container(
                      width:
                          desktop ? 260 : 180,
                      height: 30,
                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          100,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(
                              0.9,
                            ),
                            blurRadius: 40,
                            spreadRadius: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ====================================================
              // PRODUCT IMAGE
              // ====================================================

              Transform.translate(
                offset: Offset(
                  horizontalMove,
                  verticalMove + idleY,
                ),
                child: Transform(
                  alignment:
                      Alignment.center,
                  transform:
                      Matrix4.identity()
                        ..setEntry(
                          3,
                          2,
                          0.0018,
                        )
                        ..rotateY(
                          rotateY,
                        )
                        ..rotateZ(
                          rotateZ +
                              idleRotation,
                        ),
                  child: Transform.scale(
                    scale: scale,
                    child: ImageFiltered(
                      imageFilter:
                          ImageFilter.blur(
                        sigmaX: blur,
                        sigmaY: blur,
                      ),
                      child: Image.network(
                        image,
                        fit: BoxFit.contain,
                        filterQuality:
                            FilterQuality.high,
                        loadingBuilder:
                            (
                          context,
                          child,
                          loadingProgress,
                        ) {
                          if (loadingProgress ==
                              null) {
                            return child;
                          }

                          return const Center(
                            child:
                                CircularProgressIndicator(
                              color: Color(
                                0xFFC5A880,
                              ),
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder:
                            (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return const Icon(
                            Icons
                                .auto_awesome,
                            color: Color(
                              0xFFC5A880,
                            ),
                            size: 100,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // ====================================================
              // LIGHT
              // ====================================================

              if (depth > 0.75)
                IgnorePointer(
                  child: Transform.translate(
                    offset: Offset(
                      horizontalMove * 0.4,
                      verticalMove * 0.2,
                    ),
                    child: Container(
                      width:
                          desktop ? 300 : 190,
                      height:
                          desktop ? 460 : 300,
                      decoration:
                          BoxDecoration(
                        gradient:
                            LinearGradient(
                          begin:
                              Alignment.topLeft,
                          end: Alignment
                              .bottomRight,
                          colors: [
                            Colors.white
                                .withOpacity(
                              0.0,
                            ),
                            Colors.white
                                .withOpacity(
                              0.025,
                            ),
                            Colors.white
                                .withOpacity(
                              0.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // PRODUCT PAGE
  // ============================================================

  Widget _buildProductPage({
    required dynamic product,
    required int index,
    required bool desktop,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ========================================================
        // BACKGROUND
        // ========================================================

        AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            final difference =
                _currentPage - index;

            final backgroundMove =
                difference * 65.0;

            final backgroundScale =
                1.06 +
                    difference.abs() * 0.05;

            return Transform.translate(
              offset: Offset(
                backgroundMove,
                0,
              ),
              child: Transform.scale(
                scale: backgroundScale,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      filterQuality:
                          FilterQuality.low,
                      errorBuilder:
                          (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          color: const Color(
                            0xFF080808,
                          ),
                        );
                      },
                    ),
                    BackdropFilter(
                      filter:
                          ImageFilter.blur(
                        sigmaX: 30,
                        sigmaY: 30,
                      ),
                      child: Container(
                        color: Colors.black
                            .withOpacity(
                          0.50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // ========================================================
        // CINEMATIC GRADIENT
        // ========================================================

        IgnorePointer(
          child: Container(
            decoration:
                BoxDecoration(
              gradient:
                  LinearGradient(
                begin:
                    Alignment.topCenter,
                end:
                    Alignment.bottomCenter,
                colors: [
                  Colors.black
                      .withOpacity(0.10),
                  Colors.transparent,
                  Colors.black
                      .withOpacity(0.88),
                ],
                stops: const [
                  0.0,
                  0.45,
                  1.0,
                ],
              ),
            ),
          ),
        ),

        // ========================================================
        // PRODUCT
        // ========================================================

        _buildProductVisual(
          image: product.image,
          index: index,
          desktop: desktop,
        ),
      ],
    );
  }

  // ============================================================
  // DESKTOP
  // ============================================================

  Widget _buildDesktop({
    required List<dynamic> products,
  }) {
    final activeProduct =
        products[_activeIndex];

    return Row(
      children: [
        // ========================================================
        // LEFT
        // ========================================================

        Expanded(
          flex: 6,
          child: Listener(
            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                _handleMouseWheel(
                  event,
                  products.length,
                );
              }
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  controller:
                      _pageController,
                  scrollDirection:
                      Axis.vertical,
                  physics:
                      const BouncingScrollPhysics(),
                  itemCount:
                      products.length,
                  scrollBehavior:
                      ScrollConfiguration
                          .of(context)
                          .copyWith(
                    dragDevices: {
                      PointerDeviceKind
                          .touch,
                      PointerDeviceKind
                          .mouse,
                    },
                  ),
                  onPageChanged: (index) {
                    if (!mounted) return;

                    setState(() {
                      _activeIndex =
                          index;
                    });
                  },
                  itemBuilder:
                      (
                    context,
                    index,
                  ) {
                    return _buildProductPage(
                      product:
                          products[index],
                      index: index,
                      desktop: true,
                    );
                  },
                ),

                // ==================================================
                // VIGNETTE
                // ==================================================

                IgnorePointer(
                  child: Container(
                    decoration:
                        BoxDecoration(
                      gradient:
                          RadialGradient(
                        radius: 1.15,
                        colors: [
                          Colors.transparent,
                          Colors.black
                              .withOpacity(
                            0.65,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // BRAND
                // ==================================================

                const Positioned(
                  left: 35,
                  top: 105,
                  child: Text(
                    "TULIP",
                    style: TextStyle(
                      color:
                          Color(0xFFC5A880),
                      fontSize: 13,
                      fontWeight:
                          FontWeight.bold,
                      letterSpacing: 6,
                    ),
                  ),
                ),

                // ==================================================
                // COUNTER
                // ==================================================

                Positioned(
                  right: 35,
                  top: 100,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .end,
                    children: [
                      Text(
                        "${_activeIndex + 1}",
                        style:
                            const TextStyle(
                          color: Color(
                            0xFFC5A880,
                          ),
                          fontSize: 26,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      Text(
                        "/ ${products.length}",
                        style:
                            const TextStyle(
                          color:
                              Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // SCROLL HINT
                // ==================================================

                const Positioned(
                  left: 35,
                  bottom: 30,
                  child: Row(
                    children: [
                      Icon(
                        Icons
                            .mouse_outlined,
                        color: Color(
                          0xFFC5A880,
                        ),
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "SCROLL TO DISCOVER",
                        style: TextStyle(
                          color:
                              Colors.white70,
                          fontSize: 10,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // ========================================================
        // RIGHT
        // ========================================================

        Container(
          width: 450,
          color:
              const Color(0xFF101010),
          padding:
              const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 40,
          ),
          child: SafeArea(
            child: _buildDetails(
              activeProduct,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DETAILS
  // ============================================================

  Widget _buildDetails(
    dynamic product,
  ) {
    return ListView(
      key: ValueKey(product.id),
      physics:
          const BouncingScrollPhysics(),
      children: [
        const Text(
          "PREMIUM COLLECTION",
          style: TextStyle(
            color: Color(0xFFC5A880),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),

        const SizedBox(height: 18),

        Text(
          product.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          product.price,
          style: const TextStyle(
            color: Color(0xFFC5A880),
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          product.description,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 14,
            height: 1.7,
          ),
        ),

        const SizedBox(height: 35),

        const Text(
          "FRAGRANCE NOTES",
          style: TextStyle(
            color: Color(0xFFC5A880),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),

        const SizedBox(height: 18),

        Row(
          children: [
            SizedBox(
              width: 80,
              height: 70,
              child: CustomPaint(
                painter:
                    TrianglePainter(),
                child: const Center(
                  child: Text(
                    "PYRAMID",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 25),

            Expanded(
              child: Column(
                children: [
                  _buildWebNote(
                    Colors.orange,
                    "Amber • Warm & Rich",
                  ),
                  const SizedBox(height: 8),
                  _buildWebNote(
                    Colors.pinkAccent,
                    "Bulgarian Rose • Delicate",
                  ),
                  const SizedBox(height: 8),
                  _buildWebNote(
                    Colors.yellow,
                    "Black Vanilla • Sweet",
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 35),

        _buildCartButtons(product),

        const SizedBox(height: 40),

        CommentsSection(
          productId:
              product.id.toString(),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  // ============================================================
  // CART BUTTONS
  // ============================================================

  Widget _buildCartButtons(
    dynamic product,
  ) {
    return BlocConsumer<CartCubit, CartStates>(
      listener: (context, state) {
        if (state
            is ProductAddedToCartSuccessState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            const SnackBar(
              content: Text(
                "تم إضافة العطر إلى سلتك بنجاح! 🛍️",
              ),
              backgroundColor:
                  Color(0xFFC5A880),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading =
            state is CartLoadingState;

        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      const Color(
                    0xFFC5A880,
                  ),
                  side:
                      const BorderSide(
                    color: Color(
                      0xFFC5A880,
                    ),
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(
                            0xFFC5A880,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons
                            .add_shopping_cart_rounded,
                      ),
                label: const Text(
                  "ADD TO CART",
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        context
                            .read<
                                CartCubit>()
                            .addProductToCart(
                              productId:
                                  product.id,
                              productName:
                                  product.name,
                              productPrice:
                                  product.price,
                              productImage:
                                  product.image,
                            );
                      },
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFFC5A880,
                  ),
                  foregroundColor:
                      Colors.black,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons
                      .chat_bubble_outline,
                ),
                label: const Text(
                  "ORDER NOW VIA WHATSAPP",
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                onPressed: () {
                  WhatsAppHelper.open(
                    productName:
                        product.name,
                    price:
                        product.price,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // MOBILE
  // ============================================================

  Widget _buildMobile({
    required List<dynamic> products,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller:
              _pageController,
          scrollDirection:
              Axis.vertical,
          physics:
              const BouncingScrollPhysics(),
          itemCount:
              products.length,
          onPageChanged: (index) {
            if (!mounted) return;

            setState(() {
              _activeIndex = index;
            });
          },
          itemBuilder:
              (
            context,
            index,
          ) {
            final product =
                products[index];

            return Stack(
              fit: StackFit.expand,
              children: [
                _buildProductPage(
                  product: product,
                  index: index,
                  desktop: false,
                ),

                IgnorePointer(
                  child: Container(
                    decoration:
                        BoxDecoration(
                      gradient:
                          LinearGradient(
                        begin: Alignment
                            .topCenter,
                        end: Alignment
                            .bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black
                              .withOpacity(
                            0.92,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Positioned(
                  top: 70,
                  left: 25,
                  child: Text(
                    "TULIP PERFUME",
                    style: TextStyle(
                      color:
                          Color(0xFFC5A880),
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w600,
                      letterSpacing: 3,
                    ),
                  ),
                ),

                Positioned(
                  left: 22,
                  right: 22,
                  bottom: 35,
                  child:
                      _buildMobileInfo(
                    product,
                    context,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // MOBILE INFO
  // ============================================================

  Widget _buildMobileInfo(
    dynamic product,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          product.price,
          style: const TextStyle(
            color: Color(0xFFC5A880),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 18),

        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFFC5A880),
              foregroundColor:
                  Colors.black,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
              ),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor:
                    Colors.transparent,
                builder: (_) =>
                    ProductDetailsSheet(
                  productId:
                      product.id,
                  name: product.name,
                  price:
                      product.price,
                  description:
                      product.description,
                  image:
                      product.image,
                ),
              );
            },
            child: const Text(
              "VIEW DETAILS",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // WEB NOTE
  // ============================================================

  Widget _buildWebNote(
    Color color,
    String text,
  ) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration:
              BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color:
                    color.withOpacity(
                  0.65,
                ),
                blurRadius: 8,
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            text,
            style:
                const TextStyle(
              color:
                  Colors.white70,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final isDesktop =
        MediaQuery.of(context)
                .size
                .width >=
            900;

    return Scaffold(
      backgroundColor:
          const Color(0xFF080808),

      appBar: AppBar(
        automaticallyImplyLeading:
            false,
        backgroundColor:
            Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,

        title: isDesktop
            ? const Text(
                "TULIP PERFUME",
                style: TextStyle(
                  color:
                      Color(0xFFC5A880),
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                  letterSpacing: 4,
                ),
              )
            : null,

        actions: [
          BlocBuilder<CartCubit, CartStates>(
            builder: (context, state) {
              int cartCount = 0;

              if (state
                  is CartSuccessState) {
                cartCount =
                    state.cartItems.length;
              }

              return Padding(
                padding:
                    const EdgeInsets.only(
                  right: 15,
                ),
                child: Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons
                            .shopping_bag_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const CartScreen(),
                          ),
                        );
                      },
                    ),

                    if (cartCount > 0)
                      Positioned(
                        right: 3,
                        top: 3,
                        child: Container(
                          padding:
                              const EdgeInsets
                                  .all(4),
                          constraints:
                              const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          decoration:
                              const BoxDecoration(
                            color: Color(
                              0xFFC5A880,
                            ),
                            shape:
                                BoxShape.circle,
                          ),
                          child: Text(
                            '$cartCount',
                            textAlign:
                                TextAlign.center,
                            style:
                                const TextStyle(
                              color:
                                  Colors.black,
                              fontSize: 10,
                              fontWeight:
                                  FontWeight.bold,
                            ),
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
          // ========================================================
          // LOADING
          // ========================================================

          if (state is HomeLoadingState) {
            return const Center(
              child:
                  CircularProgressIndicator(
                color: Color(0xFFC5A880),
              ),
            );
          }

          // ========================================================
          // ERROR
          // ========================================================

          if (state is HomeErrorState) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.all(20),
                child: Text(
                  state.errorMessage,
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    color:
                        Colors.redAccent,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }

          // ========================================================
          // SUCCESS
          // ========================================================

          if (state is HomeSuccessState) {
            final allProducts =
                state.products;

            final products =
                _filterProducts(
              allProducts,
            );

            // ======================================================
            // EMPTY
            // ======================================================

            if (products.isEmpty) {
              return Center(
                child: Padding(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 25,
                  ),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons
                            .inventory_2_outlined,
                        color: Color(
                          0xFFC5A880,
                        ),
                        size: 50,
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      Text(
                        widget.categoryId ==
                                null
                            ? "لا توجد عطور متوفرة حالياً"
                            : "لا توجد عطور في قسم ${widget.categoryTitle ?? ''} حالياً",
                        textAlign:
                            TextAlign.center,
                        style:
                            const TextStyle(
                          color:
                              Colors.white70,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      if (widget.categoryId !=
                          null)
                        Text(
                          "Category ID: ${widget.categoryId}",
                          style:
                              const TextStyle(
                            color:
                                Colors.white24,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }

            // ======================================================
            // RESET INDEX
            // ======================================================

            if (_activeIndex >=
                products.length) {
              WidgetsBinding.instance
                  .addPostFrameCallback(
                (_) {
                  if (!mounted) return;

                  setState(() {
                    _activeIndex = 0;
                  });

                  if (_pageController
                      .hasClients) {
                    _pageController
                        .jumpToPage(0);
                  }
                },
              );

              return const SizedBox();
            }

            // ======================================================
            // DESKTOP
            // ======================================================

            if (isDesktop) {
              return _buildDesktop(
                products: products,
              );
            }

            // ======================================================
            // MOBILE
            // ======================================================

            return _buildMobile(
              products: products,
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}