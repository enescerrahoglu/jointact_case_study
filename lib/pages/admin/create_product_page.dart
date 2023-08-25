import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/components/button_component.dart';
import 'package:jointact_case_study/components/text_form_field_component.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/app_functions.dart';
import 'package:jointact_case_study/helpers/ui_helper.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/models/product_model.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/admin_repository.dart';
import 'package:jointact_case_study/widgets/app_bar_widget.dart';
import 'package:jointact_case_study/widgets/dropdown_item_widget.dart';
import 'package:jointact_case_study/widgets/loading_widget.dart';

class CreateProductPage extends ConsumerStatefulWidget {
  const CreateProductPage({super.key});

  @override
  ConsumerState<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends ConsumerState<CreateProductPage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();
  TextEditingController videoUrlTextEditingController = TextEditingController();
  bool isLoading = false;
  int? selectedCategoryId;
  int selectedCurrencyIndex = 0;
  File? _selectedImage;
  String? _base64Image;

  @override
  void dispose() {
    nameTextEditingController.dispose();
    descriptionTextEditingController.dispose();
    priceTextEditingController.dispose();
    videoUrlTextEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      setState(() {
        isLoading = true;
      });
      if (ref.read(adminProvider).currencyList.isEmpty) {
        await ref.read(adminProvider).getCurrencies().then((response) {
          if (response.isSuccessful == false) {
            AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.errorFetchingCurrencies),
                backgroundColor: dangerDark, icon: Icons.cancel);
          }
        });
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AdminRepository adminRepository = ref.watch(adminProvider);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBarWidget(
            title: getTranslated(context, StringKeys.createProduct),
            leadingIcon: Icons.arrow_back_ios_rounded,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormFieldComponent(
                  hintText: getTranslated(context, StringKeys.productName),
                  context: context,
                  textEditingController: nameTextEditingController,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 10),
                TextFormFieldComponent(
                  hintText: getTranslated(context, StringKeys.description),
                  context: context,
                  textEditingController: descriptionTextEditingController,
                  textCapitalization: TextCapitalization.sentences,
                ),
                adminRepository.categoryList.isEmpty
                    ? const SizedBox()
                    : Column(
                        children: [
                          const SizedBox(height: 10),
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
                                      getTranslated(context, StringKeys.category),
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
                adminRepository.currencyList.isEmpty
                    ? const SizedBox()
                    : Column(
                        children: [
                          const SizedBox(height: 10),
                          TextFormFieldComponent(
                            hintText: getTranslated(context, StringKeys.price),
                            context: context,
                            textEditingController: priceTextEditingController,
                            keyboardType: TextInputType.number,
                            numbersOnly: true,
                            maxCharacter: 10,
                            suffixIcon: Tooltip(
                              message: adminRepository.currencyList[selectedCurrencyIndex].name,
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (selectedCurrencyIndex < adminRepository.currencyList.length - 1) {
                                      selectedCurrencyIndex++;
                                    } else {
                                      selectedCurrencyIndex = 0;
                                    }
                                  });
                                },
                                child: Text(
                                  adminRepository.currencyList[selectedCurrencyIndex].symbol,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 10),
                TextFormFieldComponent(
                  hintText: getTranslated(context, StringKeys.videoUrl),
                  context: context,
                  textEditingController: videoUrlTextEditingController,
                ),
                const SizedBox(height: 10),
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: itemBackgroundColor,
                      boxShadow: UIHelper.boxShadow,
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          AppFunctions().showMediaSnackbar(context, () {
                            AppFunctions().pickImageFromCamera().then((file) {
                              setState(() {
                                _selectedImage = file;
                              });
                            });
                          }, () {
                            AppFunctions().pickImageFromGallery().then((file) {
                              setState(() {
                                _selectedImage = file;
                              });
                            });
                          });
                        },
                        child: Center(
                          child: _selectedImage == null
                              ? const Center(
                                  child: Icon(
                                    Icons.image_outlined,
                                    size: 50,
                                    color: primaryColor,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Dismissible(
                                      key: const Key("productImage"),
                                      direction: DismissDirection.horizontal,
                                      background: Container(
                                        decoration: const BoxDecoration(color: danger),
                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported_outlined,
                                            size: 50,
                                            color: buttonForegroundColor,
                                          ),
                                        ),
                                      ),
                                      onDismissed: (direction) {
                                        setState(() {
                                          _selectedImage = null;
                                        });
                                      },
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.file(
                                          _selectedImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ButtonComponent(
                  text: getTranslated(context, StringKeys.add),
                  onPressed: () async {
                    if (_checkInformations()) {
                      setState(() {
                        isLoading = true;
                      });
                      if (_selectedImage != null) {
                        _convertToBase64();
                      }

                      ProductModel productModel = ProductModel(
                        id: 0,
                        categoryId: selectedCategoryId ?? 0,
                        name: nameTextEditingController.text.trim(),
                        description: descriptionTextEditingController.text.trim(),
                        imageBase64: _base64Image ?? "",
                        price: int.parse(priceTextEditingController.text.trim()),
                        currencyId: adminRepository.currencyList[selectedCurrencyIndex].id,
                        productVideoLink: videoUrlTextEditingController.text.trim(),
                      );
                      await adminRepository.createProduct(productModel).then((response) {
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
                    }
                  },
                  isWide: true,
                ),
              ],
            ),
          ),
        ),
        LoadingWidget(isLoading: isLoading),
      ],
    );
  }

  bool _checkInformations() {
    if (ref.read(adminProvider).currencyList.isEmpty ||
        ref.read(adminProvider).categoryList.isEmpty ||
        nameTextEditingController.text.trim().isEmpty ||
        descriptionTextEditingController.text.trim().isEmpty ||
        priceTextEditingController.text.trim().isEmpty ||
        videoUrlTextEditingController.text.trim().isEmpty ||
        _selectedImage == null ||
        selectedCategoryId == null) {
      AppFunctions.showSnackbar(context, getTranslated(context, StringKeys.pleaseFillInAllFields),
          backgroundColor: warningDark, icon: Icons.edit);
      return false;
    } else {
      return true;
    }
  }

  void _convertToBase64() {
    if (_selectedImage != null) {
      final bytes = _selectedImage!.readAsBytesSync();
      final base64String = base64Encode(bytes);
      setState(() {
        _base64Image = base64String;
      });
    }
  }
}
