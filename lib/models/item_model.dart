/// Sipariş edilmiş öğeleri temsil eden [ItemModel] sınıfı, öğe bilgilerini içeren ve
/// JSON formatına dönüştürülebilen bir yapı sunar.
class ItemModel {
  int id;
  int orderId;
  int productId;
  ItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      orderId: json['orderId'],
      productId: json['productId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productId': productId,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'orderId': orderId,
      'productId': productId,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] as int,
      orderId: map['orderId'] as int,
      productId: map['productId'] as int,
    );
  }
}
