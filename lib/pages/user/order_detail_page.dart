import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/models/product_model.dart';
import 'package:jointact_case_study/pages/user/product_detail_page.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/user_repository.dart';
import 'package:jointact_case_study/widgets/app_bar_widget.dart';

/// Bu sayfada kullanıcı vermiş olduğu bir siparişe ait ürünlerin listesini görür.
/// Tıklanan her bir ürün için detay sayfasına yönlendirilir.
class OrderDetailPage extends ConsumerWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserRepository userRepository = ref.watch(userProvider);
    List<int> selectedOrderProductIds = userRepository.selectedOrder!.items.map((item) => item.productId).toList();
    List<ProductModel> orderProducts =
        userRepository.productList.where((product) => selectedOrderProductIds.contains(product.id)).toList();
    return Scaffold(
      appBar: AppBarWidget(
        title: getTranslated(context, StringKeys.orderDetail),
        leadingIcon: Icons.arrow_back_ios_rounded,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: orderProducts.map((product) {
            return ListTile(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              leading: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.memory(
                    base64Decode(product.imageBase64),
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                  ),
                ),
              ),
              title: Text(
                product.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                product.description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
              onTap: () {
                userRepository.selectedProduct = product;
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
      ),
    );
  }
}
