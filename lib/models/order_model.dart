import 'package:jointact_case_study/models/item_model.dart';

/// Siparişleri temsil eden [OrderModel] sınıfı, sipariş bilgilerini içeren ve
/// JSON formatına dönüştürülebilen bir yapı sunar.
class OrderModel {
  int id;
  String time;
  int userId;
  List<ItemModel> items;
  OrderModel({
    required this.id,
    required this.time,
    required this.userId,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<ItemModel> items = (json['items'] as List).map((itemJson) => ItemModel.fromJson(itemJson)).toList();

    return OrderModel(
      id: json['id'],
      time: json['time'],
      userId: json['userId'],
      items: items,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> itemsJson = items.map((item) => item.toJson()).toList();

    return {
      'id': id,
      'time': time,
      'userId': userId,
      'items': itemsJson,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'time': time,
      'userId': userId,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as int,
      time: map['time'] as String,
      userId: map['userId'] as int,
      items: List<ItemModel>.from(
        (map['items'] as List<int>).map<ItemModel>(
          (x) => ItemModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}
