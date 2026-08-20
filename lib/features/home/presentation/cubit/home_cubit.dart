import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tulip_for_perfume/features/home/data/models/perfume_model.dart';

import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _productsSubscription;

  // ============================================================
  // GET ALL PRODUCTS
  // ============================================================

  void getProducts() {
    _listenToProducts();
  }

  // ============================================================
  // GET PRODUCTS BY CATEGORY
  // ============================================================

  void getProductsByCategory(String categoryId) {
    _listenToProducts(
      categoryId: categoryId,
    );
  }

  // ============================================================
  // LISTEN TO PRODUCTS
  // ============================================================

  void _listenToProducts({
    String? categoryId,
  }) {
    // إلغاء الـ listener القديم
    _productsSubscription?.cancel();

    emit(HomeLoadingState());

    Query<Map<String, dynamic>> query = FirebaseFirestore
        .instance
        .collection('products');

    // ==========================================================
    // FILTER BY CATEGORY
    // ==========================================================

    if (categoryId != null && categoryId.isNotEmpty) {
      query = query.where(
        'category',
        isEqualTo: categoryId,
      );
    }

    // ==========================================================
    // ORDER
    // ==========================================================

    query = query.orderBy(
      'createdAt',
      descending: true,
    );

    // ==========================================================
    // REALTIME LISTENER
    // ==========================================================

    _productsSubscription = query.snapshots().listen(
      (querySnapshot) {
        final productsList = querySnapshot.docs.map((doc) {
          return ProductModel.fromFirestore(
            doc.id,
            doc.data(),
          );
        }).toList();

        emit(
          HomeSuccessState(
            productsList,
          ),
        );
      },
      onError: (e) {
        emit(
          HomeErrorState(
            "فشل جلب البيانات: ${e.toString()}",
          ),
        );
      },
    );
  }

  // ============================================================
  // CLEAR / STOP LISTENER
  // ============================================================

  void stopListening() {
    _productsSubscription?.cancel();
    _productsSubscription = null;
  }

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    return super.close();
  }
}