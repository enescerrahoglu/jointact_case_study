import 'package:jointact_case_study/models/product_model.dart';

/// Sepette bulunan ürünleri temsil eden [BasketProductModel] sınıfı, sepet
/// öğelerinin sayısını ve ilgili ürün modelini içeren bir yapıdır.
class BasketProductModel {
  int count;
  ProductModel productModel;
  BasketProductModel({
    required this.count,
    required this.productModel,
  });
}
