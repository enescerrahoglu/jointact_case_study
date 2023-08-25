import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/app_functions.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/pages/admin/create_product_page.dart';
import 'package:jointact_case_study/pages/admin/update_product_page.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/admin_repository.dart';
import 'package:jointact_case_study/widgets/app_bar_widget.dart';
import 'package:jointact_case_study/widgets/loading_widget.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AdminRepository adminRepository = ref.watch(adminProvider);
    return Stack(children: [
      Scaffold(
        appBar: AppBarWidget(
          title: getTranslated(context, StringKeys.products),
          leadingIcon: Icons.arrow_back_ios_rounded,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateProductPage(),
              ),
            );
          },
          backgroundColor: primaryColor,
          child: const Icon(
            CupertinoIcons.add,
            color: buttonForegroundColor,
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              isLoading = true;
            });
            await ref.read(adminProvider).getProducts().then((response) {
              if (response.isSuccessful == false) {
                AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.errorFetchingProducts),
                    backgroundColor: dangerDark, icon: Icons.cancel);
              }
            });
            setState(() {
              isLoading = false;
            });
          },
          child: adminRepository.productList.isNotEmpty
              ? ListView(
                  padding: const EdgeInsets.all(10),
                  children: adminRepository.productList.map((product) {
                    return ListTile(
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      leading: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.memory(
                            base64Decode(product.imageBase64),
                            fit: BoxFit.cover,
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
                      ),
                      trailing: Text(
                        "${adminRepository.currencyList.isEmpty ? "" : adminRepository.currencyList.where((element) => element.id == product.currencyId).first.symbol} ${product.price}",
                        style: const TextStyle(fontSize: 14, color: secondaryColor),
                      ),
                      onTap: () {
                        adminRepository.selectedProduct = product;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UpdateProductPage(),
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              : isLoading
                  ? const SizedBox()
                  : ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Text(
                              getTranslated(context, StringKeys.noProduct),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
      LoadingWidget(isLoading: isLoading),
    ]);
  }
}
