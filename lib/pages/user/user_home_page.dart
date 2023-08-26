import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/app_functions.dart';
import 'package:jointact_case_study/helpers/ui_helper.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/pages/user/product_detail_page.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/user_repository.dart';
import 'package:jointact_case_study/widgets/app_bar_widget.dart';
import 'package:jointact_case_study/widgets/dropdown_item_widget.dart';
import 'package:jointact_case_study/widgets/user_product_grid_item.dart';

class UserHomePage extends ConsumerStatefulWidget {
  const UserHomePage({super.key});

  @override
  ConsumerState<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends ConsumerState<UserHomePage> {
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await getData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBarWidget(
        title: getTranslated(context, StringKeys.home),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getData();
        },
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: itemBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: UIHelper.boxShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: DropdownButton<int>(
                  value: selectedCategoryId,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedCategoryId = newValue;
                    });
                  },
                  autofocus: true,
                  items: userRepository.categoryList.map((category) {
                    return DropdownItemWidget.getDropdownItem(category.name, category.id);
                  }).toList(),
                  selectedItemBuilder: (context) {
                    return userRepository.categoryList.map((category) {
                      return DropdownItemWidget.getSelectedDropdownItem(category.name);
                    }).toList();
                  },
                  underline: Container(),
                  iconEnabledColor: hintTextColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  isExpanded: true,
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: selectedCategoryId == null
                        ? const IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: null,
                            icon: Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              color: primaryColor,
                            ))
                        : IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                selectedCategoryId = null;
                              });
                            },
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            )),
                  ),
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated(context, StringKeys.categories),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: hintTextColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ((userRepository.productList
                            .where((element) => element.categoryId == selectedCategoryId)
                            .toList()
                            .isEmpty &&
                        selectedCategoryId != null) ||
                    userRepository.productList.isEmpty)
                ? userRepository.isLoading
                    ? const SizedBox()
                    : Center(
                        child: Text(
                          getTranslated(context, StringKeys.noProduct),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                      )
                : Visibility(
                    visible: !userRepository.isLoading,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: UIHelper.getDeviceWidth(context) > 450 ? 3 : 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 16 / 24,
                      ),
                      itemBuilder: (context, index) {
                        final product = selectedCategoryId != null
                            ? userRepository.productList
                                .where((element) => element.categoryId == selectedCategoryId)
                                .toList()[index]
                            : userRepository.productList[index];
                        return UserProductGridItem(
                          product: product,
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
                      },
                      itemCount: selectedCategoryId != null
                          ? userRepository.productList
                              .where((element) => element.categoryId == selectedCategoryId)
                              .toList()
                              .length
                          : userRepository.productList.length,
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Future<void> getData() async {
    ref.read(userProvider).setLoading(true);
    selectedCategoryId = null;
    await ref.read(userProvider).getCategories().then((response) {
      if (response.isSuccessful == false) {
        AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.errorFetchingCategories),
            backgroundColor: dangerDark, icon: Icons.cancel);
      }
    });

    await ref.read(userProvider).getCurrencies().then((response) {
      if (response.isSuccessful == false) {
        AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.errorFetchingCurrencies),
            backgroundColor: dangerDark, icon: Icons.cancel);
      }
    });

    await ref.read(userProvider).getProducts().then((response) {
      if (response.isSuccessful == false) {
        AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.errorFetchingProducts),
            backgroundColor: dangerDark, icon: Icons.cancel);
      }
    });
    ref.read(userProvider).setLoading(false);
  }
}
