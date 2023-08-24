import 'dart:convert';

class CurrencyModel {
  final int id;
  final String name;
  final String symbol;
  CurrencyModel({
    required this.id,
    required this.name,
    required this.symbol,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'symbol': symbol,
    };
  }

  factory CurrencyModel.fromMap(Map<String, dynamic> map) {
    return CurrencyModel(
      id: map['id'] as int,
      name: map['name'] as String,
      symbol: map['symbol'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CurrencyModel.fromJson(String source) => CurrencyModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
