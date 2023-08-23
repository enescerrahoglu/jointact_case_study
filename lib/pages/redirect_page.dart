import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jointact_case_study/components/button_component.dart';
import 'package:jointact_case_study/constants/image_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/ui_helper.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/pages/admin/admin_home_page.dart';
import 'package:jointact_case_study/pages/customer/customer_home_page.dart';

class RedirectPage extends StatefulWidget {
  const RedirectPage({super.key});

  @override
  State<RedirectPage> createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  SvgPicture.asset(
                    IconAssetKeys.user,
                    width: UIHelper.getDeviceWidth(context) / 4,
                    color: Colors.deepPurple,
                  ),
                  ButtonComponent(
                    text: getTranslated(context, StringKeys.customer),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerHomePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.deepPurple, height: 50),
            Center(
              child: Column(
                children: [
                  SvgPicture.asset(
                    IconAssetKeys.userTie,
                    width: UIHelper.getDeviceWidth(context) / 4,
                    color: Colors.deepPurple,
                  ),
                  ButtonComponent(
                    text: getTranslated(context, StringKeys.admin),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminHomePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
