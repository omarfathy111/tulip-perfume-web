import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CommentsSection extends StatefulWidget {
  final String productId;

  const CommentsSection({super.key, required this.productId});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _guestNameController = TextEditingController();
  double _userRating = 5.0;
  bool _isSubmitting = false;

  // 📝 دالة إرسال التعليق الذكية
  Future<void> _submitComment() async {
    final commentText = _commentController.text.trim();
    final currentUser = FirebaseAuth.instance.currentUser;

    if (commentText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('برجاء كتابة تعليقك أولاً')),
      );
      return;
    }

    // 🎯 تحديد الاسم والمصداقية تلقائياً بناءً على حالة تسجيل الدخول
    String finalUserName = 'زائر Tulip';
    bool isVerified = false;
    String userId = 'guest';

    if (currentUser != null) {
      // 1️⃣ اليوزر مسجل دخول
      finalUserName = currentUser.displayName ??
          (currentUser.email != null ? currentUser.email!.split('@')[0] : 'عميل Tulip VIP');
      isVerified = true;
      userId = currentUser.uid;
    } else {
      // 2️⃣ اليوزر زائر لم يسجل
      final guestInputName = _guestNameController.text.trim();
      if (guestInputName.isNotEmpty) {
        finalUserName = guestInputName;
      }
    }

    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .collection('comments')
          .add({
        'userId': userId,
        'userName': finalUserName,
        'comment': commentText,
        'rating': _userRating,
        'isVerifiedUser': isVerified, // شارة التوثيق
        'createdAt': FieldValue.serverTimestamp(),
      });

      _commentController.clear();
      _guestNameController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('شكراً لك! تم نشر تقييمك بنجاح ✨')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء الإرسال: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _guestNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final bool isLoggedIn = currentUser != null;

    // 🎯 التمييز بين تقييم الموقع العام وتقييم عطر خاص
    final bool isGeneralReview = widget.productId == 'general_tulip_landing';
    final String hintText = isGeneralReview
        ? 'اكتب تجربتك مع Tulip...'
        : 'اكتب تجربتك مع هذا العطر...';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF12100D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFC5A880).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🌸 العنوان
          const Row(
            children: [
              Icon(Icons.rate_review_outlined, color: Color(0xFFC5A880), size: 20),
              SizedBox(width: 8),
              Text(
                'آراء وتقييمات العملاء',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ✍️ فورم إضافة تعليق
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // إظهار طريقة التعليق بناءً على الحالة
                if (isLoggedIn)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC5A880).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFC5A880).withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded, color: Color(0xFFC5A880), size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'تعلق باسم: ${currentUser.displayName ?? currentUser.email?.split('@')[0]}',
                          style: const TextStyle(
                            color: Color(0xFFC5A880),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextField(
                      controller: _guestNameController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'اسمك (اختياري للزوار)',
                        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
                        filled: true,
                        fillColor: const Color(0xFF1A1714),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                // حقل التعليق (يتغير الـ Hint أوتوماتيكياً)
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF1A1714),
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // النجوم وزر الإرسال
                Row(
                  children: [
                    const Text('التقييم: ', style: TextStyle(color: Colors.white, fontSize: 12)),
                    Row(
                      children: List.generate(5, (index) {
                        return IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: Icon(
                            index < _userRating ? Icons.star_rounded : Icons.star_border_rounded,
                            color: const Color(0xFFC5A880),
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _userRating = index + 1.0;
                            });
                          },
                        );
                      }),
                    ),
                    const Spacer(),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC5A880),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: _isSubmitting ? null : _submitComment,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                            )
                          : const Text(
                              'إرسال',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // 💬 عرض التعليقات من Firestore
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('products')
                .doc(widget.productId)
                .collection('comments')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFC5A880)),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'لا توجد تعليقات بعد، كن أول من يشارك رأيه!',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ),
                );
              }

              final comments = snapshot.data!.docs;

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final data = comments[index].data() as Map<String, dynamic>;
                  final name = data['userName'] ?? 'عميل Tulip';
                  final comment = data['comment'] ?? '';
                  final rating = (data['rating'] ?? 5.0).toDouble();
                  final bool isVerified = data['isVerifiedUser'] ?? false;

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF181512),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            if (isVerified) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.verified_rounded, color: Color(0xFFC5A880), size: 14),
                            ],
                            const Spacer(),
                            Row(
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  starIndex < rating ? Icons.star_rounded : Icons.star_border_rounded,
                                  color: const Color(0xFFC5A880),
                                  size: 13,
                                );
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          comment,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 12,
                            height: 1.4,
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
    );
  }
}