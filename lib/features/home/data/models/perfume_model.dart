class ProductModel {
  final String id;
  final String name;
  final String price;
  final String description;

  // ID القسم
  final String categoryId;

  // اسم القسم - اختياري للعرض
  final String categoryName;

  final String image;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.image,
  });

  factory ProductModel.fromFirestore(
    String docId,
    Map<String, dynamic> json,
  ) {
    return ProductModel(
      id: docId,

      name: json['name']?.toString() ?? '',

      price: json['price']?.toString() ?? '',

      description:
          json['description']?.toString() ?? '',

     

      categoryId:
          json['categoryId']?.toString() ??
              json['category']?.toString() ??
              '',


      categoryName:
          json['categoryName']?.toString() ??
              json['category']?.toString() ??
              '',

      image:
          json['image']?.toString() ?? '',
    );
  }
}