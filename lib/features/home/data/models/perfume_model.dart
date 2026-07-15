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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
     
    );
  }
}