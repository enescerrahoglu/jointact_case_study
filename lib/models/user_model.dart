import 'dart:convert';

/// Kullanıcıları temsil eden [UserModel] sınıfı, kullanıcı bilgilerini içeren
/// ve JSON formatına dönüştürülebilen bir yapı sunar.
class UserModel {
  final int id;
  String name;
  String surname;
  String phone;
  String mail;
  UserModel({
    required this.id,
    required this.name,
    required this.surname,
    required this.phone,
    required this.mail,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'surname': surname,
      'phone': phone,
      'mail': mail,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int,
      name: map['name'] as String,
      surname: map['surname'] as String,
      phone: map['phone'] as String,
      mail: map['mail'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
