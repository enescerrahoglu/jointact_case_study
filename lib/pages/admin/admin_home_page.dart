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
import 'package:jointact_case_study/models/response_model.dart';
import 'package:jointact_case_study/pages/admin/categories_page.dart';
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
  ResponseModel? categoriesResponse;
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      setState(() {
        isLoading = true;
      });
      categoriesResponse = await ref.read(adminProvider).getCategories();
      setState(() {
        isLoading = false;
      });
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
              setState(() {
                isLoading = true;
              });
              selectedCategoryId = null;
              await ref.read(adminProvider).getCategories().then((response) {
                if (response.isSuccessful == false) {
                  AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.somethingWentWrong),
                      backgroundColor: dangerDark, icon: Icons.cancel);
                }
              });
              setState(() {
                isLoading = false;
              });
            },
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
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
                          icon: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              color: primaryColor,
                            ),
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
                  ],
                ),
              ],
            ),
          ),
        ),
        LoadingWidget(isLoading: isLoading),
      ],
    );
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
