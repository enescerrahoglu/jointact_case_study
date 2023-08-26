import 'package:http/http.dart' as http;
import 'package:jointact_case_study/models/category_model.dart';
import 'package:jointact_case_study/models/currency_model.dart';
import 'package:jointact_case_study/models/product_model.dart';
import 'dart:convert';
import 'package:jointact_case_study/models/response_model.dart';
import 'package:flutter/material.dart';
import 'package:jointact_case_study/models/user_model.dart';

class UserRepository extends ChangeNotifier {
  String baseURL = 'https://api.jointact.com';
  String devKey = '833F0ACB-49F7-451C-A0C7-1EA68FDC5B6B';

  bool isLoading = false;

  List<CategoryModel> categoryList = [];
  CategoryModel? selectedCategory;

  List<ProductModel> productList = [];
  ProductModel? selectedProduct;

  List<CurrencyModel> currencyList = [];

  UserModel? createdUserModel;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  //User İşlemleri
  Future<ResponseModel> createUser(UserModel userModel) async {
    final url = Uri.parse('$baseURL/App/CreateUser');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'devKey': devKey,
      "name": userModel.name,
      "surname": userModel.surname,
      "phone": userModel.phone,
      "mail": userModel.mail
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final responseModel = ResponseModel.fromJson(responseData);

        if (responseModel.isSuccessful) {
          createdUserModel = UserModel.fromMap(responseModel.data);
          notifyListeners();
        }

        return responseModel;
      } else {
        return ResponseModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      debugPrint('Failed createUser(): $e');
      throw Exception([e]);
    }
  }

  // Category İşlemleri
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

  // Product İşlemleri
  Future<ResponseModel> getProducts() async {
    final url = Uri.parse('$baseURL/App/GetProducts');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'devKey': devKey});

    try {
      productList.clear();
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200 && json.decode(response.body)["isSuccessful"] == true) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final responseModel = ResponseModel.fromJson(responseData);

        for (var productMap in responseModel.data["products"]) {
          productList.add(ProductModel.fromMap(productMap));
        }
        notifyListeners();

        return responseModel;
      } else {
        return ResponseModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      debugPrint('Failed getProducts(): $e');
      throw Exception([e]);
    }
  }

  // Currency İşlemleri
  Future<ResponseModel> getCurrencies() async {
    final url = Uri.parse('$baseURL/App/GetCurrencies');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'devKey': devKey});

    try {
      currencyList.clear();
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200 && json.decode(response.body)["isSuccessful"] == true) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final responseModel = ResponseModel.fromJson(responseData);

        for (var currencyMap in responseModel.data["currencies"]) {
          currencyList.add(CurrencyModel.fromMap(currencyMap));
        }
        notifyListeners();

        return responseModel;
      } else {
        return ResponseModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      debugPrint('Failed getCurrencies(): $e');
      throw Exception([e]);
    }
  }
}
