import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tulip_for_perfume/features/home/presentation/widgets/comments_section.dart';
import 'home_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  // 🏷️ أقسام البراند الفاخرة
  final List<Map<String, dynamic>> categories = const [
    {
      'id': 'royal',
      'title': 'THE ROYAL OUD',
      'arabicTitle': 'المجموعة الملكية',
      'tag': 'BESTSELLER',
      'description': 'نفحات العود الكمبودي الفاخر والعنبر المعتق',
      'image': 'assets/images/perfume.png',
      'icon': Icons.stars_rounded,
    },
    {
      'title': 'MAISON DE ROSE',
      'arabicTitle': 'المجموعة النسائية',
      'tag': 'EXCLUSIVE',
      'description': 'عطور الزهور النادرة والورد البلغاري النقي',
      'image': 'assets/images/perfume.png',
      'icon': Icons.local_florist_rounded,
    },
    {
      'title': 'NOIR & LEATHER',
      'arabicTitle': 'المجموعة الرجالية',
      'tag': 'INTENSE',
      'description': 'جاذبية التبغ المعتق، الأخشاب والجلود الفاخرة',
      'image': 'assets/images/perfume.png',
      'icon': Icons.workspace_premium_rounded,
    },
    {
      'title': 'L\'EAU DE TULIP',
      'arabicTitle': 'المجموعة الصيفية',
      'tag': 'FRESH',
      'description': 'انتعاش أوراق الحمضيات ونسيم البحر الأبيض',
      'image': 'assets/images/perfume.png',
      'icon': Icons.wb_sunny_rounded,
    },
  ];

  // ✨ مميزات العلامة التجارية
  final List<Map<String, dynamic>> brandHighlights = const [
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

  // 💬 آراء العملاء
  final List<Map<String, String>> testimonials = const [
    {
      'name': 'الشيخ خالد آل سعود',
      'role': 'عميل نخبة',
      'comment': 'عطر THE ROYAL OUD أصبح توقيعي الشخصي. ثبات وفخامة لا تُضاهى.',
      'rating': '5.0',
    },
    {
      'name': 'سارة المعجل',
      'role': 'مؤثرة موضة',
      'comment': 'تجربة التغليف وحدها تكفي! عطور الزهور جودتها تقارع دور العطور العالمية في باريس.',
      'rating': '5.0',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFF070707),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1️⃣ 🎨 التدرج السينمائي الواضح (Cinematic Luxury Gradient)
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.6),
                radius: 1.2,
                colors: [
                  Color(0xFF231B10),
                  Color(0xFF100C07),
                  Color(0xFF050505),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),

          // 2️⃣ ✨ شبكة خطوط فاخرة (Luxury Geometric Mesh)
          CustomPaint(
            painter: _BackgroundGridPainter(),
          ),

          // 3️⃣ 🌟 بقعة ضوء ذهبية في الأعلى
          Positioned(
            top: -80,
            left: screenWidth * 0.5 - 175,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFC5A880).withOpacity(0.28),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // 4️⃣ المحتوى الرئيسي للشاشة
          SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  'T U L I P',
                  style: TextStyle(
                    color: Color(0xFFC5A880),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 9,
                  ),
                ),
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // ✨ قسم العناوين بستايل "Dior / Chanel"
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'HAUTE PARFUMERIE',
                            style: TextStyle(
                              color: Color(0xFFC5A880),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'THE CATEGORIES',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 40,
                            height: 1,
                            color: const Color(0xFFC5A880),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🛍️ شبكة الأقسام المتراصة
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 60.0 : 16.0,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          int crossAxisCount = 1;
                          if (constraints.maxWidth >= 1000) {
                            crossAxisCount = 4;
                          } else if (constraints.maxWidth >= 650) {
                            crossAxisCount = 2;
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: categories.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 25,
                              childAspectRatio: isDesktop ? 0.72 : 0.8,
                            ),
                            itemBuilder: (context, index) {
                              final item = categories[index];
                              return _buildCategoryCard(context, item);
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 60),

                    // 👑 كارت البانر الترويجي الفاخر
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 60.0 : 16.0,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(isDesktop ? 40 : 25),
                        decoration: BoxDecoration(
                          color: const Color(0xFF12100D).withOpacity(0.85),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFFC5A880).withOpacity(0.35),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Flex(
                          direction: isDesktop ? Axis.horizontal : Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: isDesktop
                              ? CrossAxisAlignment.center
                              : CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PRIVATE SELECTION',
                                  style: TextStyle(
                                    color: Color(0xFFC5A880),
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 3,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Discover The Signature Gift Box',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'مجموعة العينات الملكية الفاخرة متوفرة الآن للشحن المباشر.',
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            if (!isDesktop) const SizedBox(height: 25),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFC5A880),
                                side: const BorderSide(
                                  color: Color(0xFFC5A880),
                                  width: 1,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'EXPLORE COLLECTION',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 70),

                    // 💎 قسم مميزات البراند (Brand Highlights Section)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 60.0 : 16.0,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'WHY TULIP',
                            style: TextStyle(
                              color: Color(0xFFC5A880),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'تجربة العطور الاستثنائية',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 30),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              int count = constraints.maxWidth >= 800 ? 4 : 2;
                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: brandHighlights.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: count,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                  childAspectRatio: isDesktop ? 1.3 : 1.1,
                                ),
                                itemBuilder: (context, index) {
                                  final highlight = brandHighlights[index];
                                  return Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F0E0C),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: const Color(0xFFC5A880).withOpacity(0.15),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          highlight['icon'],
                                          color: const Color(0xFFC5A880),
                                          size: 30,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          highlight['title'],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          highlight['subtitle'],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 11,
                                            height: 1.3,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 70),

                 


                    // ✍️ قسم التعليقات التفاعلي المباشر (Interactive Comments Section)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 60.0 : 16.0,
                      ),
                      child: const CommentsSection(
                        productId: 'general_tulip_landing',
                      ),
                    ),

                    const SizedBox(height: 80),

                    // 🖤 الفوتر مع وصف كامل للموقع
                    Container(
                      width: double.infinity,
                      color: const Color(0xFF030303),
                      padding: const EdgeInsets.symmetric(
                        vertical: 50,
                        horizontal: 24,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'T U L I P',
                            style: TextStyle(
                              color: Color(0xFFC5A880),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 8,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'PARIS — CAIRO — RIYADH',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10,
                              letterSpacing: 4,
                            ),
                          ),
                          const SizedBox(height: 25),

                          // 📜 وصف الموقع والمؤسسة
                          SizedBox(
                            width: 700,
                            child: Text(
                              'دار TULIP للعطور هي وجهتك الفاخرة لاكتشاف أرقى العطور العالمية المصممة بأعلى معايير الجودة الفرنسية والشرقية. نجمع بين ندرة المكونات وأصالة التقاليد لنقدم لك مجموعات عطرية نادرة تعبر عن شخصيتك وتترك انطباعاً ملكياً لا يُنسى.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                                height: 1.8,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                          Container(
                            width: 60,
                            height: 1,
                            color: const Color(0xFFC5A880).withOpacity(0.3),
                          ),
                          const SizedBox(height: 25),

                          Text(
                            '© 2026 TULIP PERFUME. ALL RIGHTS RESERVED.',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔲 بناء بطاقات الكروت Rectangular Cards
  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> item) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF141210).withOpacity(0.85),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFFC5A880).withOpacity(0.18),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🏷️ الـ Tag العلوي
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['tag'],
                    style: const TextStyle(
                      color: Color(0xFFC5A880),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_outlined,
                    color: const Color(0xFFC5A880).withOpacity(0.6),
                    size: 16,
                  ),
                ],
              ),
            ),

            // 🖼️ مساحة الصورة
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    item['image'],
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      item['icon'],
                      size: 80,
                      color: const Color(0xFFC5A880),
                    ),
                  ),
                ),
              ),
            ),

            // 📝 تفاصيل الكارت Сفلية
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              color: const Color(0xFF0A0908),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['arabicTitle'],
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['description'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🎨 راسم شبكي خاص للخطوط الخلفية
class _BackgroundGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC5A880).withOpacity(0.035)
      ..strokeWidth = 1.0;

    const double step = 45.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 