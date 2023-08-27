/// API yanıtlarını temsil eden [ResponseModel] sınıfı, yanıt verilerini, sonucu,
/// mesajı ve başarılı olup olmadığını içeren bir yapı sunar.
class ResponseModel {
  final dynamic data;
  final int result;
  final String message;
  final bool isSuccessful;

  ResponseModel({
    required this.data,
    required this.result,
    required this.message,
    required this.isSuccessful,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      data: json['data'],
      result: json['result'],
      message: json['message'],
      isSuccessful: json['isSuccessful'],
    );
  }
}
