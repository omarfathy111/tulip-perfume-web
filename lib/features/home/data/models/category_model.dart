class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String description;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  factory CategoryModel.fromFirestore(
    String docId,
    Map<String, dynamic> json,
  ) {
    return CategoryModel(
      id: docId,

      name:
          json['name']?.toString() ?? '',

      image:
          json['image']?.toString() ?? '',

      description:
          json['description']?.toString() ?? '',
    );
  }
}