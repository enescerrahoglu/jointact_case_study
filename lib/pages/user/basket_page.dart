import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/user_repository.dart';
import 'package:jointact_case_study/widgets/app_bar_widget.dart';

class BasketPage extends ConsumerStatefulWidget {
  const BasketPage({super.key});

  @override
  ConsumerState<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends ConsumerState<BasketPage> {
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    userRepository.selectedCategory == null;
    return Scaffold(
      appBar: AppBarWidget(
        title: getTranslated(context, StringKeys.basket),
      ),
      body: Center(
        child: Text(
          getTranslated(context, StringKeys.basket),
        ),
      ),
    );
  }
}
