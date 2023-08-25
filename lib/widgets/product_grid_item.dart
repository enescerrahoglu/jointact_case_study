import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/helpers/ui_helper.dart';
import 'package:jointact_case_study/models/product_model.dart';
import 'package:jointact_case_study/pages/admin/update_product_page.dart';
import 'package:jointact_case_study/repositories/admin_repository.dart';

class ProductGridItem extends StatelessWidget {
  final ProductModel product;
  final AdminRepository adminRepository;
  const ProductGridItem({super.key, required this.product, required this.adminRepository});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        adminRepository.selectedProduct = product;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UpdateProductPage(),
          ),
        );
      },
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
                      const Divider(color: Colors.grey),
                      Center(
                        child: Text(
                          "${adminRepository.currencyList.isEmpty ? "" : adminRepository.currencyList.where((element) => element.id == product.currencyId).first.symbol} ${product.price}",
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
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
    );
  }
}
