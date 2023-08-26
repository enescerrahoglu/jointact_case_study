import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/app_functions.dart';
import 'package:jointact_case_study/helpers/ui_helper.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/pages/admin/update_product_page.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/admin_repository.dart';
import 'package:jointact_case_study/widgets/admin_navigation_drawer.dart';
import 'package:jointact_case_study/widgets/dropdown_item_widget.dart';
import 'package:jointact_case_study/widgets/loading_widget.dart';
import 'package:jointact_case_study/widgets/product_grid_item.dart';

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
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: primaryColor,
            title: Text(
              getTranslated(context, StringKeys.admin),
              style: const TextStyle(color: appBarForegroundColor, fontSize: 18),
            ),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    size: 22,
                    color: appBarForegroundColor,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
          ),
          drawer: const AdminNavigationDrawer(),
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
                          color: itemBackgroundColor,
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: UIHelper.boxShadow,
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
                                        color: itemBackgroundColor,
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        boxShadow: UIHelper.boxShadow,
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
                      items: adminRepository.categoryList.map((category) {
                        return DropdownItemWidget.getDropdownItem(category.name, category.id);
                      }).toList(),
                      selectedItemBuilder: (context) {
                        return adminRepository.categoryList.map((category) {
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
                            return ProductGridItem(
                              product: product,
                              currencyList: adminRepository.currencyList,
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
