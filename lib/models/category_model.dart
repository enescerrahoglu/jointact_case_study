import 'dart:convert';

/// Ürün kategorilerini temsil eden [CategoryModel] sınıfı, kategori bilgilerini
/// içeren ve JSON formatına dönüştürülebilen bir yapı sunar.
class CategoryModel {
  final int id;
  String name;
  CategoryModel({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) => CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
