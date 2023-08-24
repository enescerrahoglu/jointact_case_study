import 'package:http/http.dart' as http;
import 'package:jointact_case_study/models/category_model.dart';
import 'dart:convert';
import 'package:jointact_case_study/models/response_model.dart';
import 'package:flutter/material.dart';

class AdminRepository extends ChangeNotifier {
  String baseURL = 'https://api.jointact.com';
  String devKey = '833F0ACB-49F7-451C-A0C7-1EA68FDC5B6B';
  List<CategoryModel> categoryList = [];
  CategoryModel? selectedCategory;

  Future<ResponseModel> getCategories() async {
    final url = Uri.parse('$baseURL/App/GetCategories');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'devKey': devKey});

    try {
      categoryList.clear();
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200 && json.decode(response.body)["isSuccessful"] == true) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final responseModel = ResponseModel.fromJson(responseData);

        for (var categoryMap in responseModel.data["categories"]) {
          categoryList.add(CategoryModel.fromMap(categoryMap));
        }
        notifyListeners();

        return responseModel;
      } else {
        return ResponseModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      debugPrint('Failed getCategories(): $e');
      throw Exception([e]);
    }
  }

  Future<ResponseModel> createCategory(String name) async {
    final url = Uri.parse('$baseURL/App/CreateCategory');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'devKey': devKey, 'name': name});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final responseModel = ResponseModel.fromJson(responseData);

        if (responseModel.isSuccessful) {
          categoryList.add(CategoryModel.fromMap(responseModel.data));
          notifyListeners();
        }

        return responseModel;
      } else {
        return ResponseModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      debugPrint('Failed createCategory(): $e');
      throw Exception([e]);
    }
  }

  Future<ResponseModel> updateCategory(CategoryModel categoryModel) async {
    final url = Uri.parse('$baseURL/App/UpdateCategory');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'devKey': devKey, 'name': categoryModel.name, "id": categoryModel.id});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final responseModel = ResponseModel.fromJson(responseData);
        if (responseModel.isSuccessful) {
          categoryList.where((element) => element.id == categoryModel.id).first.name = categoryModel.name;
          notifyListeners();
        }
        return responseModel;
      } else {
        return ResponseModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      debugPrint('Failed updateCategory(): $e');
      throw Exception([e]);
    }
  }

  Future<ResponseModel> deleteCategory(int id) async {
    final url = Uri.parse('$baseURL/App/DeleteCategory');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'devKey': devKey, "id": id});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final responseModel = ResponseModel.fromJson(responseData);
        if (responseModel.isSuccessful) {
          categoryList.removeWhere((element) => element.id == id);
          notifyListeners();
        }
        return responseModel;
      } else {
        return ResponseModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      debugPrint('Failed deleteCategory(): $e');
      throw Exception([e]);
    }
  }
}
