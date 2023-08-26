import 'package:http/http.dart' as http;
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/app_functions.dart';
import 'package:jointact_case_study/helpers/shared_preferences_helper.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/models/basket_product_model.dart';
import 'package:jointact_case_study/models/category_model.dart';
import 'package:jointact_case_study/models/currency_model.dart';
import 'package:jointact_case_study/models/order_model.dart';
import 'package:jointact_case_study/models/product_model.dart';
import 'dart:convert';
import 'package:jointact_case_study/models/response_model.dart';
import 'package:flutter/material.dart';
import 'package:jointact_case_study/models/user_model.dart';

class UserRepository extends ChangeNotifier {
  final String _baseURL = 'https://api.jointact.com';
  final String _devKey = '833F0ACB-49F7-451C-A0C7-1EA68FDC5B6B';

  bool isLoading = false;
  List<CategoryModel> categoryList = [];
  CategoryModel? selectedCategory;
  List<ProductModel> productList = [];
  ProductModel? selectedProduct;
  List<CurrencyModel> currencyList = [];
  UserModel? createdUserModel;
  List<BasketProductModel> basketProducts = [];
  List<OrderModel> orderList = [];
  OrderModel? selectedOrder;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  //User İşlemleri
  Future<ResponseModel> createUser(UserModel userModel) async {
    final url = Uri.parse('$_baseURL/App/CreateUser');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'devKey': _devKey,
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
          await SharedPreferencesHelper.setString("createdUserModel", createdUserModel!.toJson());
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

  Future<void> addProductToBasket(ProductModel productModel, BuildContext context) async {
    if (basketProducts.any((element) => element.productModel.id == productModel.id)) {
      int currentCount = basketProducts.where((element) => element.productModel.id == productModel.id).first.count;
      if (currentCount < 9) {
        currentCount++;
        BasketProductModel basketProductModel = BasketProductModel(count: currentCount, productModel: productModel);
        basketProducts[basketProducts.indexOf(
            basketProducts.where((element) => element.productModel.id == productModel.id).first)] = basketProductModel;
        AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.productHasBeenAdded),
            backgroundColor: successDark, icon: Icons.check_circle);
      } else {
        AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.cannotAddMore),
            backgroundColor: warningDark, icon: Icons.error);
      }
    } else {
      BasketProductModel basketProductModel = BasketProductModel(count: 1, productModel: productModel);
      basketProducts.add(basketProductModel);
      AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.productHasBeenAdded),
          backgroundColor: successDark, icon: Icons.check_circle);
    }
    notifyListeners();
  }

  Future<void> removeProductFromBasket(ProductModel productModel) async {
    int count = basketProducts[
            basketProducts.indexOf(basketProducts.where((element) => element.productModel.id == productModel.id).first)]
        .count;
    if (count > 1) {
      basketProducts[basketProducts
              .indexOf(basketProducts.where((element) => element.productModel.id == productModel.id).first)]
          .count--;
    } else {
      basketProducts.removeWhere((element) => element.productModel.id == productModel.id);
    }
    notifyListeners();
  }

  Future<ResponseModel> createOrder(OrderModel orderModel, List<int> productIds) async {
    final url = Uri.parse('$_baseURL/App/CreateOrder');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "devKey": _devKey,
      "time": orderModel.time,
      "userId": orderModel.userId,
      "productIds": productIds,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final responseModel = ResponseModel.fromJson(responseData);

        if (responseModel.isSuccessful) {
          final OrderModel order = OrderModel.fromJson(responseData['data']);
          orderList.add(order);
          basketProducts.clear();
          notifyListeners();
        }

        return responseModel;
      } else {
        return ResponseModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      debugPrint('Failed createOrder(): $e');
      throw Exception([e]);
    }
  }

  Future<ResponseModel> getOrdersForUserId() async {
    if (createdUserModel != null) {
      final url = Uri.parse('$_baseURL/App/GetOrdersForUserId');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({'devKey': _devKey, "id": createdUserModel!.id});

      try {
        orderList.clear();
        final response = await http.post(url, headers: headers, body: body);
        if (response.statusCode == 200 && json.decode(response.body)["isSuccessful"] == true) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final responseModel = ResponseModel.fromJson(responseData);

          for (var orderJson in responseModel.data["orders"]) {
            orderList.add(OrderModel.fromJson(orderJson));
          }
          notifyListeners();

          return responseModel;
        } else {
          return ResponseModel.fromJson(json.decode(response.body));
        }
      } catch (e) {
        debugPrint('Failed getOrdersForUserId(): $e');
        throw Exception([e]);
      }
    } else {
      return ResponseModel(data: null, result: 2, message: "", isSuccessful: false);
    }
  }

  // Category İşlemleri
  Future<ResponseModel> getCategories() async {
    final url = Uri.parse('$_baseURL/App/GetCategories');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'devKey': _devKey});

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
    final url = Uri.parse('$_baseURL/App/GetProducts');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'devKey': _devKey});

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
    final url = Uri.parse('$_baseURL/App/GetCurrencies');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'devKey': _devKey});

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
