
import 'package:tulip_for_perfume/features/home/data/models/perfume_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class HomeSuccessState extends HomeStates {
  final List<ProductModel> products; // قائمة المنتجات الجاهزة للعرض
  HomeSuccessState(this.products);
}

class HomeErrorState extends HomeStates {
  final String errorMessage;
  HomeErrorState(this.errorMessage);
}