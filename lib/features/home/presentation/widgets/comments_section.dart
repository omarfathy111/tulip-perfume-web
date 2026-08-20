import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tulip_for_perfume/features/login/presntation/screens/login_screen.dart';

class CommentsSection extends StatefulWidget {
  final String productId;

  const CommentsSection({super.key, required this.productId});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _commentController = TextEditingController();

  double _userRating = 5.0;
  bool _isSubmitting = false;

  // ============================================================
  // إرسال التعليق
  // ============================================================
  Future<void> _submitComment() async {
    final commentText = _commentController.text.trim();
    final currentUser = FirebaseAuth.instance.currentUser;

    // ------------------------------------------------------------
    // التأكد من تسجيل الدخول
    // ------------------------------------------------------------
    if (currentUser == null) {
      _showLoginMessage();
      return;
    }

    // ------------------------------------------------------------
    // التأكد من كتابة التعليق
    // ------------------------------------------------------------
    if (commentText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('برجاء كتابة تعليقك أولاً')));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // ----------------------------------------------------------
      // تحديد اسم المستخدم
      // ----------------------------------------------------------
      String finalUserName;

      if (currentUser.displayName != null &&
          currentUser.displayName!.trim().isNotEmpty) {
        finalUserName = currentUser.displayName!.trim();
      } else if (currentUser.email != null &&
          currentUser.email!.trim().isNotEmpty) {
        finalUserName = currentUser.email!.split('@')[0];
      } else {
        finalUserName = 'عميل Tulip';
      }

      // ----------------------------------------------------------
      // إضافة التعليق إلى Firestore
      // ----------------------------------------------------------
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .collection('comments')
          .add({
            'userId': currentUser.uid,
            'userName': finalUserName,
            'comment': commentText,
            'rating': _userRating,
            'isVerifiedUser': true,
            'createdAt': FieldValue.serverTimestamp(),
          });

      // ----------------------------------------------------------
      // تنظيف الحقول
      // ----------------------------------------------------------
      _commentController.clear();

      setState(() {
        _userRating = 5.0;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('شكراً لك! تم نشر تقييمك بنجاح ✨')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء إرسال التقييم')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // ============================================================
  // رسالة تسجيل الدخول
  // ============================================================
  void _showLoginMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF12100D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: const Color(0xFFC5A880).withOpacity(0.25)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC5A880).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    color: Color(0xFFC5A880),
                    size: 27,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'تسجيل الدخول مطلوب',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'يجب تسجيل الدخول حتى تتمكن من إضافة تقييم أو تعليق.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 22),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC5A880),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Cancel
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'إلغاء',
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // بناء فورم التعليق للمستخدم المسجل
  // ============================================================
  Widget _buildCommentForm(User currentUser) {
    final String userName =
        currentUser.displayName != null &&
            currentUser.displayName!.trim().isNotEmpty
        ? currentUser.displayName!.trim()
        : currentUser.email != null
        ? currentUser.email!.split('@')[0]
        : 'عميل Tulip';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --------------------------------------------------------
          // المستخدم الحالي
          // --------------------------------------------------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFC5A880).withOpacity(0.10),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFFC5A880).withOpacity(0.20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xFFC5A880),
                  size: 15,
                ),
                const SizedBox(width: 7),
                Text(
                  'تعلق باسم: $userName',
                  style: const TextStyle(
                    color: Color(0xFFC5A880),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // --------------------------------------------------------
          // Comment Field
          // --------------------------------------------------------
          TextField(
            controller: _commentController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: widget.productId == 'general_tulip_landing'
                  ? 'اكتب تجربتك مع Tulip...'
                  : 'اكتب تجربتك مع هذا العطر...',
              hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
              filled: true,
              fillColor: const Color(0xFF1A1714),
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: Color(0xFFC5A880),
                  width: 1,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // --------------------------------------------------------
          // Rating + Submit
          // --------------------------------------------------------
          Row(
            children: [
              const Text(
                'التقييم:',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),

              const SizedBox(width: 6),

              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 22,
                      minHeight: 22,
                    ),
                    icon: Icon(
                      index < _userRating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: Colors.amber,
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

              // ----------------------------------------------------
              // Submit Button
              // ----------------------------------------------------
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC5A880),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: _isSubmitting ? null : _submitComment,
                child: _isSubmitting
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        'إرسال',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // بناء رسالة Guest
  // ============================================================
  Widget _buildGuestMessage() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFC5A880).withOpacity(0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.rate_review_outlined,
              color: Color(0xFFC5A880),
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'حابب تشاركنا رأيك؟',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'سجل دخولك لإضافة تقييم أو تعليق.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Login
          ElevatedButton(
            onPressed: _showLoginMessage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC5A880),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              'تسجيل الدخول',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // عرض التعليقات
  // ============================================================
  Widget _buildCommentsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        // --------------------------------------------------------
        // Loading
        // --------------------------------------------------------
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: Color(0xFFC5A880)),
            ),
          );
        }

        // --------------------------------------------------------
        // Error
        // --------------------------------------------------------
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'حدث خطأ أثناء تحميل التقييمات',
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ),
          );
        }

        // --------------------------------------------------------
        // Empty
        // --------------------------------------------------------
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

        // --------------------------------------------------------
        // Comments List
        // --------------------------------------------------------
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          separatorBuilder: (_, __) {
            return const SizedBox(height: 10);
          },
          itemBuilder: (context, index) {
            final data = comments[index].data() as Map<String, dynamic>;

            final String name = data['userName'] ?? 'عميل Tulip';

            final String comment = data['comment'] ?? '';

            final double rating = (data['rating'] ?? 5.0).toDouble();

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
                  // ------------------------------------------------
                  // User + Rating
                  // ------------------------------------------------
                  Row(
                    children: [
                      // User Name
                      Flexible(
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      // Verified icon
                      if (isVerified) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.verified_rounded,
                          color: Color(0xFFC5A880),
                          size: 14,
                        ),
                      ],

                      const Spacer(),

                      // Rating
                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            starIndex < rating
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: Colors.amber,
                            size: 13,
                          );
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // ------------------------------------------------
                  // Comment
                  // ------------------------------------------------
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
    );
  }

  // ============================================================
  // Dispose
  // ============================================================
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // ============================================================
  // Build
  // ============================================================
  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    final bool isLoggedIn = currentUser != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF12100D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC5A880).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========================================================
          // Title
          // ========================================================
          const Row(
            children: [
              Icon(
                Icons.rate_review_outlined,
                color: Color(0xFFC5A880),
                size: 20,
              ),
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

          // ========================================================
          // Comment Form / Login Message
          // ========================================================
          if (isLoggedIn)
            _buildCommentForm(currentUser)
          else
            _buildGuestMessage(),

          const SizedBox(height: 25),

          // ========================================================
          // Comments
          // ========================================================
          _buildCommentsList(),
        ],
      ),
    );
  }
}
