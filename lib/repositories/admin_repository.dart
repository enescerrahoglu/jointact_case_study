import 'package:http/http.dart' as http;
import 'package:jointact_case_study/models/category_model.dart';
import 'dart:convert';
import 'package:jointact_case_study/models/response_model.dart';
import 'package:flutter/material.dart';

class AdminRepository extends ChangeNotifier {
  String baseURL = 'https://api.jointact.com';
  String devKey = '833F0ACB-49F7-451C-A0C7-1EA68FDC5B6B';
  List<CategoryModel> categoryList = [];

  Future<ResponseModel> getCategories() async {
    final url = Uri.parse('$baseURL/App/GetCategories');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'devKey': devKey});

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final responseModel = ResponseModel.fromJson(responseData);
      return responseModel;
    } else {
      throw Exception('Failed to load categories...');
    }
  }
}
