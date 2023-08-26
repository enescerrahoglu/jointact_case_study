import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/image_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/shared_preferences_helper.dart';
import 'package:jointact_case_study/helpers/ui_helper.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/models/user_model.dart';
import 'package:jointact_case_study/pages/admin/admin_home_page.dart';
import 'package:jointact_case_study/pages/user/navigation_page.dart';
import 'package:jointact_case_study/pages/user/register_page.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/user_repository.dart';

class RedirectPage extends ConsumerStatefulWidget {
  const RedirectPage({super.key});

  @override
  ConsumerState<RedirectPage> createState() => _RedirectPageState();
}

class _RedirectPageState extends ConsumerState<RedirectPage> {
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        toolbarHeight: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
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
                    onTap: () async {
                      await SharedPreferencesHelper.getString("createdUserModel").then((value) {
                        String? createdUserJson = value;
                        if (createdUserJson != null) {
                          userRepository.createdUserModel = UserModel.fromJson(createdUserJson);
                          if (userRepository.createdUserModel != null) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NavigationPage(),
                              ),
                              (route) => false,
                            );
                          }
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                            (route) => false,
                          );
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            IconAssetKeys.user,
                            width: UIHelper.getDeviceWidth(context) / 4,
                            color: primaryColor,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            getTranslated(context, StringKeys.user),
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(color: primaryColor, height: 50),
              Container(
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminHomePage(),
                        ),
                        (route) => false,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            IconAssetKeys.userTie,
                            width: UIHelper.getDeviceWidth(context) / 4,
                            color: primaryColor,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            getTranslated(context, StringKeys.admin),
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
