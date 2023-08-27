import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/image_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/ui_helper.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/pages/redirect_page.dart';
import 'package:jointact_case_study/pages/settings_page.dart';
import 'package:jointact_case_study/pages/user/orders_page.dart';
import 'package:jointact_case_study/providers/providers.dart';
import 'package:jointact_case_study/repositories/user_repository.dart';
import 'package:jointact_case_study/widgets/app_bar_widget.dart';
import 'package:jointact_case_study/widgets/list_tile_widget.dart';

/// Bu sayfa kayıt olan kullanıcın bilgilerini gösterir.
/// Ayrıca siparişler ve ayarlar sayfalarına yönlendirme yapan ve çıkış yapmayı sağlayan tıklanabilir yapılar içerir.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    UserRepository userRepository = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBarWidget(title: getTranslated(context, StringKeys.profile)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: itemBackgroundColor,
                boxShadow: UIHelper.boxShadow,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: UIHelper.getDeviceWidth(context) / 4,
                    height: UIHelper.getDeviceWidth(context) / 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(500)),
                        color: Colors.white,
                        boxShadow: UIHelper.boxShadow,
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(500)),
                        child: Image.asset(ImageAssetKeys.profilePhoto),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${userRepository.createdUserModel?.name ?? ""} ${userRepository.createdUserModel?.surname ?? ""}",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            ListTileWidget(
              content: userRepository.createdUserModel?.mail ?? "",
              iconData: CupertinoIcons.mail_solid,
            ),
            const SizedBox(height: 10),
            ListTileWidget(
              content: userRepository.createdUserModel?.phone ?? "",
              iconData: CupertinoIcons.phone_solid,
            ),
            const SizedBox(height: 10),
            ListTileWidget(
              content: getTranslated(context, StringKeys.orders),
              iconData: Icons.shopping_bag,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OrdersPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ListTileWidget(
              content: getTranslated(context, StringKeys.settings),
              iconData: Icons.settings,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            ListTileWidget(
              content: getTranslated(context, StringKeys.logOut),
              iconData: CupertinoIcons.square_arrow_left_fill,
              onTap: () async {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RedirectPage(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
