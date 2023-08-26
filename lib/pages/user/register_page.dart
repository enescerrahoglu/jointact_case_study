import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/components/button_component.dart';
import 'package:jointact_case_study/components/text_form_field_component.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/app_functions.dart';
import 'package:jointact_case_study/helpers/shared_preferences_helper.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/models/user_model.dart';
import 'package:jointact_case_study/pages/user/navigation_page.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/user_repository.dart';
import 'package:jointact_case_study/widgets/app_bar_widget.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController surnameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController mailTextEditingController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameTextEditingController.dispose();
    surnameTextEditingController.dispose();
    phoneTextEditingController.dispose();
    mailTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBarWidget(title: getTranslated(context, StringKeys.register)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormFieldComponent(
                context: context,
                textEditingController: nameTextEditingController,
                hintText: getTranslated(context, StringKeys.name),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10),
              TextFormFieldComponent(
                context: context,
                textEditingController: surnameTextEditingController,
                hintText: getTranslated(context, StringKeys.surname),
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10),
              TextFormFieldComponent(
                context: context,
                textEditingController: phoneTextEditingController,
                hintText: getTranslated(context, StringKeys.phone),
                keyboardType: TextInputType.number,
                numbersOnly: true,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 10),
              TextFormFieldComponent(
                context: context,
                textEditingController: mailTextEditingController,
                hintText: getTranslated(context, StringKeys.mail),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              ButtonComponent(
                text: getTranslated(context, StringKeys.register),
                isWide: true,
                isLoading: isLoading,
                onPressed: () {
                  if (_checkInformations()) {
                    setState(() {
                      isLoading = true;
                    });
                    UserModel userModel = UserModel(
                      id: 0,
                      name: nameTextEditingController.text.trim(),
                      surname: surnameTextEditingController.text.trim(),
                      phone: phoneTextEditingController.text.trim(),
                      mail: mailTextEditingController.text.trim(),
                    );
                    userRepository.createUser(userModel).then((response) async {
                      if (response.isSuccessful) {
                        await SharedPreferencesHelper.setString("createdUserModel", userModel.toJson()).then((value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NavigationPage(),
                              ),
                              (route) => false);
                        });
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _checkInformations() {
    if (nameTextEditingController.text.trim().isEmpty ||
        surnameTextEditingController.text.trim().isEmpty ||
        phoneTextEditingController.text.trim().isEmpty ||
        mailTextEditingController.text.trim().isEmpty) {
      AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.pleaseFillInAllFields),
          backgroundColor: warningDark, icon: Icons.edit);
      return false;
    } else {
      return true;
    }
  }
}
