import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/app_functions.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/pages/admin/create_category_page.dart';
import 'package:jointact_case_study/pages/admin/update_category_page.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/admin_repository.dart';
import 'package:jointact_case_study/widgets/app_bar_widget.dart';
import 'package:jointact_case_study/widgets/loading_widget.dart';

/// Bu sayfa eklenen bütün kategorilerin listelemektedir.
/// Listelenen kategorilere tıklanarak o kategori için güncelleme sayfasına yönlendirme sağlanır.
/// Yeni kategori ekleme sayfasına bir FloatingActionButton yardımıyla gidilir.
class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AdminRepository adminRepository = ref.watch(adminProvider);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarWidget(
            title: getTranslated(context, StringKeys.categories),
            leadingIcon: Icons.arrow_back_ios_rounded,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateCategoryPage(),
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
              await ref.read(adminProvider).getCategories().then((response) {
                if (response.isSuccessful == false) {
                  AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.errorFetchingCategories),
                      backgroundColor: dangerDark, icon: Icons.cancel);
                }
              });
              setState(() {
                isLoading = false;
              });
            },
            child: adminRepository.categoryList.isNotEmpty
                ? ListView(
                    padding: const EdgeInsets.all(10),
                    children: adminRepository.categoryList.map((category) {
                      return ListTile(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        title: Text(
                          category.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "ID: ${category.id}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        onTap: () {
                          adminRepository.selectedCategory = category;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UpdateCategoryPage(),
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
                                getTranslated(context, StringKeys.noCategory),
                                style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                              ),
                            ),
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
