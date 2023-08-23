import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/models/response_model.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/widgets/loading_widget.dart';

class AdminHomePage extends ConsumerStatefulWidget {
  const AdminHomePage({super.key});

  @override
  ConsumerState<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<AdminHomePage> {
  bool isLoading = false;
  ResponseModel? categoriesResponse;

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
            leading: IconButton(
              icon:
                  const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("data: ${categoriesResponse?.data}"),
                Text("message: ${categoriesResponse?.message}"),
                Text("result: ${categoriesResponse?.result}"),
                Text("isSuccessful: ${categoriesResponse?.isSuccessful}"),
              ],
            ),
          ),
        ),
        LoadingWidget(isLoading: isLoading),
      ],
    );
  }
}
