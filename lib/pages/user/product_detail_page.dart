import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/user_repository.dart';
import 'package:jointact_case_study/widgets/app_bar_widget.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBarWidget(
        title: userRepository.selectedProduct?.name ?? "",
        leadingIcon: Icons.arrow_back_ios_rounded,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () {
          if (userRepository.selectedProduct != null) {
            ref.read(userProvider).addProductToBasket(userRepository.selectedProduct!, context);
          }
        },
        label: Text(
          "${userRepository.currencyList.isEmpty ? "" : userRepository.currencyList.where((element) => element.id == userRepository.selectedProduct?.currencyId).first.symbol}${userRepository.selectedProduct?.price}",
          style: const TextStyle(color: buttonForegroundColor, fontSize: 16),
        ),
        icon: const Icon(
          CupertinoIcons.cart_fill_badge_plus,
          color: buttonForegroundColor,
          size: 28,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.memory(
                    base64Decode(userRepository.selectedProduct?.imageBase64 ?? ""),
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),
            userRepository.categoryList.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        userRepository.categoryList
                            .where((element) => element.id == userRepository.selectedProduct?.categoryId)
                            .first
                            .name,
                        textAlign: TextAlign.end,
                        style: const TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  )
                : const SizedBox(),
            const SizedBox(height: 10),
            Text(
              getTranslated(context, StringKeys.description),
              textAlign: TextAlign.start,
              style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              userRepository.selectedProduct?.description ?? "",
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
