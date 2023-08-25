import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/components/button_component.dart';
import 'package:jointact_case_study/components/text_form_field_component.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/app_functions.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/models/category_model.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/admin_repository.dart';
import 'package:jointact_case_study/widgets/app_bar_widget.dart';
import 'package:jointact_case_study/widgets/loading_widget.dart';

class CreateCategoryPage extends ConsumerStatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  ConsumerState<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends ConsumerState<CreateCategoryPage> {
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
            title: getTranslated(context, StringKeys.createCategory),
            leadingIcon: Icons.arrow_back_ios_rounded,
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
                ButtonComponent(
                  text: getTranslated(context, StringKeys.add),
                  isWide: true,
                  onPressed: () async {
                    if (textEditingController.text.trim().isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                      CategoryModel categoryModel = CategoryModel(id: 0, name: textEditingController.text.trim());
                      await adminRepository.createCategory(categoryModel).then((response) {
                        if (response.isSuccessful) {
                          AppFunctions.showSnackbar(
                              context, getTranslated(context, StringKeys.theOperationIsSuccessful),
                              backgroundColor: successDark, icon: Icons.check_circle);
                          Navigator.pop(context);
                        } else {
                          AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.somethingWentWrong),
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
