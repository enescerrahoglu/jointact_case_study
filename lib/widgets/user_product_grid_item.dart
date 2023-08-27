import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/helpers/ui_helper.dart';
import 'package:jointact_case_study/models/product_model.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/user_repository.dart';

/// Bu sınıf user için kişiselleştirilmiş ürün widgetı sunar.
class UserProductGridItem extends ConsumerWidget {
  final ProductModel product;
  final Function()? onTap;
  const UserProductGridItem({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserRepository userRepository = ref.watch(userProvider);
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: itemBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: UIHelper.boxShadow,
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.memory(
                      base64Decode(product.imageBase64),
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: FittedBox(
                              child: Text(
                                product.name,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const Divider(color: Colors.grey),
                          Center(
                            child: Text(
                              "${userRepository.currencyList.isEmpty ? "" : userRepository.currencyList.where((element) => element.id == product.currencyId).first.symbol}${product.price}",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
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
                  ref.read(userProvider).addProductToBasket(product, context);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    CupertinoIcons.cart_fill_badge_plus,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
