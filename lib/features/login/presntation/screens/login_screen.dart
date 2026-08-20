import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tulip_for_perfume/features/home/presentation/screens/landing_screen.dart';
import 'package:tulip_for_perfume/features/register/presentation/screens/register_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  // ============================================================
  // Google Login
  // ============================================================

  Future<void> _signInWithGoogle() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleAuthProvider provider = GoogleAuthProvider();

      provider.setCustomParameters({
        'prompt': 'select_account',
      });

      await FirebaseAuth.instance.signInWithPopup(provider);

      if (!mounted) return;

      // بعد تسجيل الدخول بـ Google
      // الانتقال مباشرة إلى LandingScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LandingScreen(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message = 'حدث خطأ أثناء تسجيل الدخول';

      switch (e.code) {
        case 'popup-closed-by-user':
          message = 'تم إغلاق نافذة تسجيل الدخول';
          break;

        case 'popup-blocked':
          message = 'المتصفح قام بمنع نافذة تسجيل الدخول';
          break;

        case 'account-exists-with-different-credential':
          message =
              'هذا البريد مرتبط بطريقة تسجيل دخول أخرى';
          break;

        case 'operation-not-allowed':
          message =
              'تسجيل الدخول باستخدام Google غير مفعل في Firebase';
          break;

        case 'network-request-failed':
          message =
              'تأكد من اتصالك بالإنترنت وحاول مرة أخرى';
          break;

        default:
          message =
              'حدث خطأ أثناء تسجيل الدخول. حاول مرة أخرى';
      }

      _showMessage(message);
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'حدث خطأ غير متوقع أثناء تسجيل الدخول',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // Email Login
  // ============================================================

  Future<void> _signInWithEmail() async {
    if (_isLoading) return;

    final String email =
        _emailController.text.trim();

    final String password =
        _passwordController.text.trim();

    if (email.isEmpty) {
      _showMessage(
        'برجاء إدخال البريد الإلكتروني',
      );
      return;
    }

    if (password.isEmpty) {
      _showMessage(
        'برجاء إدخال كلمة المرور',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      // بعد تسجيل الدخول بالإيميل
      // أيضًا نذهب إلى LandingScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LandingScreen(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'user-not-found':
          message =
              'لا يوجد حساب بهذا البريد الإلكتروني';
          break;

        case 'wrong-password':
        case 'invalid-credential':
          message =
              'البريد الإلكتروني أو كلمة المرور غير صحيحة';
          break;

        case 'invalid-email':
          message =
              'البريد الإلكتروني غير صحيح';
          break;

        case 'user-disabled':
          message =
              'هذا الحساب تم تعطيله';
          break;

        case 'too-many-requests':
          message =
              'محاولات كثيرة، حاول مرة أخرى لاحقًا';
          break;

        default:
          message =
              'حدث خطأ أثناء تسجيل الدخول';
      }

      _showMessage(message);
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'حدث خطأ غير متوقع',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // Forgot Password
  // ============================================================

  Future<void> _forgotPassword() async {
    final String email =
        _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage(
        'اكتب البريد الإلكتروني أولاً لإرسال رابط استعادة كلمة المرور',
      );
      return;
    }

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: email,
      );

      if (!mounted) return;

      _showMessage(
        'تم إرسال رابط استعادة كلمة المرور إلى بريدك 📩',
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      if (e.code == 'user-not-found') {
        _showMessage(
          'لا يوجد حساب مرتبط بهذا البريد',
        );
      } else if (e.code == 'invalid-email') {
        _showMessage(
          'البريد الإلكتروني غير صحيح',
        );
      } else {
        _showMessage(
          'حدث خطأ أثناء إرسال رابط الاستعادة',
        );
      }
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'حدث خطأ غير متوقع',
      );
    }
  }

  // ============================================================
  // Show Message
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 13,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF211D18),
      ),
    );
  }

  // ============================================================
  // Google Button
  // ============================================================

  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed:
            _isLoading ? null : _signInWithGoogle,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.white.withOpacity(0.15),
          ),
          backgroundColor:
              Colors.white.withOpacity(0.04),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            // Google Icon
            Container(
              width: 24,
              height: 24,
              decoration:
                  const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'G',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            const Text(
              'Continue with Google',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Text Field
  // ============================================================

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool password = false,
  }) {
    return TextField(
      controller: controller,
      obscureText:
          password ? _obscurePassword : false,
      keyboardType: password
          ? TextInputType.text
          : TextInputType.emailAddress,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
        ),

        prefixIcon: Icon(
          icon,
          color: const Color(0xFFC5A880),
          size: 19,
        ),

        suffixIcon: password
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscurePassword =
                        !_obscurePassword;
                  });
                },
                icon: Icon(
                  _obscurePassword
                      ? Icons
                          .visibility_off_outlined
                      : Icons
                          .visibility_outlined,
                  color: Colors.grey[600],
                  size: 19,
                ),
              )
            : null,

        filled: true,
        fillColor:
            const Color(0xFF181512),

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10),
          borderSide: BorderSide(
            color:
                Colors.white.withOpacity(0.06),
          ),
        ),

        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10),
          borderSide: BorderSide(
            color:
                Colors.white.withOpacity(0.06),
          ),
        ),

        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(10),
          borderSide:
              const BorderSide(
            color: Color(0xFFC5A880),
            width: 1,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0C0B09),

      body: Stack(
        children: [
          // ========================================================
          // Background
          // ========================================================

          Positioned.fill(
            child: Container(
              decoration:
                  const BoxDecoration(
                gradient:
                    RadialGradient(
                  center:
                      Alignment.topRight,
                  radius: 1.2,
                  colors: [
                    Color(0xFF211B14),
                    Color(0xFF0C0B09),
                  ],
                ),
              ),
            ),
          ),

          // ========================================================
          // Decorative Glow
          // ========================================================

          Positioned(
            top: -150,
            right: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration:
                  BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFFC5A880,
                ).withOpacity(0.05),
              ),
            ),
          ),

          // ========================================================
          // Back Button
          // ========================================================

          Positioned(
            top: 30,
            left: 30,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons
                    .arrow_back_rounded,
                color: Colors.white,
              ),
              tooltip: 'Back',
            ),
          ),

          // ========================================================
          // Main
          // ========================================================

          Center(
            child:
                SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 50,
              ),
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(
                  maxWidth: 430,
                ),
                child: Column(
                  children: [
                    // ==================================================
                    // Logo
                    // ==================================================

                    const Text(
                      'TULIP',
                      style: TextStyle(
                        color:
                            Color(0xFFC5A880),
                        fontSize: 34,
                        fontWeight:
                            FontWeight.w300,
                        letterSpacing: 8,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      'PERFUMES',
                      style: TextStyle(
                        color:
                            Colors.grey[600],
                        fontSize: 10,
                        letterSpacing: 5,
                      ),
                    ),

                    const SizedBox(
                      height: 45,
                    ),

                    // ==================================================
                    // Title
                    // ==================================================

                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      'Sign in to continue your journey',
                      style: TextStyle(
                        color:
                            Colors.grey[500],
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // ==================================================
                    // Login Card
                    // ==================================================

                    Container(
                      padding:
                          const EdgeInsets.all(
                        25,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            const Color(
                          0xFF12100D,
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                          16,
                        ),
                        border: Border.all(
                          color:
                              const Color(
                            0xFFC5A880,
                          ).withOpacity(
                            0.12,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors
                                .black
                                .withOpacity(
                              0.35,
                            ),
                            blurRadius: 40,
                            offset:
                                const Offset(
                              0,
                              20,
                            ),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // ==================================================
                          // Google
                          // ==================================================

                          _googleButton(),

                          const SizedBox(
                            height: 25,
                          ),

                          // ==================================================
                          // Divider
                          // ==================================================

                          Row(
                            children: [
                              Expanded(
                                child:
                                    Divider(
                                  color: Colors
                                      .white
                                      .withOpacity(
                                    0.08,
                                  ),
                                ),
                              ),

                              Padding(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  'OR',
                                  style:
                                      TextStyle(
                                    color: Colors
                                        .grey[600],
                                    fontSize: 11,
                                  ),
                                ),
                              ),

                              Expanded(
                                child:
                                    Divider(
                                  color: Colors
                                      .white
                                      .withOpacity(
                                    0.08,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          // ==================================================
                          // Email
                          // ==================================================

                          _textField(
                            controller:
                                _emailController,
                            hint:
                                'Email address',
                            icon: Icons
                                .email_outlined,
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          // ==================================================
                          // Password
                          // ==================================================

                          _textField(
                            controller:
                                _passwordController,
                            hint:
                                'Password',
                            icon: Icons
                                .lock_outline_rounded,
                            password: true,
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                          // ==================================================
                          // Forgot Password
                          // ==================================================

                          Align(
                            alignment:
                                Alignment
                                    .centerRight,
                            child:
                                TextButton(
                              onPressed:
                                  _isLoading
                                      ? null
                                      : _forgotPassword,
                              child:
                                  const Text(
                                'Forgot password?',
                                style:
                                    TextStyle(
                                  color:
                                      Color(
                                    0xFFC5A880,
                                  ),
                                  fontSize:
                                      12,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          // ==================================================
                          // Sign In Button
                          // ==================================================

                          SizedBox(
                            width:
                                double.infinity,
                            height: 52,
                            child:
                                ElevatedButton(
                              onPressed:
                                  _isLoading
                                      ? null
                                      : _signInWithEmail,
                              style:
                                  ElevatedButton
                                      .styleFrom(
                                backgroundColor:
                                    const Color(
                                  0xFFC5A880,
                                ),
                                foregroundColor:
                                    Colors
                                        .black,
                                elevation: 0,
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    10,
                                  ),
                                ),
                              ),
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                          width:
                                              20,
                                          height:
                                              20,
                                          child:
                                              CircularProgressIndicator(
                                            strokeWidth:
                                                2,
                                            color:
                                                Colors.black,
                                          ),
                                        )
                                      : const Text(
                                          'SIGN IN',
                                          style:
                                              TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            letterSpacing:
                                                1.5,
                                            fontSize:
                                                13,
                                          ),
                                        ),
                            ),
                          ),

                          const SizedBox(
                            height: 22,
                          ),

                          // ==================================================
                          // Create Account
                          // ==================================================

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style:
                                    TextStyle(
                                  color: Colors
                                      .grey[600],
                                  fontSize:
                                      12,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                 Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        ),
        (route) => false,
      );
                                },
                                child:
                                    const Text(
                                  'Create Account',
                                  style:
                                      TextStyle(
                                    color:
                                        Color(
                                      0xFFC5A880,
                                    ),
                                    fontSize:
                                        12,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    // ==================================================
                    // Continue as Guest
                    // ==================================================

                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: Text(
                        'Continue as Guest',
                        style: TextStyle(
                          color:
                              Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    // ==================================================
                    // Terms
                    // ==================================================

                    Text(
                      'By continuing, you agree to our Terms & Privacy Policy',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color:
                            Colors.grey[700],
                        fontSize: 10,
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

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}