import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/image_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/app_functions.dart';
import 'package:jointact_case_study/helpers/ui_helper.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/pages/admin/categories_page.dart';
import 'package:jointact_case_study/pages/admin/products_page.dart';
import 'package:jointact_case_study/pages/admin/update_product_page.dart';
import 'package:jointact_case_study/pages/settings_page.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/admin_repository.dart';
import 'package:jointact_case_study/widgets/loading_widget.dart';

class AdminHomePage extends ConsumerStatefulWidget {
  const AdminHomePage({super.key});

  @override
  ConsumerState<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<AdminHomePage> {
  bool isLoading = false;
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
    AdminRepository adminRepository = ref.watch(adminProvider);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.deepPurple,
            title: Text(
              getTranslated(context, StringKeys.admin),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    size: 22,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
          ),
          drawer: const NavigationDrawer(),
          body: RefreshIndicator(
            onRefresh: () async {
              await getData();
            },
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Column(
                  children: [
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: adminRepository.currencyList.isEmpty
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                margin: const EdgeInsets.all(10),
                                child: Center(
                                  child: Text(getTranslated(context, StringKeys.noCurrency),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      )),
                                ),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: adminRepository.currencyList.map((currency) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      margin: adminRepository.currencyList.indexOf(currency) ==
                                              (adminRepository.currencyList.length - 1)
                                          ? const EdgeInsets.all(10)
                                          : const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            currency.symbol,
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const VerticalDivider(
                                            color: Colors.black45,
                                            thickness: 2,
                                          ),
                                          Text(currency.name),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )),
                    const SizedBox(height: 10),
                  ],
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 1),
                      ),
                    ],
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
                      items: adminRepository.categoryList.map((category) {
                        return getDropdownItem(category.name, category.id);
                      }).toList(),
                      selectedItemBuilder: (context) {
                        return adminRepository.categoryList.map((category) {
                          return getDropdownSelectedItem(category.name);
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
                ((adminRepository.productList
                                .where((element) => element.categoryId == selectedCategoryId)
                                .toList()
                                .isEmpty &&
                            selectedCategoryId != null) ||
                        adminRepository.productList.isEmpty)
                    ? isLoading
                        ? const SizedBox()
                        : Center(
                            child: Text(
                              getTranslated(context, StringKeys.noProduct),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                            ),
                          )
                    : Visibility(
                        visible: !isLoading,
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
                                ? adminRepository.productList
                                    .where((element) => element.categoryId == selectedCategoryId)
                                    .toList()[index]
                                : adminRepository.productList[index];
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
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
                          },
                          itemCount: selectedCategoryId != null
                              ? adminRepository.productList
                                  .where((element) => element.categoryId == selectedCategoryId)
                                  .toList()
                                  .length
                              : adminRepository.productList.length,
                        ),
                      )
              ],
            ),
          ),
        ),
        LoadingWidget(isLoading: isLoading),
      ],
    );
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    selectedCategoryId = null;
    await ref.read(adminProvider).getCategories().then((response) {
      if (response.isSuccessful == false) {
        AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.errorFetchingCategories),
            backgroundColor: dangerDark, icon: Icons.cancel);
      }
    });

    await ref.read(adminProvider).getCurrencies().then((response) {
      if (response.isSuccessful == false) {
        AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.errorFetchingCurrencies),
            backgroundColor: dangerDark, icon: Icons.cancel);
      }
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
  }
}

DropdownMenuItem<int> getDropdownItem(String label, int value) {
  return DropdownMenuItem<int>(
    value: value,
    child: Text(
      label,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
    ),
  );
}

Widget getDropdownSelectedItem(String label) {
  return Container(
    padding: const EdgeInsets.only(left: 15),
    alignment: Alignment.centerLeft,
    child: Text(
      label,
      maxLines: 1,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
    ),
  );
}

class NavigationDrawer extends ConsumerWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildHeader(context),
          buildMenuItems(context, ref),
        ],
      )),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: UIHelper.getDeviceWidth(context) / 4,
                  height: UIHelper.getDeviceWidth(context) / 4,
                  child: SvgPicture.asset(
                    IconAssetKeys.userTie,
                    width: UIHelper.getDeviceWidth(context) / 4,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  Widget buildMenuItems(BuildContext context, WidgetRef ref) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Divider(color: Colors.black45),
            ListTile(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              leading: const Icon(Icons.category_rounded),
              title: Text(
                getTranslated(context, StringKeys.categories),
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriesPage(),
                  ),
                );
              },
            ),
            ListTile(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              leading: const Icon(Icons.auto_awesome_mosaic_rounded),
              title: Text(
                getTranslated(context, StringKeys.products),
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductsPage(),
                  ),
                );
              },
            ),
            ListTile(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              leading: const Icon(Icons.settings),
              title: Text(
                getTranslated(context, StringKeys.settings),
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      );
}
