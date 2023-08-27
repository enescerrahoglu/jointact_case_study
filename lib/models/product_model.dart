import 'dart:convert';

/// Ürünleri temsil eden [ProductModel] sınıfı, ürün bilgilerini içeren ve
/// JSON formatına dönüştürülebilen bir yapı sunar.
class ProductModel {
  final int id;
  int categoryId;
  String name;
  String description;
  String imageBase64;
  int price;
  int currencyId;
  String productVideoLink;
  ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.imageBase64,
    required this.price,
    required this.currencyId,
    required this.productVideoLink,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'imageBase64': imageBase64,
      'price': price,
      'currencyId': currencyId,
      'productVideoLink': productVideoLink,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      categoryId: map['categoryId'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      imageBase64: map['imageBase64'] as String,
      price: map['price'] as int,
      currencyId: map['currencyId'] as int,
      productVideoLink: map['productVideoLink'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
