abstract class CartStates {}

class CartInitialState extends CartStates {}
class CartLoadingState extends CartStates {}
class CartSuccessState extends CartStates {
  final List<Map<String, dynamic>> cartItems;
  CartSuccessState(this.cartItems);
}
class CartErrorState extends CartStates {
  final String errorMessage;
  CartErrorState(this.errorMessage);
}

// حالة خاصة تبلغ الشاشة إن المنتج اتضاف بنجاح عشان تظهر رسالة تفرح العميل
class ProductAddedToCartSuccessState extends CartStates {}