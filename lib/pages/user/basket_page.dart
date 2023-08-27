import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/app_functions.dart';
import 'package:jointact_case_study/helpers/ui_helper.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/models/order_model.dart';
import 'package:jointact_case_study/pages/user/product_detail_page.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/user_repository.dart';
import 'package:jointact_case_study/widgets/app_bar_widget.dart';

/// Bu sayfa, kullanıcının sepete eklediği ürünleri görüntülemesi ve siparişi tamamlaması için tasarlanmıştır.
///
/// Kullanıcı, sepetindeki ürünleri görüntüleyebilir, ürün sayısını düzenleyebilir veya ürünü
/// sepetten çıkarabilir. Ayrıca, sepetindeki ürünler ile sipariş oluşturabilir.
/// Eğer kullanıcının sepeti boş ise kullanıcıya bir uyarı mesajı gösterilir.
class BasketPage extends ConsumerStatefulWidget {
  const BasketPage({super.key});

  @override
  ConsumerState<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends ConsumerState<BasketPage> {
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBarWidget(
        title: getTranslated(context, StringKeys.basket),
      ),
      floatingActionButton: userRepository.basketProducts.isNotEmpty
          ? FloatingActionButton.extended(
              backgroundColor: primaryColor,
              onPressed: () async {
                if (userRepository.createdUserModel != null) {
                  userRepository.setLoading(true);
                  List<int> productIds = [];
                  for (var basketProduct in userRepository.basketProducts) {
                    productIds.add(basketProduct.productModel.id);
                  }
                  OrderModel orderModel = OrderModel(
                      id: 0,
                      time: DateTime.now().toIso8601String(),
                      userId: userRepository.createdUserModel!.id,
                      items: []);

                  await userRepository.createOrder(orderModel, productIds).then((response) {
                    if (response.isSuccessful) {
                      AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.theOperationIsSuccessful),
                          backgroundColor: successDark, icon: Icons.check_circle);
                    } else {
                      AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.somethingWentWrong),
                          backgroundColor: dangerDark, icon: Icons.cancel);
                    }
                  });
                  userRepository.setLoading(false);
                }
              },
              label: Text(
                getTranslated(context, StringKeys.completeOrder),
                style: const TextStyle(color: buttonForegroundColor, fontSize: 16),
              ),
              icon: const Icon(
                Icons.check_circle,
                color: buttonForegroundColor,
                size: 28,
              ),
            )
          : null,
      body: userRepository.basketProducts.isNotEmpty
          ? SingleChildScrollView(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 90),
              child: Column(
                children: userRepository.basketProducts.map((basketProduct) {
                  return ListTile(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    leading: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.memory(
                          base64Decode(basketProduct.productModel.imageBase64),
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        ),
                      ),
                    ),
                    title: Text(
                      basketProduct.productModel.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${userRepository.currencyList.isEmpty ? "" : userRepository.currencyList.where((element) => element.id == basketProduct.productModel.currencyId).first.symbol}${basketProduct.productModel.price * basketProduct.count}",
                      style: const TextStyle(fontSize: 12, color: primaryColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: itemBackgroundColor,
                            shape: BoxShape.circle,
                            boxShadow: UIHelper.boxShadow,
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            child: Material(
                              child: InkWell(
                                onTap: () {
                                  ref.read(userProvider).removeProductFromBasket(basketProduct.productModel);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(
                                    basketProduct.count > 1 ? CupertinoIcons.minus : CupertinoIcons.trash_fill,
                                    color: basketProduct.count > 1 ? primaryColor : Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 30,
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            basketProduct.count.toString(),
                            style: const TextStyle(fontSize: 16, color: secondaryColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: itemBackgroundColor,
                            shape: BoxShape.circle,
                            boxShadow: UIHelper.boxShadow,
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            child: Material(
                              child: InkWell(
                                onTap: () {
                                  ref.read(userProvider).addProductToBasket(basketProduct.productModel, context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  child: const Icon(
                                    CupertinoIcons.plus,
                                    color: primaryColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      userRepository.selectedProduct = basketProduct.productModel;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductDetailPage(),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            )
          : Center(
              child: Text(
                getTranslated(context, StringKeys.cartIsEmpty),
                style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
              ),
            ),
    );
  }
}
