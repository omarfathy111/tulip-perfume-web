import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tulip_for_perfume/features/home/presentation/screens/landing_screen.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // ============================================================
  // Register
  // ============================================================

  Future<void> _register() async {
    if (_isLoading) return;

    final String name =
        _nameController.text.trim();

    final String email =
        _emailController.text.trim();

    final String password =
        _passwordController.text.trim();

    final String confirmPassword =
        _confirmPasswordController.text.trim();

    // ------------------------------------------------------------
    // Validation
    // ------------------------------------------------------------

    if (name.isEmpty) {
      _showMessage('برجاء إدخال اسمك');
      return;
    }

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

    if (password.length < 6) {
      _showMessage(
        'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      _showMessage(
        'برجاء تأكيد كلمة المرور',
      );
      return;
    }

    if (password != confirmPassword) {
      _showMessage(
        'كلمتا المرور غير متطابقتين',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ----------------------------------------------------------
      // Create Firebase Account
      // ----------------------------------------------------------

      final UserCredential credential =
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ----------------------------------------------------------
      // Get User
      // ----------------------------------------------------------

      final User? user = credential.user;

      if (user != null) {
        // حفظ اسم المستخدم داخل Firebase Auth
        await user.updateDisplayName(name);

        // تحديث بيانات المستخدم
        await user.reload();
      }

      if (!mounted) return;

      // ----------------------------------------------------------
      // Go To Landing Screen
      // ----------------------------------------------------------

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LandingScreen(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message =
          'حدث خطأ أثناء إنشاء الحساب';

      switch (e.code) {
        case 'weak-password':
          message =
              'كلمة المرور ضعيفة جدًا';
          break;

        case 'email-already-in-use':
          message =
              'هذا البريد الإلكتروني مستخدم بالفعل';
          break;

        case 'invalid-email':
          message =
              'البريد الإلكتروني غير صحيح';
          break;

        case 'operation-not-allowed':
          message =
              'تسجيل الحساب بالبريد الإلكتروني غير مفعل في Firebase';
          break;

        case 'network-request-failed':
          message =
              'تأكد من اتصالك بالإنترنت وحاول مرة أخرى';
          break;

        default:
          message =
              'حدث خطأ أثناء إنشاء الحساب';
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
        backgroundColor:
            const Color(0xFF211D18),
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
    bool confirmPassword = false,
  }) {
    bool obscure = false;

    if (password) {
      obscure = confirmPassword
          ? _obscureConfirmPassword
          : _obscurePassword;
    }

    return TextField(
      controller: controller,
      obscureText: obscure,
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
                    if (confirmPassword) {
                      _obscureConfirmPassword =
                          !_obscureConfirmPassword;
                    } else {
                      _obscurePassword =
                          !_obscurePassword;
                    }
                  });
                },
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey[600],
                  size: 19,
                ),
              )
            : null,

        filled: true,
        fillColor: const Color(0xFF181512),

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
          // Glow
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
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
            ),
          ),

          // ========================================================
          // Main
          // ========================================================

          Center(
            child: SingleChildScrollView(
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
                      'Create Account',
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
                      'Create your Tulip account',
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
                    // Card
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
                          // Name
                          // ==================================================

                          _textField(
                            controller:
                                _nameController,
                            hint:
                                'Full name',
                            icon:
                                Icons.person_outline_rounded,
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          // ==================================================
                          // Email
                          // ==================================================

                          _textField(
                            controller:
                                _emailController,
                            hint:
                                'Email address',
                            icon:
                                Icons.email_outlined,
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
                            icon:
                                Icons.lock_outline_rounded,
                            password: true,
                          ),

                          const SizedBox(
                            height: 14,
                          ),

                          // ==================================================
                          // Confirm Password
                          // ==================================================

                          _textField(
                            controller:
                                _confirmPasswordController,
                            hint:
                                'Confirm password',
                            icon:
                                Icons.lock_outline_rounded,
                            password: true,
                            confirmPassword: true,
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          // ==================================================
                          // Register Button
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
                                      : _register,
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
                                          'CREATE ACCOUNT',
                                          style:
                                              TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            letterSpacing:
                                                1.3,
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
                          // Already Have Account
                          // ==================================================

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              Text(
                                'Already have an account? ',
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
                                  Navigator.pop(
                                    context,
                                  );
                                },
                                child:
                                    const Text(
                                  'Sign In',
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
                    // Guest
                    // ==================================================

                    TextButton(
                      onPressed: () {
                        Navigator
                            .pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const LandingScreen(),
                          ),
                          (route) => false,
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

                    Text(
                      'By creating an account, you agree to our Terms & Privacy Policy',
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }
}