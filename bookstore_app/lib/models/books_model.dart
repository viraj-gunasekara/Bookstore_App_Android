import 'package:cloud_firestore/cloud_firestore.dart';

class BooksModel {
  String name;
  String description;
  String image;
  int old_price;
  int new_price;
  String category;
  String id;
  int maxQuantity;

  BooksModel({
    required this.name,
    required this.description,
    required this.image,
    required this.old_price,
    required this.new_price,
    required this.category,
    required this.id,
    required this.maxQuantity,
  });

  // to convert the json to object model
  factory BooksModel.fromJson(Map<String, dynamic> json, String id) {
    return BooksModel(
      name: json["name"] ?? "",
      description: json["desc"] ?? "no description",
      image: json["image"] ?? "",
      new_price: json["new_price"] ?? 0,
      old_price: json["old_price"] ?? 0,
      category: json["category"] ?? "",
      maxQuantity: json["quantity"] ?? 0,
      id: id ?? "",
    );
  }

  // Convert List<QueryDocumentSnapshot> to List<BooksModel>
  static List<BooksModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) => BooksModel.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}
