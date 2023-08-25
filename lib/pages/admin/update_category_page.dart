import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/components/text_form_field_component.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/app_functions.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/models/category_model.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/admin_repository.dart';
import 'package:jointact_case_study/widgets/loading_widget.dart';

class UpdateCategoryPage extends ConsumerStatefulWidget {
  const UpdateCategoryPage({super.key});

  @override
  ConsumerState<UpdateCategoryPage> createState() => _UpdateCategoryPageState();
}

class _UpdateCategoryPageState extends ConsumerState<UpdateCategoryPage> {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (ref.read(adminProvider).selectedCategory != null) {
      textEditingController.text = ref.read(adminProvider).selectedCategory!.name;
    }
  }

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
              getTranslated(context, StringKeys.updateCategory),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                onPressed: adminRepository.selectedCategory == null
                    ? null
                    : () async {
                        showDialog(
                          context: context,
                          builder: (builderContext) {
                            return AlertDialog(
                              actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
                              titlePadding: const EdgeInsets.only(bottom: 10, right: 20, left: 20, top: 20),
                              scrollable: true,
                              actionsAlignment: MainAxisAlignment.end,
                              title: Text(getTranslated(context, StringKeys.aysDeleteCategory)),
                              titleTextStyle: const TextStyle(fontSize: 20, color: textPrimaryColor),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: Text(getTranslated(context, StringKeys.yes)),
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    Navigator.pop(builderContext);
                                    await adminRepository
                                        .deleteCategory(adminRepository.selectedCategory!.id)
                                        .then((response) {
                                      if (response.isSuccessful) {
                                        AppFunctions.showSnackbar(
                                            context, getTranslated(context, StringKeys.theOperationIsSuccessful),
                                            backgroundColor: successDark, icon: Icons.check_circle);
                                        Navigator.pop(context);
                                      } else {
                                        AppFunctions.showSnackbar(
                                            context, getTranslated(context, StringKeys.somethingWentWrong),
                                            backgroundColor: dangerDark, icon: Icons.cancel);
                                      }
                                    });
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: Text(getTranslated(context, StringKeys.no)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                icon: Icon(
                  CupertinoIcons.delete_solid,
                  color: Colors.red.shade100,
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormFieldComponent(
                  hintText: getTranslated(context, StringKeys.categoryName),
                  context: context,
                  textEditingController: textEditingController,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: adminRepository.selectedCategory == null
                      ? null
                      : () async {
                          if (textEditingController.text.trim().isNotEmpty &&
                              adminRepository.selectedCategory != null) {
                            setState(() {
                              isLoading = true;
                            });

                            CategoryModel categoryModel = CategoryModel(
                                id: adminRepository.selectedCategory!.id, name: textEditingController.text.trim());
                            await adminRepository.updateCategory(categoryModel).then((response) {
                              if (response.isSuccessful) {
                                AppFunctions.showSnackbar(
                                    context, getTranslated(context, StringKeys.theOperationIsSuccessful),
                                    backgroundColor: successDark, icon: Icons.check_circle);
                                Navigator.pop(context);
                              } else {
                                AppFunctions.showSnackbar(
                                    context, getTranslated(context, StringKeys.somethingWentWrong),
                                    backgroundColor: dangerDark, icon: Icons.cancel);
                              }
                            });
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.pleaseFillInAllFields),
                                backgroundColor: warningDark, icon: Icons.edit);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    getTranslated(context, StringKeys.update),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
