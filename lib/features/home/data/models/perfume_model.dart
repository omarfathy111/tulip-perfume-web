class ProductModel {
  final String name;
  final String price;
  final String description;
  final String image;

  ProductModel({
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });

  factory ProductModel.fromJson(
    Map<String, dynamic> json, {
    required String image,
  }) {
    return ProductModel(
      name: json['name']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: image,
    );
  }
}