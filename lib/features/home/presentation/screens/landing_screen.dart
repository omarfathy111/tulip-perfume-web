import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tulip_for_perfume/features/home/presentation/widgets/comments_section.dart';
import 'home_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  // ============================================================
  // 🏷️ CATEGORIES
  // ============================================================

  static const List<Map<String, dynamic>> categories = [
    {
      'id': 'royal',
      'title': 'THE ROYAL OUD',
      'arabicTitle': 'المجموعة الملكية',
      'tag': 'BESTSELLER',
      'description': 'نفحات العود الكمبودي الفاخر والعنبر المعتق',
      'image': 'https://i.ibb.co/L5191S5/perfume.png',
      'icon': Icons.stars_rounded,
    },
    {
      'id': 'women',
      'title': 'MAISON DE ROSE',
      'arabicTitle': 'المجموعة النسائية',
      'tag': 'EXCLUSIVE',
      'description': 'عطور الزهور النادرة والورد البلغاري النقي',
      'image': 'https://i.ibb.co/L5191S5/perfume.png',
      'icon': Icons.local_florist_rounded,
    },
    {
      'id': 'men',
      'title': 'NOIR & LEATHER',
      'arabicTitle': 'المجموعة الرجالية',
      'tag': 'INTENSE',
      'description': 'جاذبية التبغ المعتق، الأخشاب والجلود الفاخرة',
      'image': 'https://i.ibb.co/L5191S5/perfume.png',
      'icon': Icons.workspace_premium_rounded,
    },
    {
      'id': 'summer',
      'title': "L'EAU DE TULIP",
      'arabicTitle': 'المجموعة الصيفية',
      'tag': 'FRESH',
      'description': 'انتعاش أوراق الحمضيات ونسيم البحر الأبيض',
      'image': 'https://i.ibb.co/L5191S5/perfume.png',
      'icon': Icons.wb_sunny_rounded,
    },
  ];

  // ============================================================
  // 💎 BRAND HIGHLIGHTS
  // ============================================================

  static const List<Map<String, dynamic>> brandHighlights = [
    {
      'icon': Icons.verified_outlined,
      'title': 'مكونات نادرة 100%',
      'subtitle': 'زيوت عطرية نقية معتقة ومستوردة مباشرة',
    },
    {
      'icon': Icons.local_shipping_outlined,
      'title': 'شحن ملكي سريع',
      'subtitle': 'تغليف آمن وفاخر يصلك أينما كنت',
    },
    {
      'icon': Icons.card_giftcard_outlined,
      'title': 'تغليف الإهداء الخاص',
      'subtitle': 'علب مخملية فاخرة مزودة بلمسات ذهبية',
    },
    {
      'icon': Icons.auto_awesome_outlined,
      'title': 'ثبات يدوم طويلاً',
      'subtitle': 'تركيز عالي يصل إلى Haute Parfumerie',
    },
  ];

  // ============================================================
  // 🎨 COLORS
  // ============================================================

  static const Color background = Color(0xFF070707);
  static const Color darkBackground = Color(0xFF030303);
  static const Color cardBackground = Color(0xFF141210);
  static const Color darkCard = Color(0xFF0A0908);
  static const Color gold = Color(0xFFC5A880);
  static const Color goldDark = Color(0xFF8E7652);

  // ============================================================
  // 🏠 BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final bool isDesktop = screenWidth >= 1100;
    final bool isTablet = screenWidth >= 650 && screenWidth < 1100;

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        children: [
          // ======================================================
          // 🌌 BACKGROUND
          // ======================================================

          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -0.6),
                  radius: 1.25,
                  colors: [
                    Color(0xFF231B10),
                    Color(0xFF100C07),
                    Color(0xFF050505),
                  ],
                  stops: [
                    0.0,
                    0.55,
                    1.0,
                  ],
                ),
              ),
            ),
          ),

          // ======================================================
          // ✨ BACKGROUND GRID
          // ======================================================

          const Positioned.fill(
            child: CustomPaint(
              painter: _BackgroundGridPainter(),
            ),
          ),

          // ======================================================
          // 🌟 GOLD LIGHT
          // ======================================================

          Positioned(
            top: -100,
            left: screenWidth / 2 - 180,
            child: IgnorePointer(
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: gold.withOpacity(0.20),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 100,
                    sigmaY: 100,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),

          // ======================================================
          // 📱 MAIN CONTENT
          // ======================================================

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context, isDesktop),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),

                        // ==================================================
                        // 👑 HERO / INTRO
                        // ==================================================

                        _buildHeroSection(
                          isDesktop: isDesktop,
                          isTablet: isTablet,
                        ),

                        const SizedBox(height: 55),

                        // ==================================================
                        // 🛍️ CATEGORIES
                        // ==================================================

                        _buildCategoriesSection(
                          context,
                          isDesktop: isDesktop,
                          isTablet: isTablet,
                        ),

                        const SizedBox(height: 80),

                        // ==================================================
                        // 🎁 PRIVATE SELECTION
                        // ==================================================

                        _buildPrivateSelection(
                          context,
                          isDesktop: isDesktop,
                          isTablet: isTablet,
                        ),

                        const SizedBox(height: 85),

                        // ==================================================
                        // 💎 WHY TULIP
                        // ==================================================

                        _buildHighlightsSection(
                          isDesktop: isDesktop,
                          isTablet: isTablet,
                        ),

                        const SizedBox(height: 90),

                        // ==================================================
                        // 💬 COMMENTS
                        // ==================================================

                        _buildCommentsSection(
                          isDesktop: isDesktop,
                        ),

                        const SizedBox(height: 90),

                        // ==================================================
                        // 🖤 FOOTER
                        // ==================================================

                        _buildFooter(
                          isDesktop: isDesktop,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 🔝 APP BAR
  // ============================================================

  Widget _buildAppBar(
    BuildContext context,
    bool isDesktop,
  ) {
    return Container(
      height: isDesktop ? 82 : 68,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 22,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.08),
        border: Border(
          bottom: BorderSide(
            color: gold.withOpacity(0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          // Left
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'HAUTE PARFUMERIE',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 9,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Logo
          const Text(
            'T U L I P',
            style: TextStyle(
              color: gold,
              fontSize: 21,
              fontWeight: FontWeight.bold,
              letterSpacing: 9,
            ),
          ),

          // Right
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: 'Explore Collection',
                onPressed: () {
                  _openHome(context);
                },
                icon: Icon(
                  Icons.arrow_forward,
                  color: gold.withOpacity(0.8),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 👑 HERO SECTION
  // ============================================================

  Widget _buildHeroSection({
    required bool isDesktop,
    required bool isTablet,
  }) {
    final double titleSize = isDesktop
        ? 58
        : isTablet
            ? 48
            : 34;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 20,
      ),
      child: Column(
        children: [
          Text(
            'HAUTE PARFUMERIE',
            style: TextStyle(
              color: gold,
              fontSize: isDesktop ? 13 : 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 5,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            'THE CATEGORIES',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: titleSize,
              fontWeight: FontWeight.w200,
              letterSpacing: isDesktop ? 6 : 3,
              height: 1.1,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: isDesktop ? 70 : 45,
            height: 1,
            color: gold,
          ),

          const SizedBox(height: 22),

          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 650,
            ),
            child: Text(
              'اكتشف عالم TULIP للعطور، حيث تلتقي المكونات النادرة '
              'بالتصميم الفاخر لتصنع تجربة عطرية استثنائية.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: isDesktop ? 14 : 12,
                height: 1.8,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 🛍️ CATEGORIES SECTION
  // ============================================================

  Widget _buildCategoriesSection(
    BuildContext context, {
    required bool isDesktop,
    required bool isTablet,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop
            ? 60
            : isTablet
                ? 35
                : 16,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: gold.withOpacity(0.15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  'COLLECTIONS',
                  style: TextStyle(
                    color: gold.withOpacity(0.8),
                    fontSize: 10,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: gold.withOpacity(0.15),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount;

              if (constraints.maxWidth >= 1050) {
                crossAxisCount = 4;
              } else if (constraints.maxWidth >= 650) {
                crossAxisCount = 2;
              } else {
                crossAxisCount = 1;
              }

              final double spacing = crossAxisCount == 1 ? 18 : 20;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio:
                      crossAxisCount == 1 ? 1.35 : 0.72,
                ),
                itemBuilder: (context, index) {
                  return _buildCategoryCard(
                    context,
                    categories[index],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 🛍️ CATEGORY CARD
  // ============================================================

  Widget _buildCategoryCard(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          _openHome(
            context,
            categoryId: item['id'],
            categoryTitle: item['title'],
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: cardBackground.withOpacity(0.88),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: gold.withOpacity(0.18),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // TOP
                // ==================================================

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    17,
                    16,
                    17,
                    10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['tag'],
                          style: const TextStyle(
                            color: gold,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: gold.withOpacity(0.55),
                        size: 16,
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // IMAGE
                // ==================================================

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.15),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Image.network(
                        item['image'],
                        fit: BoxFit.contain,
                        filterQuality: FilterQuality.high,
                        loadingBuilder:
                            (context, child, progress) {
                          if (progress == null) {
                            return child;
                          }

                          return const Center(
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: gold,
                                strokeWidth: 1.2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) {
                          return Center(
                            child: Icon(
                              item['icon'] ??
                                  Icons.auto_awesome,
                              size: 70,
                              color: gold.withOpacity(0.65),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // INFO
                // ==================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    17,
                    18,
                    19,
                  ),
                  color: darkCard,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.4,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        item['arabicTitle'],
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 9),

                      Text(
                        item['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 10.5,
                          height: 1.45,
                        ),
                      ),

                      const SizedBox(height: 13),

                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 1,
                            color: gold,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'EXPLORE',
                            style: TextStyle(
                              color: gold.withOpacity(0.8),
                              fontSize: 8,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 🎁 PRIVATE SELECTION
  // ============================================================

  Widget _buildPrivateSelection(
    BuildContext context, {
    required bool isDesktop,
    required bool isTablet,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop
            ? 60
            : isTablet
                ? 35
                : 16,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(
          isDesktop ? 42 : 26,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF12100D).withOpacity(0.9),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: gold.withOpacity(0.32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: isDesktop
            ? Row(
                children: [
                  Expanded(
                    child: _buildPrivateSelectionText(),
                  ),
                  const SizedBox(width: 40),
                  _buildExploreButton(context),
                ],
              )
            : Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _buildPrivateSelectionText(),
                  const SizedBox(height: 25),
                  _buildExploreButton(context),
                ],
              ),
      ),
    );
  }

  Widget _buildPrivateSelectionText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PRIVATE SELECTION',
          style: TextStyle(
            color: gold,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),

        const SizedBox(height: 11),

        const Text(
          'Discover The Signature Gift Box',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.8,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'مجموعة العينات الملكية الفاخرة متوفرة الآن '
          'للشحن المباشر.',
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildExploreButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        _openHome(context);
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: gold,
        side: const BorderSide(
          color: gold,
          width: 1,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 17,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'EXPLORE COLLECTION',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          SizedBox(width: 12),
          Icon(
            Icons.arrow_forward,
            size: 15,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 💎 WHY TULIP
  // ============================================================

  Widget _buildHighlightsSection({
    required bool isDesktop,
    required bool isTablet,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop
            ? 60
            : isTablet
                ? 35
                : 16,
      ),
      child: Column(
        children: [
          const Text(
            'WHY TULIP',
            style: TextStyle(
              color: gold,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 4,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'تجربة العطور الاستثنائية',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w300,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: 35,
            height: 1,
            color: gold.withOpacity(0.6),
          ),

          const SizedBox(height: 35),

          LayoutBuilder(
            builder: (context, constraints) {
              int count;

              if (constraints.maxWidth >= 1000) {
                count = 4;
              } else if (constraints.maxWidth >= 600) {
                count = 2;
              } else {
                count = 1;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                itemCount: brandHighlights.length,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: count,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio:
                      count == 1 ? 2.3 : 1.2,
                ),
                itemBuilder: (context, index) {
                  return _buildHighlightCard(
                    brandHighlights[index],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightCard(
    Map<String, dynamic> highlight,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0E0C),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: gold.withOpacity(0.14),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: gold.withOpacity(0.2),
              ),
            ),
            child: Icon(
              highlight['icon'],
              color: gold,
              size: 23,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  highlight['title'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  highlight['subtitle'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 💬 COMMENTS
  // ============================================================

  Widget _buildCommentsSection({
    required bool isDesktop,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 16,
      ),
      child: const CommentsSection(
        productId: 'general_tulip_landing',
      ),
    );
  }

  // ============================================================
  // 🖤 FOOTER
  // ============================================================

  Widget _buildFooter({
    required bool isDesktop,
  }) {
    return Container(
      width: double.infinity,
      color: darkBackground,
      padding: EdgeInsets.symmetric(
        vertical: 55,
        horizontal: isDesktop ? 60 : 24,
      ),
      child: Column(
        children: [
          const Text(
            'T U L I P',
            style: TextStyle(
              color: gold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
          ),

          const SizedBox(height: 13),

          Text(
            'PARIS — CAIRO — RIYADH',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 9,
              letterSpacing: 4,
            ),
          ),

          const SizedBox(height: 28),

          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: Text(
              'دار TULIP للعطور هي وجهتك الفاخرة لاكتشاف '
              'أرقى العطور العالمية المصممة بأعلى معايير '
              'الجودة الفرنسية والشرقية. نجمع بين ندرة '
              'المكونات وأصالة التقاليد لنقدم لك مجموعات '
              'عطرية نادرة تعبر عن شخصيتك وتترك انطباعاً '
              'ملكياً لا يُنسى.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                height: 1.9,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Container(
            width: 60,
            height: 1,
            color: gold.withOpacity(0.3),
          ),

          const SizedBox(height: 25),

          Text(
            '© 2026 TULIP PERFUME. ALL RIGHTS RESERVED.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 9,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 🚀 OPEN HOME
  // ============================================================

  void _openHome(
    BuildContext context, {
    String? categoryId,
    String? categoryTitle,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration:
            const Duration(milliseconds: 550),
        reverseTransitionDuration:
            const Duration(milliseconds: 400),
        pageBuilder:
            (context, animation, secondaryAnimation) {
          return HomeScreen(
            categoryId: categoryId,
            categoryTitle: categoryTitle,
          );
        },
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

// ================================================================
// 🎨 BACKGROUND GRID PAINTER
// ================================================================

class _BackgroundGridPainter extends CustomPainter {
  const _BackgroundGridPainter();

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = const Color(0xFFC5A880)
          .withOpacity(0.035)
      ..strokeWidth = 1;

    const double step = 45;

    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _BackgroundGridPainter oldDelegate,
  ) {
    return false;
  }
}