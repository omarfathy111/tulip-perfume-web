import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // ============================================================
  // IMGBB
  // ============================================================

  static const String _imgBbApiKey =
      '8260f4269a4e741e52e5cf41ad99a1da';

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _priceController =
      TextEditingController();

  final TextEditingController _descriptionController =
      TextEditingController();

  // ============================================================
  // CATEGORIES
  //
  // مهم:
  // categoryId هو اللي بيتخزن في المنتج.
  // categoryName للعرض فقط.
  // ============================================================

  final List<Map<String, String>> _categories = [
    {
      'id': 'men',
      'name': 'المجموعة الرجالية',
    },
    {
      'id': 'women',
      'name': 'المجموعة النسائية',
    },
    {
      'id': 'royal',
      'name': 'المجموعة الملكية',
    },
    {
      'id': 'summer',
      'name': 'المجموعة الصيفية',
    },
  ];

  String _selectedCategoryId = 'men';

  // ============================================================
  // IMAGE
  // ============================================================

  Uint8List? _selectedImageBytes;
  String? _imageName;

  bool _isLoading = false;

  // ============================================================
  // GET SELECTED CATEGORY
  // ============================================================

  Map<String, String> get _selectedCategory {
    return _categories.firstWhere(
      (category) => category['id'] == _selectedCategoryId,
      orElse: () => _categories.first,
    );
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (image == null) return;

      final bytes = await image.readAsBytes();

      if (!mounted) return;

      setState(() {
        _selectedImageBytes = bytes;
        _imageName = image.name;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'تعذر اختيار الصورة: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // UPLOAD IMAGE TO IMGBB
  // ============================================================

  Future<String?> _uploadImageToImgBB(
    Uint8List imageBytes,
  ) async {
    try {
      final Uri url = Uri.parse(
        'https://api.imgbb.com/1/upload?key=$_imgBbApiKey',
      );

      final request = http.MultipartRequest(
        'POST',
        url,
      );

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: _imageName ?? 'perfume.jpg',
        ),
      );

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 50),
        onTimeout: () {
          throw Exception(
            'انتهت مهلة رفع الصورة، حاول مرة أخرى.',
          );
        },
      );

      final response =
          await http.Response.fromStream(
        streamedResponse,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(response.body);

        final String? imageUrl =
            data['data']?['url'];

        if (imageUrl != null &&
            imageUrl.isNotEmpty) {
          return imageUrl;
        }
      }

      debugPrint(
        'ImgBB Error: ${response.body}',
      );

      return null;
    } catch (e) {
      debugPrint(
        'ImgBB Upload Exception: $e',
      );

      return null;
    }
  }

  // ============================================================
  // SAVE PRODUCT
  // ============================================================

  Future<void> _uploadAndSaveProduct() async {
    final String name =
        _nameController.text.trim();

    final String price =
        _priceController.text.trim();

    final String description =
        _descriptionController.text.trim();

    // ------------------------------------------------------------
    // VALIDATION
    // ------------------------------------------------------------

    if (name.isEmpty ||
        price.isEmpty ||
        description.isEmpty ||
        _selectedImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF1A1815),
          content: Text(
            'برجاء كتابة كافة البيانات واختيار صورة للبرفان',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // ----------------------------------------------------------
      // UPLOAD IMAGE
      // ----------------------------------------------------------

      final String? imageUrl =
          await _uploadImageToImgBB(
        _selectedImageBytes!,
      );

      if (imageUrl == null) {
        throw Exception(
          'فشل رفع الصورة إلى ImgBB',
        );
      }

      // ----------------------------------------------------------
      // CATEGORY DATA
      // ----------------------------------------------------------

      final String categoryId =
          _selectedCategory['id']!;

      final String categoryName =
          _selectedCategory['name']!;

      // ----------------------------------------------------------
      // FIRESTORE
      //
      // أهم جزء هنا:
      //
      // categoryId
      // category
      // categoryName
      //
      // بنحفظ التلاتة لضمان التوافق مع أي كود قديم.
      // ----------------------------------------------------------

      final DocumentReference productRef =
          await FirebaseFirestore.instance
              .collection('products')
              .add({
        'name': name,
        'price': price,
        'description': description,

        // ID القسم المستخدم في الفلترة
        'categoryId': categoryId,

        // الاسم القديم للتوافق
        'category': categoryName,

        // اسم واضح للقسم
        'categoryName': categoryName,

        'image': imageUrl,

        'createdAt':
            FieldValue.serverTimestamp(),
      });

      debugPrint(
        '✅ Product added successfully',
      );

      debugPrint(
        'Product ID: ${productRef.id}',
      );

      debugPrint(
        'Category ID: $categoryId',
      );

      debugPrint(
        'Category Name: $categoryName',
      );

      // ----------------------------------------------------------
      // CLEAR FORM
      // ----------------------------------------------------------

      _nameController.clear();
      _priceController.clear();
      _descriptionController.clear();

      if (!mounted) return;

      setState(() {
        _selectedImageBytes = null;
        _imageName = null;
        _selectedCategoryId = _categories.first['id']!;
      });

      // ----------------------------------------------------------
      // SUCCESS
      // ----------------------------------------------------------

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              const Color(0xFFC5A880),
          content: Text(
            'تم نشر "$name" في $categoryName بنجاح ✨',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint(
        '❌ Save Product Error: $e',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'حدث خطأ أثناء حفظ المنتج:\n$e',
          ),
        ),
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
  // DELETE PRODUCT
  // ============================================================

  Future<void> _deleteProduct(
    String docId,
    String productName,
  ) async {
    final bool? confirm =
        await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF141210),
          title: const Text(
            'تأكيد الحذف',
            style: TextStyle(
              color: Color(0xFFC5A880),
            ),
          ),
          content: Text(
            'هل أنت متأكد من حذف عطر "$productName" من المتجر؟',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  false,
                );
              },
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.redAccent,
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                  true,
                );
              },
              child: const Text(
                'حذف',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(docId)
          .delete();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor:
              Colors.redAccent,
          content: Text(
            'تم حذف عطر "$productName" بنجاح',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء الحذف: $e',
          ),
        ),
      );
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF070707),

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(
        title: const Text(
          'TULIP — لوحة التحكم والإدارة',
          style: TextStyle(
            color: Color(0xFFC5A880),
            letterSpacing: 2,
          ),
        ),
        backgroundColor:
            const Color(0xFF12100D),
        elevation: 0,
      ),

      // ==========================================================
      // BODY
      // ==========================================================

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(24),

        child: Center(
          child: SizedBox(
            width: 750,

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // ==================================================
                // ADD PRODUCT CARD
                // ==================================================

                Container(
                  padding:
                      const EdgeInsets.all(28),

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(0xFF141210),
                    borderRadius:
                        BorderRadius.circular(16),
                    border:
                        Border.all(
                      color:
                          const Color(0xFFC5A880)
                              .withOpacity(0.3),
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      const Text(
                        'إضافة عطر جديد',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        'اختر صورة العطر والقسم واكتب التفاصيل وسيتم النشر في المتجر مباشرة.',
                        style: TextStyle(
                          color:
                              Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      // ==================================================
                      // NAME
                      // ==================================================

                      TextField(
                        controller:
                            _nameController,
                        style:
                            const TextStyle(
                          color: Colors.white,
                        ),
                        decoration:
                            _inputDecoration(
                          'اسم العطر (مثال: ROYAL OUD)',
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      // ==================================================
                      // CATEGORY
                      // ==================================================

                      DropdownButtonFormField<
                          String>(
                        value:
                            _selectedCategoryId,

                        dropdownColor:
                            const Color(
                                0xFF141210),

                        style:
                            const TextStyle(
                          color: Colors.white,
                        ),

                        decoration:
                            _inputDecoration(
                          'اختر قسم العطر',
                        ),

                        items:
                            _categories.map(
                          (
                            category,
                          ) {
                            return DropdownMenuItem<
                                String>(
                              value:
                                  category['id'],

                              child: Text(
                                category['name']!,
                                style:
                                    const TextStyle(
                                  color:
                                      Color(
                                    0xFFC5A880,
                                  ),
                                ),
                              ),
                            );
                          },
                        ).toList(),

                        onChanged:
                            _isLoading
                                ? null
                                : (
                                    value,
                                  ) {
                                    if (value ==
                                        null) {
                                      return;
                                    }

                                    setState(
                                      () {
                                        _selectedCategoryId =
                                            value;
                                      },
                                    );
                                  },
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      // ==================================================
                      // SHOW CATEGORY ID
                      // ==================================================

                      Text(
                        'Category ID: $_selectedCategoryId',
                        style:
                            TextStyle(
                          color:
                              Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      // ==================================================
                      // PRICE
                      // ==================================================

                      TextField(
                        controller:
                            _priceController,
                        style:
                            const TextStyle(
                          color: Colors.white,
                        ),
                        decoration:
                            _inputDecoration(
                          'السعر (مثال: 850 EGP)',
                        ),
                      ),

                      const SizedBox(
                        height: 16,
                      ),

                      // ==================================================
                      // DESCRIPTION
                      // ==================================================

                      TextField(
                        controller:
                            _descriptionController,
                        maxLines: 3,
                        style:
                            const TextStyle(
                          color: Colors.white,
                        ),
                        decoration:
                            _inputDecoration(
                          'وصف العطر ومكوناته...',
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // ==================================================
                      // IMAGE PICKER
                      // ==================================================

                      OutlinedButton.icon(
                        style:
                            OutlinedButton.styleFrom(
                          foregroundColor:
                              const Color(
                            0xFFC5A880,
                          ),
                          side:
                              const BorderSide(
                            color:
                                Color(
                              0xFFC5A880,
                            ),
                          ),
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                        ),

                        onPressed:
                            _isLoading
                                ? null
                                : _pickImage,

                        icon:
                            const Icon(
                          Icons
                              .add_photo_alternate_outlined,
                        ),

                        label: Text(
                          _imageName ??
                              'اختر صورة البرفان من جهازي',
                        ),
                      ),

                      // ==================================================
                      // IMAGE PREVIEW
                      // ==================================================

                      if (_selectedImageBytes !=
                          null) ...[
                        const SizedBox(
                          height: 12,
                        ),

                        ClipRRect(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            8,
                          ),
                          child:
                              Image.memory(
                            _selectedImageBytes!,
                            height: 130,
                            width:
                                double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],

                      const SizedBox(
                        height: 30,
                      ),

                      // ==================================================
                      // SAVE BUTTON
                      // ==================================================

                      SizedBox(
                        width:
                            double.infinity,
                        height: 52,

                        child:
                            ElevatedButton(
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
                                  BorderRadius
                                      .circular(
                                10,
                              ),
                            ),
                          ),

                          onPressed:
                              _isLoading
                                  ? null
                                  : _uploadAndSaveProduct,

                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child:
                                      CircularProgressIndicator(
                                    color:
                                        Colors.black,
                                    strokeWidth:
                                        2,
                                  ),
                                )
                              : const Text(
                                  'حفظ ونشر البرفان بالمتجر',
                                  style:
                                      TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    fontSize: 15,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                // ==================================================
                // PRODUCTS TITLE
                // ==================================================

                const Text(
                  'العطور المعروضة بالمتجر حالياً',
                  style: TextStyle(
                    color:
                        Color(0xFFC5A880),
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                // ==================================================
                // PRODUCTS
                // ==================================================

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore
                      .instance
                      .collection(
                          'products')
                      .orderBy(
                        'createdAt',
                        descending:
                            true,
                      )
                      .snapshots(),

                  builder:
                      (
                    context,
                    snapshot,
                  ) {
                    if (snapshot
                            .connectionState ==
                        ConnectionState
                            .waiting) {
                      return const Center(
                        child:
                            CircularProgressIndicator(
                          color:
                              Color(
                            0xFFC5A880,
                          ),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Container(
                        padding:
                            const EdgeInsets
                                .all(
                          20,
                        ),
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFF141210,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            12,
                          ),
                        ),
                        child: Text(
                          'حدث خطأ في تحميل المنتجات:\n${snapshot.error}',
                          style:
                              const TextStyle(
                            color:
                                Colors.redAccent,
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs
                            .isEmpty) {
                      return Container(
                        padding:
                            const EdgeInsets
                                .all(
                          20,
                        ),
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFF141210,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            12,
                          ),
                        ),
                        child:
                            const Center(
                          child: Text(
                            'لا توجد عطور متوفرة حالياً في المتجر.',
                            style:
                                TextStyle(
                              color:
                                  Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }

                    final docs =
                        snapshot.data!.docs;

                    return ListView
                        .separated(
                      shrinkWrap:
                          true,

                      physics:
                          const NeverScrollableScrollPhysics(),

                      itemCount:
                          docs.length,

                      separatorBuilder:
                          (
                        _,
                        __,
                      ) =>
                              const SizedBox(
                        height: 12,
                      ),

                      itemBuilder:
                          (
                        context,
                        index,
                      ) {
                        final doc =
                            docs[index];

                        final data =
                            doc.data()
                                as Map<
                                    String,
                                    dynamic>;

                        final String
                            docId =
                            doc.id;

                        final String
                            name =
                            data['name']
                                    ?.toString() ??
                                '';

                        final String
                            price =
                            data['price']
                                    ?.toString() ??
                                '';

                        final String
                            categoryName =
                            data['categoryName']
                                    ?.toString() ??
                                data['category']
                                    ?.toString() ??
                                'عام';

                        final String
                            categoryId =
                            data['categoryId']
                                    ?.toString() ??
                                'غير محدد';

                        final String
                            image =
                            data['image']
                                    ?.toString() ??
                                '';

                        return Container(
                          padding:
                              const EdgeInsets
                                  .all(
                            12,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFF141210,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              10,
                            ),
                            border:
                                Border.all(
                              color: Colors
                                  .white
                                  .withOpacity(
                                0.08,
                              ),
                            ),
                          ),

                          child:
                              ListTile(
                            leading:
                                ClipRRect(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                6,
                              ),
                              child:
                                  Image.network(
                                image,
                                width: 50,
                                height: 50,
                                fit: BoxFit
                                    .cover,
                                errorBuilder:
                                    (
                                  _,
                                  __,
                                  ___,
                                ) =>
                                        const Icon(
                                  Icons
                                      .local_florist,
                                  color:
                                      Color(
                                    0xFFC5A880,
                                  ),
                                ),
                              ),
                            ),

                            title:
                                Row(
                              children: [
                                Flexible(
                                  child:
                                      Text(
                                    name,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors
                                              .white,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 8,
                                ),

                                Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal:
                                        8,
                                    vertical:
                                        2,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color:
                                        const Color(
                                      0xFFC5A880,
                                    ).withOpacity(
                                      0.15,
                                    ),
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      4,
                                    ),
                                    border:
                                        Border.all(
                                      color:
                                          const Color(
                                        0xFFC5A880,
                                      ).withOpacity(
                                        0.3,
                                      ),
                                    ),
                                  ),
                                  child:
                                      Text(
                                    categoryName,
                                    style:
                                        const TextStyle(
                                      color:
                                          Color(
                                        0xFFC5A880,
                                      ),
                                      fontSize:
                                          10,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            subtitle:
                                Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  price,
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors
                                            .grey,
                                  ),
                                ),

                                Text(
                                  'ID: $categoryId',
                                  style:
                                      TextStyle(
                                    color:
                                        Colors.grey[
                                            700],
                                    fontSize:
                                        9,
                                  ),
                                ),
                              ],
                            ),

                            trailing:
                                IconButton(
                              icon:
                                  const Icon(
                                Icons
                                    .delete_outline_rounded,
                                color:
                                    Colors
                                        .redAccent,
                              ),
                              tooltip:
                                  'حذف العطر',
                              onPressed:
                                  () =>
                                      _deleteProduct(
                                docId,
                                name,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration(
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,

      hintStyle:
          TextStyle(
        color:
            Colors.grey[600],
        fontSize: 13,
      ),

      filled: true,

      fillColor:
          const Color(0xFF0A0908),

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          8,
        ),
        borderSide:
            BorderSide(
          color:
              const Color(
            0xFFC5A880,
          ).withOpacity(
            0.2,
          ),
        ),
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          8,
        ),
        borderSide:
            BorderSide(
          color:
              Colors.white
                  .withOpacity(
            0.1,
          ),
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          8,
        ),
        borderSide:
            const BorderSide(
          color:
              Color(0xFFC5A880),
        ),
      ),
    );
  }
}