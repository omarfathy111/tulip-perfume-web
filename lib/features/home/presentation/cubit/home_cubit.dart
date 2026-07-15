import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tulip_for_perfume/features/home/data/models/perfume_model.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  void getProducts() async {
    emit(HomeLoadingState());
    try {

      var querySnapshot = await FirebaseFirestore.instance.collection('products').get();
      
    
      List<ProductModel> productsList = querySnapshot.docs.map((doc) {
        return ProductModel.fromJson(doc.data());
      }).toList();

      emit(HomeSuccessState(productsList));
    } catch (e) {
      emit(HomeErrorState("فشل جلب البيانات: ${e.toString()}"));
    }
  }
}