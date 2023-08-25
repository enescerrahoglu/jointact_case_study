import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/components/text_form_field_component.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/app_functions.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/models/product_model.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/admin_repository.dart';
import 'package:jointact_case_study/widgets/loading_widget.dart';

class UpdateProductPage extends ConsumerStatefulWidget {
  const UpdateProductPage({super.key});

  @override
  ConsumerState<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends ConsumerState<UpdateProductPage> {
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
  void initState() {
    super.initState();

    if (ref.read(adminProvider).selectedProduct != null) {
      ProductModel productModel = ref.read(adminProvider).selectedProduct!;
      nameTextEditingController.text = productModel.name;
      descriptionTextEditingController.text = productModel.description;
      priceTextEditingController.text = productModel.price.toString();
      videoUrlTextEditingController.text = productModel.productVideoLink;
      selectedCategoryId = productModel.categoryId;
      if (ref.read(adminProvider).currencyList.isNotEmpty) {
        selectedCurrencyIndex = ref.read(adminProvider).currencyList.indexOf(
            ref.read(adminProvider).currencyList.where((element) => element.id == productModel.currencyId).first);
      }
      _base64Image = productModel.imageBase64;
    }
  }

  @override
  void dispose() {
    nameTextEditingController.dispose();
    descriptionTextEditingController.dispose();
    priceTextEditingController.dispose();
    videoUrlTextEditingController.dispose();
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
              getTranslated(context, StringKeys.updateProduct),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                onPressed: adminRepository.selectedProduct == null
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
                              title: Text(getTranslated(context, StringKeys.aysDeleteProduct)),
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
                                    if (adminRepository.selectedProduct != null) {
                                      await adminRepository
                                          .deleteProduct(adminRepository.selectedProduct!.id)
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
                                    }
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
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 1),
                        ),
                      ],
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
                          child: (_selectedImage == null && _base64Image == null)
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
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      onDismissed: (direction) {
                                        setState(() {
                                          _selectedImage = null;
                                          _base64Image = null;
                                        });
                                      },
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: _selectedImage != null
                                            ? Image.file(
                                                _selectedImage!,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.memory(
                                                base64Decode(adminRepository.selectedProduct!.imageBase64),
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
                ElevatedButton(
                  onPressed: () async {
                    if (_checkInformations() && adminRepository.selectedProduct != null) {
                      setState(() {
                        isLoading = true;
                      });
                      if (_selectedImage != null) {
                        _convertToBase64();
                      }
                      ProductModel productModel = ProductModel(
                        id: adminRepository.selectedProduct!.id,
                        categoryId: selectedCategoryId ?? 0,
                        name: nameTextEditingController.text.trim(),
                        description: descriptionTextEditingController.text.trim(),
                        imageBase64: _base64Image ?? "",
                        price: int.parse(priceTextEditingController.text.trim()),
                        currencyId: adminRepository.currencyList[selectedCurrencyIndex].id,
                        productVideoLink: videoUrlTextEditingController.text.trim(),
                      );
                      await adminRepository.updateProduct(productModel).then((response) {
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

  bool _checkInformations() {
    if (ref.read(adminProvider).currencyList.isEmpty ||
        ref.read(adminProvider).categoryList.isEmpty ||
        nameTextEditingController.text.trim().isEmpty ||
        descriptionTextEditingController.text.trim().isEmpty ||
        priceTextEditingController.text.trim().isEmpty ||
        videoUrlTextEditingController.text.trim().isEmpty ||
        (_selectedImage == null && _base64Image == null) ||
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
