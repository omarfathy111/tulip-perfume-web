import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tulip_for_perfume/core/constants/app_images.dart';
import 'package:tulip_for_perfume/features/home/data/models/perfume_model.dart';


import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  Future<void> getProducts() async {
    emit(HomeLoadingState());

    try {
      final querySnapshot = await FirebaseFirestore
          .instance
          .collection('products')
          .get();

      final productsList = <ProductModel>[];

      for (int i = 0; i < querySnapshot.docs.length; i++) {
        final doc = querySnapshot.docs[i];

        final data = doc.data();

        // ---------------------------------------------------------
        // اختيار صورة Static حسب ترتيب المنتج
        // ---------------------------------------------------------

        final imageIndex =
            i % AppImages.perfumeImages.length;

        final image =
            AppImages.perfumeImages[imageIndex];

        productsList.add(
          ProductModel.fromJson(
            data,
            image: image,
          ),
        );
      }

      emit(
        HomeSuccessState(
          productsList,
        ),
      );
    } catch (e) {
      emit(
        HomeErrorState(
          "فشل جلب البيانات: ${e.toString()}",
        ),
      );
    }
  }
}