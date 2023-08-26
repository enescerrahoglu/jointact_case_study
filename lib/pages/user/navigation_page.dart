import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/pages/user/basket_page.dart';
import 'package:jointact_case_study/pages/user/profile_page.dart';
import 'package:jointact_case_study/pages/user/user_home_page.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/user_repository.dart';
import 'package:jointact_case_study/widgets/loading_widget.dart';

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({super.key});

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  int selectedPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    return Stack(
      children: [
        Scaffold(
          body: IndexedStack(
            index: selectedPageIndex,
            children: const [
              UserHomePage(),
              BasketPage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedPageIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedPageIndex = index;
              });
            },
            destinations: <NavigationDestination>[
              NavigationDestination(
                icon: const Icon(
                  CupertinoIcons.house_alt,
                  size: 26,
                  color: primaryColor,
                ),
                selectedIcon: const Icon(
                  CupertinoIcons.house_alt_fill,
                  size: 26,
                  color: primaryColor,
                ),
                label: getTranslated(context, StringKeys.home),
                tooltip: "",
              ),
              NavigationDestination(
                icon: const Icon(
                  CupertinoIcons.cart,
                  size: 26,
                  color: primaryColor,
                ),
                selectedIcon: const Icon(
                  CupertinoIcons.cart_fill,
                  size: 26,
                  color: primaryColor,
                ),
                label: getTranslated(context, StringKeys.basket),
                tooltip: "",
              ),
              NavigationDestination(
                icon: const Icon(
                  CupertinoIcons.person,
                  size: 26,
                  color: primaryColor,
                ),
                selectedIcon: const Icon(
                  CupertinoIcons.person_solid,
                  size: 26,
                  color: primaryColor,
                ),
                label: getTranslated(context, StringKeys.profile),
                tooltip: "",
              ),
            ],
          ),
        ),
        LoadingWidget(isLoading: userRepository.isLoading),
      ],
    );
  }
}
